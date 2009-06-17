From: akpm@linux-foundation.org
Subject: [merged] fbdev-generated-logo-sources-depend-on-scripts-pnmtologo.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:39:01 -0700
Message-ID: <200906171839.n5HId1Hl005109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759081AbZFQSqP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, Geert.Uytterhoeven@sonycom.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbdev: generated logo sources depend on scripts/pnmtologo
has been removed from the -mm tree.  Its filename was
     fbdev-generated-logo-sources-depend-on-scripts-pnmtologo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: generated logo sources depend on scripts/pnmtologo
From: Sam Ravnborg <sam@ravnborg.org>

The generated logo sources are not automatically regenerated if
scripts/pnmtologo.c has changed. Add the missing dependency to fix this.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Tested-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/logo/Makefile |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/video/logo/Makefile~fbdev-generated-logo-sources-depend-on-scripts-pnmtologo drivers/video/logo/Makefile
--- a/drivers/video/logo/Makefile~fbdev-generated-logo-sources-depend-on-scripts-pnmtologo
+++ a/drivers/video/logo/Makefile
@@ -37,22 +37,24 @@ extra-y += $(call logo-cfiles,_clut224,p
 # Gray 256
 extra-y += $(call logo-cfiles,_gray256,pgm)
 
+pnmtologo := scripts/pnmtologo
+
 # Create commands like "pnmtologo -t mono -n logo_mac_mono -o ..."
 quiet_cmd_logo = LOGO    $@
-	cmd_logo = scripts/pnmtologo \
+	cmd_logo = $(pnmtologo) \
 			-t $(patsubst $*_%,%,$(notdir $(basename $<))) \
 			-n $(notdir $(basename $<)) -o $@ $<
 
-$(obj)/%_mono.c: $(src)/%_mono.pbm FORCE
+$(obj)/%_mono.c: $(src)/%_mono.pbm $(pnmtologo) FORCE
 	$(call if_changed,logo)
 
-$(obj)/%_vga16.c: $(src)/%_vga16.ppm FORCE
+$(obj)/%_vga16.c: $(src)/%_vga16.ppm $(pnmtologo) FORCE
 	$(call if_changed,logo)
 
-$(obj)/%_clut224.c: $(src)/%_clut224.ppm FORCE
+$(obj)/%_clut224.c: $(src)/%_clut224.ppm $(pnmtologo) FORCE
 	$(call if_changed,logo)
 
-$(obj)/%_gray256.c: $(src)/%_gray256.pgm FORCE
+$(obj)/%_gray256.c: $(src)/%_gray256.pgm $(pnmtologo) FORCE
 	$(call if_changed,logo)
 
 # Files generated that shall be removed upon make clean
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
documentation-changes-perl-is-needed-to-build-the-kernel.patch
documentation-changes-perl-is-needed-to-build-the-kernel-fix.patch
kernel-constructor-support.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
gcov-enable-gcov_profile_all-for-x86_64.patch

