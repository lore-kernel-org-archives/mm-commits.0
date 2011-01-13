From: akpm@linux-foundation.org
Subject: [folded] decompressors-add-boot-time-xz-support-update.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:31:32 -0800
Message-ID: <201101130031.p0D0VWiK012670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755542Ab1AMAcL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:32:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     decompressors-add-boot-time-xz-support-update
has been removed from the -mm tree.  Its filename was
     decompressors-add-boot-time-xz-support-update.patch

This patch was dropped because it was folded into decompressors-add-boot-time-xz-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: decompressors-add-boot-time-xz-support-update
From: Lasse Collin <lasse.collin@tukaani.org>

Compared to the previous version of this patch, this makes the
XZ-compressed initramfs Kconfig option behave the same way as
the other compression methods. Now the option isn't hidden if
the xz_dec module hasn't been enabled separately. Support for
XZ-compressed initramfs is now enabled by default if !EMBEDDED.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig |    1 +
 usr/Kconfig |    9 +++------
 2 files changed, 4 insertions(+), 6 deletions(-)

diff -puN lib/Kconfig~decompressors-add-boot-time-xz-support-update lib/Kconfig
--- a/lib/Kconfig~decompressors-add-boot-time-xz-support-update
+++ a/lib/Kconfig
@@ -123,6 +123,7 @@ config DECOMPRESS_LZMA
 	tristate
 
 config DECOMPRESS_XZ
+	select XZ_DEC
 	tristate
 
 config DECOMPRESS_LZO
diff -puN usr/Kconfig~decompressors-add-boot-time-xz-support-update usr/Kconfig
--- a/usr/Kconfig~decompressors-add-boot-time-xz-support-update
+++ a/usr/Kconfig
@@ -73,15 +73,12 @@ config RD_LZMA
 	  If unsure, say N.
 
 config RD_XZ
-	bool "Support initial ramdisks compressed using XZ"
-	depends on BLK_DEV_INITRD && XZ_DEC=y
+	bool "Support initial ramdisks compressed using XZ" if EMBEDDED
+	default !EMBEDDED
+	depends on BLK_DEV_INITRD
 	select DECOMPRESS_XZ
 	help
 	  Support loading of a XZ encoded initial ramdisk or cpio buffer.
-
-	  If this option is inactive, say Y to "XZ decompression support"
-	  under "Library routines" first.
-
 	  If unsure, say N.
 
 config RD_LZO
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

documentation-email-clientstxt-warn-about-word-wrap-bug-in-kmail.patch
decompressors-add-missing-init-ie-__init.patch
decompressors-get-rid-of-set_error_fn-macro.patch
decompressors-include-linux-slabh-in-linux-decompress-mmh.patch
decompressors-remove-unused-function-from-lib-decompress_unlzmac.patch
decompressors-fix-header-validation-in-decompress_unlzmac.patch
decompressors-check-for-read-errors-in-decompress_unlzmac.patch
decompressors-check-for-write-errors-in-decompress_unlzmac.patch
decompressors-validate-match-distance-in-decompress_unlzmac.patch
decompressors-check-for-write-errors-in-decompress_unlzoc.patch
decompressors-check-input-size-in-decompress_unlzoc.patch
decompressors-fix-callback-to-callback-mode-in-decompress_unlzoc.patch
decompressors-add-xz-decompressor-module.patch
decompressors-add-boot-time-xz-support.patch
x86-support-xz-compressed-kernel.patch
decompressors-check-input-size-in-decompress_inflatec.patch
decompressors-remove-unused-constant-from-inflateh.patch

