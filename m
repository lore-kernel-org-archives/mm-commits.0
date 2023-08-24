Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19FEEE49B5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237998AbjHXXVv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240370AbjHXXVS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5675810D
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E138F64B19
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE6FC433C7;
        Thu, 24 Aug 2023 23:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919275;
        bh=5tk0Q0NQtSym7Sa0hei7iYxGLgRC0b8Zk7IJQdU1kxs=;
        h=Date:To:From:Subject:From;
        b=fai0clfrow97D/oKc6WZOfUUNEwPP98ZRZPssth2Jdue4X8v2Ke0tcu4OwuhHKzAL
         yuF16/R2QZHlffJ4vJnC5e0W6ymktRamsok7COR0ZHRc6Ti7RDI11JZOQ+AUQ3Wuaz
         dc8BJuQVvuDoWB7S+IsS9GY0EXwfgV3TXA59xlZ0=
Date:   Thu, 24 Aug 2023 16:21:14 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        anshuman.khandual@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-generic-flush_icache_pages-and-documentation.patch removed from -mm tree
Message-Id: <20230824232115.3AE6FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add generic flush_icache_pages() and documentation
has been removed from the -mm tree.  Its filename was
     mm-add-generic-flush_icache_pages-and-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add generic flush_icache_pages() and documentation
Date: Wed, 2 Aug 2023 16:13:31 +0100

flush_icache_page() is deprecated but not yet removed, so add a range
version of it.  Change the documentation to refer to
update_mmu_cache_range() instead of update_mmu_cache().

Link: https://lkml.kernel.org/r/20230802151406.3735276-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/cachetlb.rst |   41 ++++++++++++++------------
 include/asm-generic/cacheflush.h    |    5 +++
 2 files changed, 28 insertions(+), 18 deletions(-)

--- a/Documentation/core-api/cachetlb.rst~mm-add-generic-flush_icache_pages-and-documentation
+++ a/Documentation/core-api/cachetlb.rst
@@ -88,13 +88,17 @@ changes occur:
 
 	This is used primarily during fault processing.
 
-5) ``void update_mmu_cache(struct vm_area_struct *vma,
-   unsigned long address, pte_t *ptep)``
+5) ``void update_mmu_cache_range(struct vm_fault *vmf,
+   struct vm_area_struct *vma, unsigned long address, pte_t *ptep,
+   unsigned int nr)``
+
+	At the end of every page fault, this routine is invoked to tell
+	the architecture specific code that translations now exists
+	in the software page tables for address space "vma->vm_mm"
+	at virtual address "address" for "nr" consecutive pages.
 
-	At the end of every page fault, this routine is invoked to
-	tell the architecture specific code that a translation
-	now exists at virtual address "address" for address space
-	"vma->vm_mm", in the software page tables.
+	This routine is also invoked in various other places which pass
+	a NULL "vmf".
 
 	A port may use this information in any way it so chooses.
 	For example, it could use this event to pre-load TLB
@@ -306,17 +310,18 @@ maps this page at its virtual address.
 	private".  The kernel guarantees that, for pagecache pages, it will
 	clear this bit when such a page first enters the pagecache.
 
-	This allows these interfaces to be implemented much more efficiently.
-	It allows one to "defer" (perhaps indefinitely) the actual flush if
-	there are currently no user processes mapping this page.  See sparc64's
-	flush_dcache_page and update_mmu_cache implementations for an example
-	of how to go about doing this.
-
-	The idea is, first at flush_dcache_page() time, if page_file_mapping()
-	returns a mapping, and mapping_mapped on that mapping returns %false,
-	just mark the architecture private page flag bit.  Later, in
-	update_mmu_cache(), a check is made of this flag bit, and if set the
-	flush is done and the flag bit is cleared.
+	This allows these interfaces to be implemented much more
+	efficiently.  It allows one to "defer" (perhaps indefinitely) the
+	actual flush if there are currently no user processes mapping this
+	page.  See sparc64's flush_dcache_page and update_mmu_cache_range
+	implementations for an example of how to go about doing this.
+
+	The idea is, first at flush_dcache_page() time, if
+	page_file_mapping() returns a mapping, and mapping_mapped on that
+	mapping returns %false, just mark the architecture private page
+	flag bit.  Later, in update_mmu_cache_range(), a check is made
+	of this flag bit, and if set the flush is done and the flag bit
+	is cleared.
 
 	.. important::
 
@@ -369,7 +374,7 @@ maps this page at its virtual address.
   ``void flush_icache_page(struct vm_area_struct *vma, struct page *page)``
 
 	All the functionality of flush_icache_page can be implemented in
-	flush_dcache_page and update_mmu_cache. In the future, the hope
+	flush_dcache_page and update_mmu_cache_range. In the future, the hope
 	is to remove this interface completely.
 
 The final category of APIs is for I/O to deliberately aliased address
--- a/include/asm-generic/cacheflush.h~mm-add-generic-flush_icache_pages-and-documentation
+++ a/include/asm-generic/cacheflush.h
@@ -78,6 +78,11 @@ static inline void flush_icache_range(un
 #endif
 
 #ifndef flush_icache_page
+static inline void flush_icache_pages(struct vm_area_struct *vma,
+				     struct page *page, unsigned int nr)
+{
+}
+
 static inline void flush_icache_page(struct vm_area_struct *vma,
 				     struct page *page)
 {
_

Patches currently in -mm which might be from willy@infradead.org are


