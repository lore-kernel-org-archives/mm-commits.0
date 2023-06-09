Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D69E7C7EE45
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjFIX1T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbjFIX1F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B133583
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAEEA61ACC
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B495C433D2;
        Fri,  9 Jun 2023 23:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353223;
        bh=J8o69kV2pBYY7zKWqE3awBFi1utkB+ptNVlLc2buwpc=;
        h=Date:To:From:Subject:From;
        b=qF9yYU+zfaJvoBPla81rmO+AVi1wzYrTIdEC/FVa+DNUmthOopYHZ+B1P/DU3dvlT
         gsyG/iifrL2lhR7Un/2zYLxAvhzCm9PfbhL1B84oLu3djcg3WQ6kJj6+0oWVSbIndI
         XKqOuoIPv6OZ9WLJgNl1WIIV19iq3xrcHDeNNVIY=
Date:   Fri, 09 Jun 2023 16:27:02 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-oom-remove-explicit-wakeup-in-mem_cgroup_oom_synchronize.patch removed from -mm tree
Message-Id: <20230609232703.4B495C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg, oom: remove explicit wakeup in mem_cgroup_oom_synchronize()
has been removed from the -mm tree.  Its filename was
     memcg-oom-remove-explicit-wakeup-in-mem_cgroup_oom_synchronize.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: memcg, oom: remove explicit wakeup in mem_cgroup_oom_synchronize()
Date: Wed, 19 Apr 2023 03:07:39 +0000

Before commit 29ef680ae7c2 ("memcg, oom: move out_of_memory back to the
charge path"), all memcg oom killers were delayed to page fault path.  And
the explicit wakeup is used in this case:

thread A:
        ...
        if (locked) {           // complete oom-kill, hold the lock
                mem_cgroup_oom_unlock(memcg);
                ...
        }
        ...

thread B:
        ...

        if (locked && !memcg->oom_kill_disable) {
                ...
        } else {
                schedule();     // can't acquire the lock
                ...
        }
        ...

The reason is that thread A kicks off the OOM-killer, which leads to
wakeups from the uncharges of the exiting task.  But thread B is not
guaranteed to see them if it enters the OOM path after the OOM kills but
before thread A releases the lock.

Now only oom_kill_disable case is handled from the #PF path.  In that case
it is userspace to trigger the wake up not the #PF path itself.  All
potential paths to free some charges are responsible to call
memcg_oom_recover() , so the explicit wakeup is not needed in the
mem_cgroup_oom_synchronize() path which doesn't release any memory itself.

Link: https://lkml.kernel.org/r/20230419030739.115845-2-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/mm/memcontrol.c~memcg-oom-remove-explicit-wakeup-in-mem_cgroup_oom_synchronize
+++ a/mm/memcontrol.c
@@ -2028,15 +2028,8 @@ bool mem_cgroup_oom_synchronize(bool han
 	mem_cgroup_unmark_under_oom(memcg);
 	finish_wait(&memcg_oom_waitq, &owait.wait);
 
-	if (locked) {
+	if (locked)
 		mem_cgroup_oom_unlock(memcg);
-		/*
-		 * There is no guarantee that an OOM-lock contender
-		 * sees the wakeups triggered by the OOM kill
-		 * uncharges.  Wake any sleepers explicitly.
-		 */
-		memcg_oom_recover(memcg);
-	}
 cleanup:
 	current->memcg_in_oom = NULL;
 	css_put(&memcg->css);
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

mm-mm_initc-drop-nid-parameter-from-check_for_memory.patch
mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch
mm-mm_initc-remove-reset_node_present_pages.patch
fork-optimize-memcg_charge_kernel_stack-a-bit.patch

