From: akpm@linux-foundation.org
Subject: - ia64-virt_to_page-can-be-called-with-null-arg.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:51:46 -0800
Message-ID: <200702071951.l17Jpk5P025187@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33605 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422743AbXBGTw2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:52:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dev@openvz.org, kuznet@ms2.inr.ac.ru, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     IA64: virt_to_page() can be called with NULL arg
has been removed from the -mm tree.  Its filename was
     ia64-virt_to_page-can-be-called-with-null-arg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IA64: virt_to_page() can be called with NULL arg
From: Kirill Korotaev <dev@openvz.org>

It does not return NULL when arg is NULL.

Signed-off-by: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Signed-off-by: Kirill Korotaev <dev@openvz.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/pgalloc.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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

origin.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
