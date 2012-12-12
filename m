From: akpm@linux-foundation.org
Subject: + linux-next-rejects.patch added to -mm tree
Date: Wed, 12 Dec 2012 14:20:59 -0800
Message-ID: <20121212222100.7E084200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:37252 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab2LLWVC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 17:21:02 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so69099wgb.5
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 14:21:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

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
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   13 ++++++++++++-
 mm/mprotect.c    |   32 ++++++++++++++++++++++++++------
 2 files changed, 38 insertions(+), 7 deletions(-)

diff -puN mm/huge_memory.c~linux-next-rejects mm/huge_memory.c
--- a/mm/huge_memory.c~linux-next-rejects
+++ a/mm/huge_memory.c
@@ -16,6 +16,7 @@
 #include <linux/mm_inline.h>
 #include <linux/kthread.h>
 #include <linux/khugepaged.h>
+#include <linux/migrate.h>
 #include <linux/freezer.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
@@ -1462,7 +1463,17 @@ int change_huge_pmd(struct vm_area_struc
 	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
 		pmd_t entry;
 		entry = pmdp_get_and_clear(mm, addr, pmd);
-		entry = pmd_modify(entry, newprot);
+		if (!prot_numa)
+			entry = pmd_modify(entry, newprot);
+		else {
+			struct page *page = pmd_page(*pmd);
+
+			/* only check non-shared pages */
+			if (page_mapcount(page) == 1 &&
+			    !pmd_numa(*pmd)) {
+				entry = pmd_mknuma(entry);
+			}
+		}
 		BUG_ON(pmd_write(entry));
 		set_pmd_at(mm, addr, pmd, entry);
 		spin_unlock(&vma->vm_mm->page_table_lock);
diff -puN mm/mprotect.c~linux-next-rejects mm/mprotect.c
--- a/mm/mprotect.c~linux-next-rejects
+++ a/mm/mprotect.c
@@ -127,20 +127,39 @@ static inline unsigned long change_pmd_r
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				split_huge_page_pmd(vma, addr, pmd);
-			else if (change_huge_pmd(vma, pmd, addr, newprot))
+			else if (change_huge_pmd(vma, pmd, addr, newprot, prot_numa)) {
+				pages += HPAGE_PMD_NR;
 				continue;
+			}
 			/* fall through */
 		}
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
-		change_pte_range(vma->vm_mm, pmd, addr, next, newprot,
-				 dirty_accountable);
+		pages += change_pte_range(vma, pmd, addr, next, newprot,
+				 dirty_accountable, prot_numa, &all_same_node);
+
+#ifdef CONFIG_NUMA_BALANCING
+		/*
+		 * If we are changing protections for NUMA hinting faults then
+		 * set pmd_numa if the examined pages were all on the same
+		 * node. This allows a regular PMD to be handled as one fault
+		 * and effectively batches the taking of the PTL
+		 */
+		if (prot_numa && all_same_node && 0) {
+			struct mm_struct *mm = vma->vm_mm;
+
+			spin_lock(&mm->page_table_lock);
+			set_pmd_at(mm, addr & PMD_MASK, pmd, pmd_mknuma(*pmd));
+			spin_unlock(&mm->page_table_lock);
+		}
+#endif
 	} while (pmd++, addr = next, addr != end);
+	return pages;
 }
 
-static inline void change_pud_range(struct vm_area_struct *vma, pgd_t *pgd,
+static inline unsigned long change_pud_range(struct vm_area_struct *vma, pgd_t *pgd,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
-		int dirty_accountable)
+		int dirty_accountable, int prot_numa)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -163,6 +182,7 @@ static void change_protection(struct vm_
 	pgd_t *pgd;
 	unsigned long next;
 	unsigned long start = addr;
+	unsigned long pages = 0;
 
 	BUG_ON(addr >= end);
 	pgd = pgd_offset(mm, addr);
@@ -182,7 +202,7 @@ static void change_protection(struct vm_
 	return pages;
 }
 
-unsigned long change_protection(struct vm_area_struct *vma, unsigned long start,
+static unsigned long change_protection_range(struct vm_area_struct *vma,
 		       unsigned long end, pgprot_t newprot,
 		       int dirty_accountable, int prot_numa)
 {
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
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
drivers-video-add-support-for-the-solomon-ssd1307-oled-controller.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
irq-tsk-comm-is-an-array.patch
block-remove-deadlock-in-disk_clear_events-fix.patch
block-prevent-race-cleanup-fix.patch
mm.patch
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

