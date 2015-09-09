From: akpm@linux-foundation.org
Subject: [merged]
 dax-ensure-that-zero-pages-are-removed-from-other-processes.patch removed
 from -mm tree
Date: Wed, 09 Sep 2015 12:43:33 -0700
Message-ID: <55f08be5.b7TIVFOn6EUMghWm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbbIITne (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: ensure that zero pages are removed from other processes
has been removed from the -mm tree.  Its filename was
     dax-ensure-that-zero-pages-are-removed-from-other-processes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: dax: ensure that zero pages are removed from other processes

If the first access to a huge page was a store, there would be no existing
zero pmd in this process's page tables.  There could be a zero pmd in
another process's page tables, if it had done a load.  We can detect this
case by noticing that the buffer_head returned from the filesystem is New,
and ensure that other processes mapping this huge page have their page
tables flushed.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reported-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/dax.c~dax-ensure-that-zero-pages-are-removed-from-other-processes fs/dax.c
--- a/fs/dax.c~dax-ensure-that-zero-pages-are-removed-from-other-processes
+++ a/fs/dax.c
@@ -568,7 +568,11 @@ int __dax_pmd_fault(struct vm_area_struc
 	if ((pgoff | PG_PMD_COLOUR) >= size)
 		goto fallback;
 
-	if (is_huge_zero_pmd(*pmd))
+	/*
+	 * If we allocated new storage, make sure no process has any
+	 * zero pages covering this hole
+	 */
+	if (buffer_new(&bh))
 		unmap_mapping_range(mapping, pgoff << PAGE_SHIFT, PMD_SIZE, 0);
 
 	if (!write && !buffer_mapped(&bh) && buffer_uptodate(&bh)) {
_

Patches currently in -mm which might be from willy@linux.intel.com are


