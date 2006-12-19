From: akpm@osdl.org
Subject: + ia64-virt_to_page-can-be-called-with-null-arg.patch added to -mm tree
Date: Mon, 18 Dec 2006 16:32:20 -0800
Message-ID: <200612190032.kBJ0WKbX017901@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35550 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493AbWLSAcw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 19:32:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dev@openvz.org, kuznet@ms2.inr.ac.ru, tony.luck@intel.com


The patch titled
     IA64: virt_to_page() can be called with NULL arg
has been added to the -mm tree.  Its filename is
     ia64-virt_to_page-can-be-called-with-null-arg.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IA64: virt_to_page() can be called with NULL arg
From: Kirill Korotaev <dev@openvz.org>

It does not return NULL when arg is NULL.

Signed-off-by: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Signed-off-by: Kirill Korotaev <dev@openvz.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-ia64/pgalloc.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/asm-ia64/pgalloc.h~ia64-virt_to_page-can-be-called-with-null-arg include/asm-ia64/pgalloc.h
--- a/include/asm-ia64/pgalloc.h~ia64-virt_to_page-can-be-called-with-null-arg
+++ a/include/asm-ia64/pgalloc.h
@@ -137,7 +137,8 @@ pmd_populate_kernel(struct mm_struct *mm
 static inline struct page *pte_alloc_one(struct mm_struct *mm,
 					 unsigned long addr)
 {
-	return virt_to_page(pgtable_quicklist_alloc());
+	void *pg = pgtable_quicklist_alloc();
+	return pg ? virt_to_page(pg) : NULL;
 }
 
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
_

Patches currently in -mm which might be from dev@openvz.org are

ia64-alignment-bug-in-ldscript.patch
ia64-virt_to_page-can-be-called-with-null-arg.patch

