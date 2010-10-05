From: akpm@linux-foundation.org
Subject: + rmap-wrap-page_check_address-using-__cond_lock.patch added to -mm tree
Date: Tue, 05 Oct 2010 14:28:14 -0700
Message-ID: <201010052128.o95LSEpq021089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565Ab0JEVbD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 17:31:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com


The patch titled
     rmap: wrap page_check_address() using __cond_lock()
has been added to the -mm tree.  Its filename is
     rmap-wrap-page_check_address-using-__cond_lock.patch

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
Subject: rmap: wrap page_check_address() using __cond_lock()
From: Namhyung Kim <namhyung@gmail.com>

The page_check_address() conditionally grabs *@ptlp in case of returning
non-NULL.  Rename and wrap it using __cond_lock() removes following
warnings from sparse:

 mm/rmap.c:472:9: warning: context imbalance in 'page_mapped_in_vma' - unexpected unlock
 mm/rmap.c:524:9: warning: context imbalance in 'page_referenced_one' - unexpected unlock
 mm/rmap.c:706:9: warning: context imbalance in 'page_mkclean_one' - unexpected unlock
 mm/rmap.c:1066:9: warning: context imbalance in 'try_to_unmap_one' - unexpected unlock

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   13 ++++++++++++-
 mm/rmap.c            |    2 +-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff -puN include/linux/rmap.h~rmap-wrap-page_check_address-using-__cond_lock include/linux/rmap.h
--- a/include/linux/rmap.h~rmap-wrap-page_check_address-using-__cond_lock
+++ a/include/linux/rmap.h
@@ -205,9 +205,20 @@ int try_to_unmap_one(struct page *, stru
 /*
  * Called from mm/filemap_xip.c to unmap empty zero page
  */
-pte_t *page_check_address(struct page *, struct mm_struct *,
+pte_t *__page_check_address(struct page *, struct mm_struct *,
 				unsigned long, spinlock_t **, int);
 
+static inline pte_t *page_check_address(struct page *page, struct mm_struct *mm,
+					unsigned long address,
+					spinlock_t **ptlp, int sync)
+{
+	pte_t *ptep;
+
+	__cond_lock(*ptlp, ptep = __page_check_address(page, mm, address,
+						       ptlp, sync));
+	return ptep;
+}
+
 /*
  * Used by swapoff to help locate where page is expected in vma.
  */
diff -puN mm/rmap.c~rmap-wrap-page_check_address-using-__cond_lock mm/rmap.c
--- a/mm/rmap.c~rmap-wrap-page_check_address-using-__cond_lock
+++ a/mm/rmap.c
@@ -409,7 +409,7 @@ unsigned long page_address_in_vma(struct
  *
  * On success returns with pte mapped and locked.
  */
-pte_t *page_check_address(struct page *page, struct mm_struct *mm,
+pte_t *__page_check_address(struct page *page, struct mm_struct *mm,
 			  unsigned long address, spinlock_t **ptlp, int sync)
 {
 	pgd_t *pgd;
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
linux-next.patch
vfs-remove-a-warning-on-open_fmode.patch
vfs-add-__fmode_exec.patch
mm-cleanup-gfp_zone-fix-sparse-warnings.patch
mm-remove-temporary-variable-on-generic_file_direct_write.patch
mm-add-casts-to-from-gfp_t-in-gfp_to_alloc_flags.patch
mm-wrap-get_locked_pte-using-__cond_lock.patch
mm-add-lock-release-annotation-on-do_wp_page.patch
mm-wrap-follow_pte-using-__cond_lock.patch
rmap-annotate-lock-context-change-on-page_lock_anon_vma.patch
rmap-wrap-page_check_address-using-__cond_lock.patch
rmap-make-anon_vma_free-static.patch
vmalloc-rename-temporary-variable-in-__insert_vmap_area.patch
vmalloc-annotate-lock-context-change-on-s_start-stop.patch
mm-declare-some-external-symbols.patch
vmstat-include-compactionh-when-config_compaction.patch
vmstat-include-compactionh-when-config_compaction-fix.patch
init-mark-__user-address-space-on-string-literals.patch
kernel-userc-add-lock-release-annotation-on-free_user.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
ptrace-annotate-lock-context-change-on-exit_ptrace.patch
ptrace-change-signature-of-sys_ptrace-and-friends.patch
ptrace-cleanup-ptrace_request.patch
ptrace-change-signature-of-arch_ptrace.patch
ptrace-cleanup-arch_ptrace-on-x86.patch
ptrace-cleanup-arch_ptrace-on-arm.patch
ptrace-cleanup-arch_ptrace-on-avr32.patch
ptrace-cleanup-arch_ptrace-and-friends-on-blackfin.patch
ptrace-cleanup-arch_ptrace-on-cris.patch
ptrace-cleanup-arch_ptrace-on-frv.patch
ptrace-cleanup-arch_ptrace-on-h8300.patch
ptrace-cleanup-arch_ptrace-on-m32r.patch
ptrace-cleanup-arch_ptrace-on-m68k.patch
ptrace-cleanup-arch_ptrace-on-m68knommu.patch
ptrace-cleanup-arch_ptrace-on-microblaze.patch
ptrace-cleanup-arch_ptrace-on-mips.patch
ptrace-cleanup-arch_ptrace-on-mn10300.patch
ptrace-cleanup-arch_ptrace-on-parisc.patch
ptrace-cleanup-arch_ptrace-on-powerpc.patch
ptrace-cleanup-arch_ptrace-on-score.patch
ptrace-cleanup-arch_ptrace-on-sh.patch
ptrace-cleanup-arch_ptrace-on-sparc.patch
ptrace-cleanup-arch_ptrace-on-tile.patch
ptrace-cleanup-arch_ptrace-on-um.patch
ptrace-cleanup-arch_ptrace-on-xtensa.patch
signals-annotate-lock_task_sighand.patch
signals-annotate-lock-context-change-on-ptrace_stop.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch

