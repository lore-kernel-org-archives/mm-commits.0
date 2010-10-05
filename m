From: akpm@linux-foundation.org
Subject: + mm-wrap-get_locked_pte-using-__cond_lock.patch added to -mm tree
Date: Tue, 05 Oct 2010 14:28:06 -0700
Message-ID: <201010052128.o95LS6UT021077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755675Ab0JEV2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 17:28:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com


The patch titled
     mm: wrap get_locked_pte() using __cond_lock()
has been added to the -mm tree.  Its filename is
     mm-wrap-get_locked_pte-using-__cond_lock.patch

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
Subject: mm: wrap get_locked_pte() using __cond_lock()
From: Namhyung Kim <namhyung@gmail.com>

The get_locked_pte() conditionally grabs 'ptl' in case of returning
non-NULL.  This leads sparse to complain about context imbalance.  Rename
and wrap it using __cond_lock() to make sparse happy.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   10 +++++++++-
 mm/memory.c        |    2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-wrap-get_locked_pte-using-__cond_lock include/linux/mm.h
--- a/include/linux/mm.h~mm-wrap-get_locked_pte-using-__cond_lock
+++ a/include/linux/mm.h
@@ -1026,7 +1026,15 @@ extern void unregister_shrinker(struct s
 
 int vma_wants_writenotify(struct vm_area_struct *vma);
 
-extern pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr, spinlock_t **ptl);
+extern pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
+			       spinlock_t **ptl);
+static inline pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
+				    spinlock_t **ptl)
+{
+	pte_t *ptep;
+	__cond_lock(*ptl, ptep = __get_locked_pte(mm, addr, ptl));
+	return ptep;
+}
 
 #ifdef __PAGETABLE_PUD_FOLDED
 static inline int __pud_alloc(struct mm_struct *mm, pgd_t *pgd,
diff -puN mm/memory.c~mm-wrap-get_locked_pte-using-__cond_lock mm/memory.c
--- a/mm/memory.c~mm-wrap-get_locked_pte-using-__cond_lock
+++ a/mm/memory.c
@@ -1590,7 +1590,7 @@ struct page *get_dump_page(unsigned long
 }
 #endif /* CONFIG_ELF_CORE */
 
-pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
+pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
 			spinlock_t **ptl)
 {
 	pgd_t * pgd = pgd_offset(mm, addr);
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

