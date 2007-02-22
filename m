From: akpm@linux-foundation.org
Subject: + uml-pte_mkread-fix.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:21:41 -0800
Message-ID: <200702220021.l1M0LfgE031092@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59234 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965029AbXBVAVn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:21:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: pte_mkread fix
has been added to the -mm tree.  Its filename is
     uml-pte_mkread-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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

uml-enable-raw.patch
uml-host-vdso-fix.patch
uml-pte_mkread-fix.patch
uml-fix-prototypes.patch
