From: akpm@linux-foundation.org
Subject: - kbuild-fix-and-improve-mips-rel-handling.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:43:08 -0700
Message-ID: <200708250343.l7P3h8gG028709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54738 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197AbXHYDnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, ralf@linux-mips.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: fix and improve MIPS REL handling
has been removed from the -mm tree.  Its filename was
     kbuild-fix-and-improve-mips-rel-handling.patch

This patch was dropped because it isn't in the present -mm lineup

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
spi-driver-hotplug-coldplug-fixes-fix.patch
serial_txx9-cleanup-includes.patch
