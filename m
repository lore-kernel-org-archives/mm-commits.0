From: akpm@linux-foundation.org
Subject: + memcg-move-charge-of-file-pages-fix-3.patch added to -mm tree
Date: Thu, 06 May 2010 12:57:19 -0700
Message-ID: <201005061957.o46JvK1h010480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757898Ab0EFT5p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 15:57:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, rdunlap@xenotime.net


The patch titled
     memcg-move-charge-of-file-pages-fix-3
has been added to the -mm tree.  Its filename is
     memcg-move-charge-of-file-pages-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-move-charge-of-file-pages-fix-3

Build fix for !CONFIG_SWAP case.

mm/built-in.o: In function `mem_cgroup_get_shmem_target':
(.text+0xde06): undefined reference to `swapper_space'

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/shmem.c~memcg-move-charge-of-file-pages-fix-3 mm/shmem.c
--- a/mm/shmem.c~memcg-move-charge-of-file-pages-fix-3
+++ a/mm/shmem.c
@@ -2591,10 +2591,12 @@ void mem_cgroup_get_shmem_target(struct 
 
 	spin_lock(&info->lock);
 	ptr = shmem_swp_entry(info, pgoff, NULL);
+#ifdef CONFIG_SWAP
 	if (ptr && ptr->val) {
 		entry.val = ptr->val;
 		page = find_get_page(&swapper_space, entry.val);
 	} else
+#endif
 		page = find_get_page(inode->i_mapping, pgoff);
 	if (ptr)
 		shmem_swp_unmap(ptr);
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

linux-next.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch
memcg-clean-up-move-charge.patch
memcg-move-charge-of-file-pages.patch
memcg-move-charge-of-file-pages-fix.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-move-charge-of-file-pages-fix-3.patch
memcg-update-documentation-v8.patch
memcg-rcu-lock-fix-v3.patch
memcg-make-oom-killer-a-no-op-when-no-killable-task-can-be-found.patch

