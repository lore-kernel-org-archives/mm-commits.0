From: akpm@linux-foundation.org
Subject: + mm-mprotectc-coding-style-cleanups.patch added to -mm tree
Date: Wed, 12 Dec 2012 14:33:25 -0800
Message-ID: <20121212223326.14DD720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f201.google.com ([209.85.217.201]:45076 "EHLO
	mail-lb0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab2LLWd2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 17:33:28 -0500
Received: by mail-lb0-f201.google.com with SMTP id m4so69336lbo.2
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 14:33:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: mm/mprotect.c: coding-style cleanups
has been added to the -mm tree.  Its filename is
     mm-mprotectc-coding-style-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/mprotect.c: coding-style cleanups

A fwe gremlins have recently crept in.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff -puN mm/mprotect.c~mm-mprotectc-coding-style-cleanups mm/mprotect.c
--- a/mm/mprotect.c~mm-mprotectc-coding-style-cleanups
+++ a/mm/mprotect.c
@@ -112,9 +112,9 @@ static unsigned long change_pte_range(st
 	return pages;
 }
 
-static inline unsigned long change_pmd_range(struct vm_area_struct *vma, pud_t *pud,
-		unsigned long addr, unsigned long end, pgprot_t newprot,
-		int dirty_accountable, int prot_numa)
+static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
+		pud_t *pud, unsigned long addr, unsigned long end,
+		pgprot_t newprot, int dirty_accountable, int prot_numa)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -127,7 +127,8 @@ static inline unsigned long change_pmd_r
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				split_huge_page_pmd(vma, addr, pmd);
-			else if (change_huge_pmd(vma, pmd, addr, newprot, prot_numa)) {
+			else if (change_huge_pmd(vma, pmd, addr, newprot,
+						 prot_numa)) {
 				pages += HPAGE_PMD_NR;
 				continue;
 			}
@@ -157,9 +158,9 @@ static inline unsigned long change_pmd_r
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
@@ -291,7 +292,8 @@ success:
 		dirty_accountable = 1;
 	}
 
-	change_protection(vma, start, end, vma->vm_page_prot, dirty_accountable, 0);
+	change_protection(vma, start, end, vma->vm_page_prot,
+			  dirty_accountable, 0);
 
 	vm_stat_account(mm, oldflags, vma->vm_file, -nrpages);
 	vm_stat_account(mm, newflags, vma->vm_file, nrpages);
@@ -348,8 +350,7 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 		error = -EINVAL;
 		if (!(vma->vm_flags & VM_GROWSDOWN))
 			goto out;
-	}
-	else {
+	} else {
 		if (vma->vm_start > start)
 			goto out;
 		if (unlikely(grows & PROT_GROWSUP)) {
@@ -367,10 +368,12 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 
 		/* Here we know that  vma->vm_start <= nstart < vma->vm_end. */
 
-		newflags = vm_flags | (vma->vm_flags & ~(VM_READ | VM_WRITE | VM_EXEC));
+		newflags = vm_flags;
+		newflags |= (vma->vm_flags & ~(VM_READ | VM_WRITE | VM_EXEC));
 
 		/* newflags >> 4 shift VM_MAY% in place of VM_% */
-		if ((newflags & ~(newflags >> 4)) & (VM_READ | VM_WRITE | VM_EXEC)) {
+		if ((newflags & ~(newflags >> 4)) &
+		    (VM_READ | VM_WRITE | VM_EXEC)) {
 			error = -EACCES;
 			goto out;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
tmpfs-support-seek_data-and-seek_hole-reprise.patch
hwpoison-hugetlbfs-fix-rss-counter-warning.patch
mm-memoryc-remove-unused-code-from-do_wp_page.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
irq-tsk-comm-is-an-array.patch
block-remove-deadlock-in-disk_clear_events-fix.patch
block-prevent-race-cleanup-fix.patch
mm.patch
slub-slub-specific-propagation-changes-fix.patch
mm-mprotectc-coding-style-cleanups.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

