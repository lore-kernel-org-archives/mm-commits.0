From: akpm@linux-foundation.org
Subject: - pa-risc-fix-bogus-warnings-from-modpost.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:17:12 -0800
Message-ID: <200702170717.l1H7HC3L021774@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51235 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946546AbXBQHRR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:17:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, kyle@mcmartin.ca, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     PA-RISC: Fix bogus warnings from modpost
has been removed from the -mm tree.  Its filename was
     pa-risc-fix-bogus-warnings-from-modpost.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/mod/modpost.c~pa-risc-fix-bogus-warnings-from-modpost scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~pa-risc-fix-bogus-warnings-from-modpost
+++ a/scripts/mod/modpost.c
@@ -941,7 +941,7 @@ static int init_section_ref_ok(const cha
 		".opd",   /* see comment [OPD] at exit_section_ref_ok() */
 		".toc1",  /* used by ppc64 */
 		".stab",
-		".rodata",
+		".data.rel.ro", /* used by parisc64 */
 		".parainstructions",
 		".text.lock",
 		"__bug_table", /* used by powerpc for BUG() */
@@ -964,6 +964,7 @@ static int init_section_ref_ok(const cha
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
