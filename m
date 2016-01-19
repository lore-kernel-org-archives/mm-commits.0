From: akpm@linux-foundation.org
Subject: [merged] frv-fix-compiler-warning-from-definition-of-__pmd.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:13:36 -0800
Message-ID: <569e98f0.1TZMnuYbmlBSqHmG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbcASUNh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: fix compiler warning from definition of __pmd()
has been removed from the -mm tree.  Its filename was
     frv-fix-compiler-warning-from-definition-of-__pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: frv: fix compiler warning from definition of __pmd()

Take into account that the pmd_t type is a array inside a struct, so it
needs two levels of brackets to initialize.  Otherwise, a usage of __pmd
generates a warning:

include/linux/mm.h:986:2: warning: missing braces around initializer [-Wmissing-braces]

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/page.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/frv/include/asm/page.h~frv-fix-compiler-warning-from-definition-of-__pmd arch/frv/include/asm/page.h
--- a/arch/frv/include/asm/page.h~frv-fix-compiler-warning-from-definition-of-__pmd
+++ a/arch/frv/include/asm/page.h
@@ -34,7 +34,7 @@ typedef struct page *pgtable_t;
 #define pgprot_val(x)	((x).pgprot)
 
 #define __pte(x)	((pte_t) { (x) } )
-#define __pmd(x)	((pmd_t) { (x) } )
+#define __pmd(x)	((pmd_t) { { (x) } } )
 #define __pud(x)	((pud_t) { (x) } )
 #define __pgd(x)	((pgd_t) { (x) } )
 #define __pgprot(x)	((pgprot_t) { (x) } )
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dax-add-support-for-fsync-sync-v6-fix.patch

