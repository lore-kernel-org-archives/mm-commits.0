From: akpm@linux-foundation.org
Subject: [to-be-updated] kbuild-remove-generated-logo-files.patch removed from -mm tree
Date: Thu, 09 Apr 2009 14:05:16 -0700
Message-ID: <200904092105.n39L5HYY025473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932881AbZDIVIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 17:08:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, Geert.Uytterhoeven@sonycom.com, jsimmons@infradead.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     kbuild: remove generated logo files
has been removed from the -mm tree.  Its filename was
     kbuild-remove-generated-logo-files.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: remove generated logo files
From: Sam Ravnborg <sam@ravnborg.org>

Presently we have to remove the generated logos, as they're not automatically
regenerated if scripts/pnmtologo.c changes.  Fix.

Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/logo/Makefile |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/video/logo/Makefile~kbuild-remove-generated-logo-files drivers/video/logo/Makefile
--- a/drivers/video/logo/Makefile~kbuild-remove-generated-logo-files
+++ a/drivers/video/logo/Makefile
@@ -37,22 +37,24 @@ extra-y += $(call logo-cfiles,_clut224,p
 # Gray 256
 extra-y += $(call logo-cfiles,_gray256,pgm)
 
+pnmtlogo := scripts/pnmtologo
+
 # Create commands like "pnmtologo -t mono -n logo_mac_mono -o ..."
 quiet_cmd_logo = LOGO    $@
-	cmd_logo = scripts/pnmtologo \
+	cmd_logo = $(pnmtologo) \
 			-t $(patsubst $*_%,%,$(notdir $(basename $<))) \
 			-n $(notdir $(basename $<)) -o $@ $<
 
-$(obj)/%_mono.c: $(src)/%_mono.pbm FORCE
+$(obj)/%_mono.c: $(src)/%_mono.pbm $(pnmtlogo) FORCE
 	$(call if_changed,logo)
 
-$(obj)/%_vga16.c: $(src)/%_vga16.ppm FORCE
+$(obj)/%_vga16.c: $(src)/%_vga16.ppm $(pnmtlogo) FORCE
 	$(call if_changed,logo)
 
-$(obj)/%_clut224.c: $(src)/%_clut224.ppm FORCE
+$(obj)/%_clut224.c: $(src)/%_clut224.ppm $(pnmtlogo) FORCE
 	$(call if_changed,logo)
 
-$(obj)/%_gray256.c: $(src)/%_gray256.pgm FORCE
+$(obj)/%_gray256.c: $(src)/%_gray256.pgm $(pnmtlogo) FORCE
 	$(call if_changed,logo)
 
 # Files generated that shall be removed upon make clean
_

Patches currently in -mm which might be from sam@ravnborg.org are

kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux.patch
kernel-kallsymsc-replace-deprecated-__initcall-with-device_initcall-and-fix-whitespace.patch
setlocalversion-use-git-svn-instead-of-git-svn.patch
kbuild-remove-generated-logo-files.patch
kbuild-remove-generated-logo-files-fix.patch
fbdev-move-logo-externs-to-header-file.patch

