From: akpm@linux-foundation.org
Subject: - mlock-mlocked-pages-are-unevictable-fix-4.patch removed from -mm tree
Date: Mon, 28 Jul 2008 16:58:55 -0700
Message-ID: <200807282358.m6SNwuxm002870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbYG1X7B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 19:59:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mlock-mlocked-pages-are-unevictable-fix-4
has been removed from the -mm tree.  Its filename was
     mlock-mlocked-pages-are-unevictable-fix-4.patch

This patch was dropped because it was folded into mlock-mlocked-pages-are-unevictable.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock-mlocked-pages-are-unevictable-fix-4
From: Hugh Dickins <hugh@veritas.com>

I trust you put Linus on unpaid leave for this week, for his poor
judgement in chucking that horrid patch from Russ into 2.6.26.

You may do best just to revert it (I don't even like the result myself)
and then omit the fixups it has demanded; but if you're sticking by
it, then I'm afraid it's still not right - the screen floods with
bad page state messages at startup, because you put PG_swapbacked
into PAGE_FLAGS, you naive man: did you think it's a page flag???
No, it's a PAGE_FLAGS_CLEAR_WHEN_BAD and a PAGE_FLAGS_CHECK_AT_PREP.

Here's a fix to the final result, to
mlock-mlocked-pages-are-unevictable-fix-3.patch
but of course that leaves breakage amidst the earlier ones:
if I were really conscientious I'd supply you with little patches
to the intervening stages too, but I'm tired, and I think you'll find
it a lot easier to do yourself than fiddle around with bits from me.

With this and those build fixes, I do have mmotm running on i386 and
x86_64 and powerpc (I folded in Kosaki's 10/10 and Balbir's 1-5).
I've several little -rc5-mm3/mmotm fixes for you, mainly related to
tmpfs and memcgroups, but never quite get to assemble them, and
most people seem to be managing without them.  Tomorrow...

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/page-flags.h~mlock-mlocked-pages-are-unevictable-fix-4 include/linux/page-flags.h
--- a/include/linux/page-flags.h~mlock-mlocked-pages-are-unevictable-fix-4
+++ a/include/linux/page-flags.h
@@ -378,13 +378,14 @@ static inline void __ClearPageTail(struc
 #define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
 			 1 << PG_buddy | 1 << PG_writeback | \
 			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active | \
-			 1 << PG_swapbacked | __PG_UNEVICTABLE | __PG_MLOCKED)
+			 __PG_UNEVICTABLE | __PG_MLOCKED)
 
 /*
  * Flags checked in bad_page().  Pages on the free list should not have
  * these flags set.  It they are, there is a problem.
  */
-#define PAGE_FLAGS_CLEAR_WHEN_BAD (PAGE_FLAGS | 1 << PG_reclaim | 1 << PG_dirty)
+#define PAGE_FLAGS_CLEAR_WHEN_BAD (PAGE_FLAGS | \
+		1 << PG_reclaim | 1 << PG_dirty | 1 << PG_swapbacked)
 
 /*
  * Flags checked when a page is freed.  Pages being freed should not have
@@ -397,7 +398,8 @@ static inline void __ClearPageTail(struc
  * Pages being prepped should not have these flags set.  It they are, there
  * is a problem.
  */
-#define PAGE_FLAGS_CHECK_AT_PREP (PAGE_FLAGS | 1 << PG_reserved | 1 << PG_dirty)
+#define PAGE_FLAGS_CHECK_AT_PREP (PAGE_FLAGS | \
+		1 << PG_reserved | 1 << PG_dirty | 1 << PG_swapbacked)
 
 #endif /* !__GENERATING_BOUNDS_H */
 #endif	/* PAGE_FLAGS_H */
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
exec-include-pagemaph-again-to-fix-build.patch
tmpfs-fix-kernel-bug-in-shmem_delete_inode.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
vfs-increase-pseudo-filesystem-block-size-to-page_size.patch
powerpc-lockless-get_user_pages.patch
git-unionfs.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix-4.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
mmapc-deinline-a-few-functions.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch
gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch
prio_tree-debugging-patch.patch

