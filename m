From: akpm@linux-foundation.org
Subject: + fs-bufferc-remove-bug-in-possible-but-rare-condition.patch added to -mm tree
Date: Thu, 12 Apr 2012 16:42:14 -0700
Message-ID: <20120412234214.EBDE3A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:59696 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758177Ab2DLXmQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Apr 2012 19:42:16 -0400
Received: by yenq2 with SMTP id q2so316459yen.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Apr 2012 16:42:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, mhocko@suse.cz


The patch titled
     Subject: fs/buffer.c: remove BUG() in possible but rare condition
has been added to the -mm tree.  Its filename is
     fs-bufferc-remove-bug-in-possible-but-rare-condition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: fs/buffer.c: remove BUG() in possible but rare condition

While stressing the kernel with with failing allocations today, I hit the
following chain of events:

alloc_page_buffers():

	bh = alloc_buffer_head(GFP_NOFS);
	if (!bh)
		goto no_grow; <= path taken

grow_dev_page():
        bh = alloc_page_buffers(page, size, 0);
        if (!bh)
                goto failed;  <= taken, consequence of the above

and then the failed path BUG()s the kernel.

The failure is inserted a litte bit artificially, but even then, I see no
reason why it should be deemed impossible in a real box.

Even though this is not a condition that we expect to see around every
time, failed allocations are expected to be handled, and BUG() sounds just
too much.  As a matter of fact, grow_dev_page() can return NULL just fine
in other circumstances, so I propose we just remove it, then.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/buffer.c~fs-bufferc-remove-bug-in-possible-but-rare-condition fs/buffer.c
--- a/fs/buffer.c~fs-bufferc-remove-bug-in-possible-but-rare-condition
+++ a/fs/buffer.c
@@ -985,7 +985,6 @@ grow_dev_page(struct block_device *bdev,
 	return page;
 
 failed:
-	BUG();
 	unlock_page(page);
 	page_cache_release(page);
 	return NULL;
_
Subject: Subject: fs/buffer.c: remove BUG() in possible but rare condition

Patches currently in -mm which might be from glommer@parallels.com are

memcg-do-not-open-code-accesses-to-res_counter-members.patch
linux-next.patch
fs-bufferc-remove-bug-in-possible-but-rare-condition.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch

