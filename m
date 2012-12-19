From: akpm@linux-foundation.org
Subject: [merged] mm-mprotectc-coding-style-cleanups.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:42:37 -0800
Message-ID: <20121219204238.0E6E8200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:58173 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab2LSUmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:42:40 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so133961wib.5
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:42:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect.c: coding-style cleanups
has been removed from the -mm tree.  Its filename was
     mm-mprotectc-coding-style-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/mprotect.c: coding-style cleanups

A few gremlins have recently crept in.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff -puN mm/mprotect.c~mm-mprotectc-coding-style-cleanups mm/mprotect.c
--- a/mm/mprotect.c~mm-mprotectc-coding-style-cleanups
+++ a/mm/mprotect.c
@@ -114,7 +114,7 @@ static unsigned long change_pte_range(st
 
 #ifdef CONFIG_NUMA_BALANCING
 static inline void change_pmd_protnuma(struct mm_struct *mm, unsigned long addr,
-		pmd_t *pmd)
+				       pmd_t *pmd)
 {
 	spin_lock(&mm->page_table_lock);
 	set_pmd_at(mm, addr & PMD_MASK, pmd, pmd_mknuma(*pmd));
@@ -122,15 +122,15 @@ static inline void change_pmd_protnuma(s
 }
 #else
 static inline void change_pmd_protnuma(struct mm_struct *mm, unsigned long addr,
-		pmd_t *pmd)
+				       pmd_t *pmd)
 {
 	BUG();
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
-static inline unsigned long change_pmd_range(struct vm_area_struct *vma, pud_t *pud,
-		unsigned long addr, unsigned long end, pgprot_t newprot,
-		int dirty_accountable, int prot_numa)
+static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
+		pud_t *pud, unsigned long addr, unsigned long end,
+		pgprot_t newprot, int dirty_accountable, int prot_numa)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -143,7 +143,8 @@ static inline unsigned long change_pmd_r
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				split_huge_page_pmd(vma, addr, pmd);
-			else if (change_huge_pmd(vma, pmd, addr, newprot, prot_numa)) {
+			else if (change_huge_pmd(vma, pmd, addr, newprot,
+						 prot_numa)) {
 				pages += HPAGE_PMD_NR;
 				continue;
 			}
@@ -167,9 +168,9 @@ static inline unsigned long change_pmd_r
 	return pages;
 }
 
-static inline unsigned long change_pud_range(struct vm_area_struct *vma, pgd_t *pgd,
-		unsigned long addr, unsigned long end, pgprot_t newprot,
-		int dirty_accountable, int prot_numa)
+static inline unsigned long change_pud_range(struct vm_area_struct *vma,
+		pgd_t *pgd, unsigned long addr, unsigned long end,
+		pgprot_t newprot, int dirty_accountable, int prot_numa)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -304,7 +305,8 @@ success:
 		dirty_accountable = 1;
 	}
 
-	change_protection(vma, start, end, vma->vm_page_prot, dirty_accountable, 0);
+	change_protection(vma, start, end, vma->vm_page_prot,
+			  dirty_accountable, 0);
 
 	vm_stat_account(mm, oldflags, vma->vm_file, -nrpages);
 	vm_stat_account(mm, newflags, vma->vm_file, nrpages);
@@ -361,8 +363,7 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 		error = -EINVAL;
 		if (!(vma->vm_flags & VM_GROWSDOWN))
 			goto out;
-	}
-	else {
+	} else {
 		if (vma->vm_start > start)
 			goto out;
 		if (unlikely(grows & PROT_GROWSUP)) {
@@ -378,9 +379,10 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 	for (nstart = start ; ; ) {
 		unsigned long newflags;
 
-		/* Here we know that  vma->vm_start <= nstart < vma->vm_end. */
+		/* Here we know that vma->vm_start <= nstart < vma->vm_end. */
 
-		newflags = vm_flags | (vma->vm_flags & ~(VM_READ | VM_WRITE | VM_EXEC));
+		newflags = vm_flags;
+		newflags |= (vma->vm_flags & ~(VM_READ | VM_WRITE | VM_EXEC));
 
 		/* newflags >> 4 shift VM_MAY% in place of VM_% */
 		if ((newflags & ~(newflags >> 4)) & (VM_READ | VM_WRITE | VM_EXEC)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch
sgi-xp-handle-non-fatal-traps-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
block-remove-deadlock-in-disk_clear_events.patch
block-prevent-race-cleanup.patch
mm.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sendfile-allows-bypassing-of-notifier-events.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

