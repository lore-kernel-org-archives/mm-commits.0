From: akpm@linux-foundation.org
Subject: [merged] kbuild-fix-cc1-options-check-to-ensure-we-do-not-use-fpic-when-compiling.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:04:35 -0700
Message-ID: <200909232004.n8NK4Ziw021608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753942AbZIWUFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anarchy@gentoo.org, hpa@zytor.com, johansson_fredric@hotmail.com, sam@ravnborg.org, zorry@ume.nu, mm-commits@vger.kernel.org


The patch titled
     kbuild: fix cc1 options check to ensure we do not use -fPIC when compiling
has been removed from the -mm tree.  Its filename was
     kbuild-fix-cc1-options-check-to-ensure-we-do-not-use-fpic-when-compiling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: fix cc1 options check to ensure we do not use -fPIC when compiling
From: "Jory A. Pratt" <anarchy@gentoo.org>

The arch/*/boot/Makefile use cc-options to check for GCC command options
and cc-options use the hardened specs when checking for GCC command
options.  When -fPIE is pass to cc1 it can't use -ffreestanding or
-fno-toplevel-reorder.  Then it fail to build stuff with -ffreestanding
and -fno-toplevel-reorder.

Thanks to Fredric Johansson for finding the main problem behind a failed
build using a hardened toolchain.

Signed-off-by: Magnus Granberg <zorry@ume.nu>
Signed-off-by: Jory A. Pratt <anarchy@gentoo.org>
Cc: Fredric Johansson <johansson_fredric@hotmail.com> 
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Kbuild.include |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/Kbuild.include~kbuild-fix-cc1-options-check-to-ensure-we-do-not-use-fpic-when-compiling scripts/Kbuild.include
--- a/scripts/Kbuild.include~kbuild-fix-cc1-options-check-to-ensure-we-do-not-use-fpic-when-compiling
+++ a/scripts/Kbuild.include
@@ -105,12 +105,12 @@ as-instr = $(call try-run,\
 # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
 
 cc-option = $(call try-run,\
-	$(CC) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",$(1),$(2))
 
 # cc-option-yn
 # Usage: flag := $(call cc-option-yn,-march=winchip-c6)
 cc-option-yn = $(call try-run,\
-	$(CC) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",y,n)
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",y,n)
 
 # cc-option-align
 # Prefix align with either -falign or -malign
_

Patches currently in -mm which might be from anarchy@gentoo.org are

linux-next.patch

