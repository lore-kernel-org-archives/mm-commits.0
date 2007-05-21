From: akpm@linux-foundation.org
Subject: + kbuild-fix-and-improve-mips-rel-handling.patch added to -mm tree
Date: Mon, 21 May 2007 15:32:42 -0700
Message-ID: <200705212232.l4LMWgaP021613@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39986 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754954AbXEUWfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 18:35:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, ralf@linux-mips.org, sam@ravnborg.org


The patch titled
     kbuild: fix and improve MIPS REL handling
has been added to the -mm tree.  Its filename is
     kbuild-fix-and-improve-mips-rel-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kbuild: fix and improve MIPS REL handling
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Add R_MIPS_32 relocation case.
And there is no need to do sign-extention on calculation of addend.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN scripts/mod/modpost.c~kbuild-fix-and-improve-mips-rel-handling scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~kbuild-fix-and-improve-mips-rel-handling
+++ a/scripts/mod/modpost.c
@@ -951,11 +951,14 @@ static int addend_mips_rel(struct elf_in
 	inst = TO_NATIVE(*location);
 	switch (r_typ) {
 	case R_MIPS_LO16:
-		r->r_addend = ((inst & 0xffff) ^ 0x8000) - 0x8000;
+		r->r_addend = inst & 0xffff;
 		break;
 	case R_MIPS_26:
 		r->r_addend = (inst & 0x03ffffff) << 2;
 		break;
+	case R_MIPS_32:
+		r->r_addend = inst;
+		break;
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
git-kbuild.patch
kbuild-fix-and-improve-mips-rel-handling.patch
git-mips.patch
mips-make-resources-for-ds1742-static-__initdata.patch
