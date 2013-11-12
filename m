From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-numa-return-the-number-of-base-pages-altered-by-protection-changes-vs-linux-next.patch removed from -mm tree
Date: Tue, 12 Nov 2013 11:22:24 -0800
Message-ID: <52827ff0.q9j0JzLNKKAGQRCM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3KLTWZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 14:22:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] mm-numa-return-the-number-of-base-pages-altered-by-protection-changes-vs-linux-next.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 11:22:24 -0800


The patch titled
     Subject: mm-numa-return-the-number-of-base-pages-altered-by-protection-changes-vs-linux-next
has been removed from the -mm tree.  Its filename was
     mm-numa-return-the-number-of-base-pages-altered-by-protection-changes-vs-linux-next.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-numa-return-the-number-of-base-pages-altered-by-protection-changes-vs-linux-next

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff -puN mm/mprotect.c~mm-numa-return-the-number-of-base-pages-altered-by-protection-changes-vs-linux-next mm/mprotect.c
--- a/mm/mprotect.c~mm-numa-return-the-number-of-base-pages-altered-by-protection-changes-vs-linux-next
+++ a/mm/mprotect.c
@@ -113,35 +113,34 @@ static inline unsigned long change_pmd_r
 	unsigned long next;
 	unsigned long pages = 0;
 	unsigned long nr_huge_updates = 0;
-	bool all_same_node;
 
 	pmd = pmd_offset(pud, addr);
 	do {
+		unsigned long this_pages;
+
 		next = pmd_addr_end(addr, end);
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				split_huge_page_pmd(vma, addr, pmd);
-			else if (change_huge_pmd(vma, pmd, addr, newprot,
-						 prot_numa)) {
-				pages += HPAGE_PMD_NR;
-				nr_huge_updates++;
 				continue;
+			else {
+				int nr_ptes = change_huge_pmd(vma, pmd, addr,
+						newprot, prot_numa);
+
+				if (nr_ptes) {
+					if (nr_ptes == HPAGE_PMD_NR)
+						pages += HPAGE_PMD_NR;
+
+					continue;
+				}
 			}
 			/* fall through */
 		}
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
-		pages += change_pte_range(vma, pmd, addr, next, newprot,
-				 dirty_accountable, prot_numa, &all_same_node);
-
-		/*
-		 * If we are changing protections for NUMA hinting faults then
-		 * set pmd_numa if the examined pages were all on the same
-		 * node. This allows a regular PMD to be handled as one fault
-		 * and effectively batches the taking of the PTL
-		 */
-		if (prot_numa && all_same_node)
-			change_pmd_protnuma(vma->vm_mm, addr, pmd);
+		this_pages = change_pte_range(vma, pmd, addr, next, newprot,
+				 dirty_accountable, prot_numa);
+		pages += this_pages;
 	} while (pmd++, addr = next, addr != end);
 
 	if (nr_huge_updates)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-remove-unrelated-header-files-and-export-symbol-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-factor-commit-limit-calculation-fix.patch
mm-factor-commit-limit-calculation-fix-fix.patch
mm-factor-commit-limit-calculation-fix-fix-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch
fs-hfs-btreeh-remove-duplicate-defines-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch
linux-next.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
kfifo-api-type-safety-checkpatch-fixes.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

