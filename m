From: akpm@linux-foundation.org
Subject: [merged] fbdev-work-around-old-compiler-bug.patch removed from -mm tree
Date: Wed, 01 Jul 2009 10:26:40 -0700
Message-ID: <200907011726.n61HQeRr001330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754084AbZGAR1Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 13:27:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, Geert.Uytterhoeven@sonycom.com, krzysztof.h1@poczta.fm, kyle@mcmartin.ca, sam@ravnborg.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fbdev: work around old compiler bug
has been removed from the -mm tree.  Its filename was
     fbdev-work-around-old-compiler-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: work around old compiler bug
From: Stephen Rothwell <sfr@canb.auug.org.au>

When building with a 4.1.x compiler on powerpc64 (at least) we get this
error:

drivers/video/logo/logo_linux_mono.c:81: error: logo_linux_mono causes a section type conflict

This was introduced by commit ae52bb2384f721562f15f719de1acb8e934733cb
("fbdev: move logo externs to header file").  This is a partial revert of
that commit sufficient to not hit the compiler bug.

Also convert _clut arrays from __initconst to __initdata.

Sam said:

  Al analysed this some time ago.  When we say something is const then
  _sometimes_ gcc annotate the section as const(?) - sometimes not.  So if
  we have two variables/functions annotated __*const and gcc decides to
  annotate the section const only in one case we get a section type
  conflict.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/pnmtologo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/pnmtologo.c~fbdev-work-around-old-compiler-bug scripts/pnmtologo.c
--- a/scripts/pnmtologo.c~fbdev-work-around-old-compiler-bug
+++ a/scripts/pnmtologo.c
@@ -237,7 +237,7 @@ static void write_header(void)
     fprintf(out, " *  Linux logo %s\n", logoname);
     fputs(" */\n\n", out);
     fputs("#include <linux/linux_logo.h>\n\n", out);
-    fprintf(out, "static const unsigned char %s_data[] __initconst = {\n",
+    fprintf(out, "static unsigned char %s_data[] __initdata = {\n",
 	    logoname);
 }
 
@@ -374,7 +374,7 @@ static void write_logo_clut224(void)
     fputs("\n};\n\n", out);
 
     /* write logo clut */
-    fprintf(out, "static const unsigned char %s_clut[] __initconst = {\n",
+    fprintf(out, "static unsigned char %s_clut[] __initdata = {\n",
 	    logoname);
     write_hex_cnt = 0;
     for (i = 0; i < logo_clutsize; i++) {
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch

