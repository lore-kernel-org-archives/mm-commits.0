From: akpm@osdl.org
Subject: + pa-risc-fix-bogus-warnings-from-modpost.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:13:17 -0800
Message-ID: <200612090013.kB90DHfS010535@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55910 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947519AbWLIANZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:13:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthew@wil.cx, kyle@mcmartin.ca, sam@ravnborg.org


The patch titled
     PA-RISC: Fix bogus warnings from modpost
has been added to the -mm tree.  Its filename is
     pa-risc-fix-bogus-warnings-from-modpost.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PA-RISC: Fix bogus warnings from modpost
From: Matthew Wilcox <matthew@wil.cx>

parisc and parisc64 seem to name sections a little differently from other
targets.  parisc64 gives spurious warnings like:

WARNING: drivers/net/dummy.o - Section mismatch: reference to .init.text:dummy_setup from .data.rel.ro between '.LC1' (at offset 0x0) and '.LC6'

and parisc gives spurious warnings like:

WARNING: drivers/net/dummy.o - Section mismatch: reference to .init.text:dummy_setup from .rodata.cst4 between '.LC1' (at offset 0x0) and '.LC6'

Given the other comments in modpost.c, it seems that the best solution is
to move rodata down to the 'match at start of name' section and add
.data.rel.ro to the 'match entire name' section.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/mod/modpost.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/mod/modpost.c~pa-risc-fix-bogus-warnings-from-modpost scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~pa-risc-fix-bogus-warnings-from-modpost
+++ a/scripts/mod/modpost.c
@@ -910,7 +910,7 @@ static int init_section_ref_ok(const cha
 		".opd",   /* see comment [OPD] at exit_section_ref_ok() */
 		".toc1",  /* used by ppc64 */
 		".stab",
-		".rodata",
+		".data.rel.ro", /* used by parisc64 */
 		".parainstructions",
 		".text.lock",
 		"__bug_table", /* used by powerpc for BUG() */
@@ -933,6 +933,7 @@ static int init_section_ref_ok(const cha
 		".eh_frame",
 		".debug",
 		".parainstructions",
+		".rodata",
 		NULL
 	};
 	/* part of section name */
_

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
make-sure-nobodys-leaking-resources.patch
pa-risc-fix-bogus-warnings-from-modpost.patch

