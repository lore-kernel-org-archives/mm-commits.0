From: akpm@linux-foundation.org
Subject: + decompressors-add-boot-time-xz-support-update.patch added to -mm tree
Date: Tue, 14 Dec 2010 13:39:07 -0800
Message-ID: <201012142139.oBELd782011267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302Ab0LNVkY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Dec 2010 16:40:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk


The patch titled
     decompressors-add-boot-time-xz-support-update
has been added to the -mm tree.  Its filename is
     decompressors-add-boot-time-xz-support-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
