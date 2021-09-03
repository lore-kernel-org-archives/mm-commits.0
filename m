Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5CBC4332F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 499FC6113E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbhICU7Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242776AbhICU7N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D5F8610FD;
        Fri,  3 Sep 2021 20:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702693;
        bh=cJm6wXEQHbuo0gyOG4zXiCSbxF5e3GDXOcBh8p3F5N8=;
        h=Date:From:To:Subject:From;
        b=1tmW3TXG8gKypA6k+zwlQ2TtGnKCr1kRYYyBT7xHuXr+LwdM2i0Fwm5wTxMedCkIK
         jxUCcYz+/BdYRrQ+3UYwkb89Ed3aHoTrg/2JxpoDCMhxFQA82oH64qQhi9QZFqf7XP
         cpb3jOJSCjFdE5Uo9jhYvf77k8aOeAB4mC4LGw08=
Date:   Fri, 03 Sep 2021 13:58:13 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, tj@kernel.org
Subject:  [merged] memcg-make-memcg-event_list_lock-irqsafe.patch
 removed from -mm tree
Message-ID: <20210903205813.LF-u5yL3x%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: make memcg->event_list_lock irqsafe
has been removed from the -mm tree.  Its filename was
     memcg-make-memcg-event_list_lock-irqsafe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: make memcg->event_list_lock irqsafe

The memcg->event_list_lock is usually taken in the normal context but when
the userspace closes the corresponding eventfd, eventfd_release through
memcg_event_wake takes memcg->event_list_lock with interrupts disabled. 
This is not an issue on its own but it creates a nested dependency from
eventfd_ctx->wqh.lock to memcg->event_list_lock.

Independently, for unrelated eventfd, eventfd_signal() can be called in
the irq context, thus making eventfd_ctx->wqh.lock an irq lock.  For
example, FPGA DFL driver, VHOST VPDA driver and couple of VFIO drivers. 
This will force memcg->event_list_lock to be an irqsafe lock as well.

One way to break the nested dependency between eventfd_ctx->wqh.lock and
memcg->event_list_lock is to add an indirection.  However the simplest
solution would be to make memcg->event_list_lock irqsafe.  This is cgroup
v1 feature, is in maintenance and may get deprecated in near future.  So,
no need to add more code.

BTW this has been discussed previously [1] but there weren't irq users of
eventfd_signal() at the time.

[1] https://www.spinics.net/lists/cgroups/msg06248.html

Link: https://lkml.kernel.org/r/20210830172953.207257-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~memcg-make-memcg-event_list_lock-irqsafe
+++ a/mm/memcontrol.c
@@ -4839,9 +4839,9 @@ static ssize_t memcg_write_event_control
 
 	vfs_poll(efile.file, &event->pt);
 
-	spin_lock(&memcg->event_list_lock);
+	spin_lock_irq(&memcg->event_list_lock);
 	list_add(&event->list, &memcg->event_list);
-	spin_unlock(&memcg->event_list_lock);
+	spin_unlock_irq(&memcg->event_list_lock);
 
 	fdput(cfile);
 	fdput(efile);
@@ -5268,12 +5268,12 @@ static void mem_cgroup_css_offline(struc
 	 * Notify userspace about cgroup removing only after rmdir of cgroup
 	 * directory to avoid race between userspace and kernelspace.
 	 */
-	spin_lock(&memcg->event_list_lock);
+	spin_lock_irq(&memcg->event_list_lock);
 	list_for_each_entry_safe(event, tmp, &memcg->event_list, list) {
 		list_del_init(&event->list);
 		schedule_work(&event->remove);
 	}
-	spin_unlock(&memcg->event_list_lock);
+	spin_unlock_irq(&memcg->event_list_lock);
 
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
_

Patches currently in -mm which might be from shakeelb@google.com are


