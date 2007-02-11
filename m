From: akpm@linux-foundation.org
Subject: - typeof-__page_to_pfn-with-sparsemem=y.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:10 -0800
Message-ID: <200702112246.l1BMkAIk015470@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59497 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619AbXBKWq0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     typeof __page_to_pfn with SPARSEMEM=y
has been removed from the -mm tree.  Its filename was
     typeof-__page_to_pfn-with-sparsemem=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: typeof __page_to_pfn with SPARSEMEM=y
From: Randy Dunlap <randy.dunlap@oracle.com>

With CONFIG_SPARSEMEM=y:

mm/rmap.c:579: warning: format '%lx' expects type 'long unsigned int', but argument 2 has type 'int'

Make __page_to_pfn() return unsigned long.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/memory_model.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/memory_model.h~typeof-__page_to_pfn-with-sparsemem=y include/asm-generic/memory_model.h
--- a/include/asm-generic/memory_model.h~typeof-__page_to_pfn-with-sparsemem=y
+++ a/include/asm-generic/memory_model.h
@@ -54,7 +54,7 @@
 #define __page_to_pfn(pg)					\
 ({	struct page *__pg = (pg);				\
 	int __sec = page_to_section(__pg);			\
-	__pg - __section_mem_map_addr(__nr_to_section(__sec));	\
+	(unsigned long)(__pg - __section_mem_map_addr(__nr_to_section(__sec)));	\
 })
 
 #define __pfn_to_page(pfn)				\
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-drm.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
git-mtd.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
parisc-fix-module_param-iommu-permission.patch
ueagle-atmc-needs-schedh.patch
com20020-build-fix.patch
drivers-telephony-ixj-convert-to-generic-boolean.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
