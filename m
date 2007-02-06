From: akpm@linux-foundation.org
Subject: + mm-vm_insert_pfn-tidy.patch added to -mm tree
Date: Mon, 05 Feb 2007 20:05:27 -0800
Message-ID: <200702060405.l1645R7G009668@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47749 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbXBFEFr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 23:05:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, hugh@veritas.com, npiggin@suse.de


The patch titled
     mm-vm_insert_pfn-tidy
has been added to the -mm tree.  Its filename is
     mm-vm_insert_pfn-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm-vm_insert_pfn-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Nick Piggin <npiggin@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++-
 mm/memory.c        |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-vm_insert_pfn-tidy include/linux/mm.h
--- a/include/linux/mm.h~mm-vm_insert_pfn-tidy
+++ a/include/linux/mm.h
@@ -1121,7 +1121,8 @@ unsigned long vmalloc_to_pfn(void *addr)
 int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
 			unsigned long pfn, unsigned long size, pgprot_t);
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
-int vm_insert_pfn(struct vm_area_struct *, unsigned long addr, unsigned long pfn);
+int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
+			unsigned long pfn);
 
 struct page *follow_page(struct vm_area_struct *, unsigned long address,
 			unsigned int foll_flags);
diff -puN mm/memory.c~mm-vm_insert_pfn-tidy mm/memory.c
--- a/mm/memory.c~mm-vm_insert_pfn-tidy
+++ a/mm/memory.c
@@ -1289,7 +1289,8 @@ EXPORT_SYMBOL(vm_insert_page);
  * This function should only be called from a nopage handler, and
  * in that case the handler should return NOPAGE_REFAULT.
  */
-int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr, unsigned long pfn)
+int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	int retval;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

git-libata-all-forward-declare-struct-device.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
mm-vm_insert_pfn-tidy.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
