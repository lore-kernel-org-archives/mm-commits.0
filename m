From: akpm@linux-foundation.org
Subject: - uml-pte_mkread-fix.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:07:06 -0800
Message-ID: <200703020507.l22576ck000853@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42363 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422756AbXCBFHI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:07:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: pte_mkread fix
has been removed from the -mm tree.  Its filename was
     uml-pte_mkread-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: pte_mkread fix
From: Jeff Dike <jdike@addtoit.com>

Fix the fact that pte_mkread set _PAGE_RW instead of _PAGE_USER (the logic is
copied from i386 in most place, so it is really as bad as you're thinking).

Thus currently page tables are more permissive than they should.

Such a change may trigger other latent bugs, so be careful with this.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-um/pgtable.h~uml-pte_mkread-fix include/asm-um/pgtable.h
--- a/include/asm-um/pgtable.h~uml-pte_mkread-fix
+++ a/include/asm-um/pgtable.h
@@ -270,7 +270,7 @@ static inline pte_t pte_wrprotect(pte_t 
 
 static inline pte_t pte_mkread(pte_t pte)
 { 
-	pte_set_bits(pte, _PAGE_RW);
+	pte_set_bits(pte, _PAGE_USER);
 	return(pte_mknewprot(pte)); 
 }
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-fix-prototypes.patch
