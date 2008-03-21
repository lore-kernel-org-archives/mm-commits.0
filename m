From: akpm@linux-foundation.org
Subject: - mm-highmem-kernel-doc-additions.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:29:03 -0700
Message-ID: <200803212029.m2LKT3Qr008835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756356AbYCUU3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:29:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mm: highmem kernel-doc additions
has been removed from the -mm tree.  Its filename was
     mm-highmem-kernel-doc-additions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: highmem kernel-doc additions
From: Randy Dunlap <randy.dunlap@oracle.com>

Add kernel-doc comments to highmem.c.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff -puN mm/highmem.c~mm-highmem-kernel-doc-additions mm/highmem.c
--- a/mm/highmem.c~mm-highmem-kernel-doc-additions
+++ a/mm/highmem.c
@@ -104,8 +104,9 @@ static void flush_all_zero_pkmaps(void)
 	flush_tlb_kernel_range(PKMAP_ADDR(0), PKMAP_ADDR(LAST_PKMAP));
 }
 
-/* Flush all unused kmap mappings in order to remove stray
-   mappings. */
+/**
+ * kmap_flush_unused - flush all unused kmap mappings in order to remove stray mappings
+ */
 void kmap_flush_unused(void)
 {
 	spin_lock(&kmap_lock);
@@ -163,6 +164,14 @@ start:
 	return vaddr;
 }
 
+/**
+ * kmap_high - map a highmem page into memory
+ * @page: &struct page to map
+ *
+ * Returns the page's virtual memory address.
+ *
+ * We cannot call this from interrupts, as it may block.
+ */
 void *kmap_high(struct page *page)
 {
 	unsigned long vaddr;
@@ -170,8 +179,6 @@ void *kmap_high(struct page *page)
 	/*
 	 * For highmem pages, we can't trust "virtual" until
 	 * after we have the lock.
-	 *
-	 * We cannot call this from interrupts, as it may block
 	 */
 	spin_lock(&kmap_lock);
 	vaddr = (unsigned long)page_address(page);
@@ -185,6 +192,10 @@ void *kmap_high(struct page *page)
 
 EXPORT_SYMBOL(kmap_high);
 
+/**
+ * kunmap_high - map a highmem page into memory
+ * @page: &struct page to unmap
+ */
 void kunmap_high(struct page *page)
 {
 	unsigned long vaddr;
@@ -259,6 +270,12 @@ static struct page_address_slot *page_sl
 	return &page_address_htable[hash_ptr(page, PA_HASH_ORDER)];
 }
 
+/**
+ * page_address - get the mapped virtual address of a page
+ * @page: &struct page to get the virtual address of
+ *
+ * Returns the page's virtual address.
+ */
 void *page_address(struct page *page)
 {
 	unsigned long flags;
@@ -288,6 +305,11 @@ done:
 
 EXPORT_SYMBOL(page_address);
 
+/**
+ * set_page_address - set a page's virtual address
+ * @page: &struct page to set
+ * @virtual: virtual address to use
+ */
 void set_page_address(struct page *page, void *virtual)
 {
 	unsigned long flags;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-x86.patch
rapidio-fix-docbook-references.patch
pm-remove-legacy-pm-fix.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
scsi-add-iscsi-ibft-support-fix.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-dont-allow-kvm_clock-without-have_kvm.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
kernel-add-bit-rotation-helpers-for-16-and-8-bit.patch
profile-likely-unlikely-macros.patch

