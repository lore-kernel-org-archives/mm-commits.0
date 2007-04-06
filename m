From: akpm@linux-foundation.org
Subject: - ia64-desc_empty-thinko-typo-fix.patch removed from -mm tree
Date: Fri, 06 Apr 2007 13:08:51 -0700
Message-ID: <200704062008.l36K8pFw017876@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32801 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932794AbXDFUI7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 16:08:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maze@google.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: desc_empty thinko/typo fix
has been removed from the -mm tree.  Its filename was
     ia64-desc_empty-thinko-typo-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: desc_empty thinko/typo fix
From: Maciej Zenczykowski <maze@google.com>

Just a one-byter for an ia64 thinko/typo - already fixed for i386 and x86_64.

Acked-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/processor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-ia64/processor.h~ia64-desc_empty-thinko-typo-fix include/asm-ia64/processor.h
--- a/include/asm-ia64/processor.h~ia64-desc_empty-thinko-typo-fix
+++ a/include/asm-ia64/processor.h
@@ -210,7 +210,7 @@ struct desc_struct {
 	unsigned int a, b;
 };
 
-#define desc_empty(desc)		(!((desc)->a + (desc)->b))
+#define desc_empty(desc)		(!((desc)->a | (desc)->b))
 #define desc_equal(desc1, desc2)	(((desc1)->a == (desc2)->a) && ((desc1)->b == (desc2)->b))
 
 #define GDT_ENTRY_TLS_ENTRIES	3
_

Patches currently in -mm which might be from maze@google.com are
