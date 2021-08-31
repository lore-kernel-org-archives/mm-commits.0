Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBF5C43214
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 20:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FA6561074
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 20:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235207AbhHaUTo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Aug 2021 16:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240094AbhHaUTm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 31 Aug 2021 16:19:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B57A361057;
        Tue, 31 Aug 2021 20:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630441127;
        bh=3Z6QvMM77RWiyoLBMRHPn23e8ETXtUvqzaTQbwu2HJk=;
        h=Date:From:To:Subject:From;
        b=GW5ehWSDPfBSIAPgNoR+n07qUICuqqp6Lyrxt52gVpMTPnkq+liEjiZXxymr7fhQF
         Rpp3cTn39jiZZcwSFJPYm5+FheIF4uk46y+2S5fHEeDwYXZrYprmJgbC3gOySXJjxQ
         wvnhxjFjoXqKfXoYC5g4aTXtGkHmQZklaS6cjp9Y=
Date:   Tue, 31 Aug 2021 13:18:46 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, tj@kernel.org
Subject:  + memcg-make-memcg-event_list_lock-irqsafe.patch added to
 -mm tree
Message-ID: <20210831201846.5iWasRvj0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: make memcg->event_list_lock irqsafe
has been added to the -mm tree.  Its filename is
     memcg-make-memcg-event_list_lock-irqsafe.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-make-memcg-event_list_lock-irqsafe.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-make-memcg-event_list_lock-irqsafe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

writeback-memcg-simplify-cgroup_writeback_by_id.patch
memcg-switch-lruvec-stats-to-rstat.patch
memcg-infrastructure-to-flush-memcg-stats.patch
memcg-infrastructure-to-flush-memcg-stats-v5.patch
memcg-cleanup-racy-sum-avoidance-code.patch
memcg-make-memcg-event_list_lock-irqsafe.patch

