From: akpm@linux-foundation.org
Subject: [merged] frv-handle-pgtable_page_ctor-fail.patch removed from -mm tree
Date: Fri, 15 Nov 2013 12:08:08 -0800
Message-ID: <52867f28.6eaoYaui5ZgMleiv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3KOUII (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dhowells@redhat.com, kirill.shutemov@linux.intel.com

Subject: [merged] frv-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,dhowells@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:08 -0800


The patch titled
     Subject: frv: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     frv-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: frv: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mm/pgalloc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN arch/frv/mm/pgalloc.c~frv-handle-pgtable_page_ctor-fail arch/frv/mm/pgalloc.c
--- a/arch/frv/mm/pgalloc.c~frv-handle-pgtable_page_ctor-fail
+++ a/arch/frv/mm/pgalloc.c
@@ -37,11 +37,15 @@ pgtable_t pte_alloc_one(struct mm_struct
 #else
 	page = alloc_pages(GFP_KERNEL|__GFP_REPEAT, 0);
 #endif
-	if (page) {
-		clear_highpage(page);
-		pgtable_page_ctor(page);
-		flush_dcache_page(page);
+	if (!page)
+		return NULL;
+
+	clear_highpage(page);
+	if (!pgtable_page_ctor(page)) {
+		__free_page(page);
+		return NULL;
 	}
+	flush_dcache_page(page);
 	return page;
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

