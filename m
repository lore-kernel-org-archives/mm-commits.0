From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-add-support-for-lz4-compressed-kernel-kbuild-fix-for-updated-lz4-tool-with-the-new-streaming-format.patch removed from -mm tree
Date: Mon, 08 Jul 2013 15:44:45 -0700
Message-ID: <51db40dd.lIy+Nu6A7NWLyHZC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3GHWoq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 18:44:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yann.collet.73@gmail.com, tglx@linutronix.de, rmk@arm.linux.org.uk, mingo@elte.hu, hpa@zytor.com, florian@openwrt.org, chanho.min@lge.com, bp@alien8.de, kyungsik.lee@lge.com

Subject: [folded-merged] lib-add-support-for-lz4-compressed-kernel-kbuild-fix-for-updated-lz4-tool-with-the-new-streaming-format.patch removed from -mm tree
To: kyungsik.lee@lge.com,bp@alien8.de,chanho.min@lge.com,florian@openwrt.org,hpa@zytor.com,mingo@elte.hu,rmk@arm.linux.org.uk,tglx@linutronix.de,yann.collet.73@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 15:44:45 -0700


The patch titled
     Subject: kbuild: fix for updated LZ4 tool with the new streaming format
has been removed from the -mm tree.  Its filename was
     lib-add-support-for-lz4-compressed-kernel-kbuild-fix-for-updated-lz4-tool-with-the-new-streaming-format.patch

This patch was dropped because it was folded into lib-add-support-for-lz4-compressed-kernel.patch

------------------------------------------------------
From: Kyungsik Lee <kyungsik.lee@lge.com>
Subject: kbuild: fix for updated LZ4 tool with the new streaming format

LZ4 has been updated with LZ4 Streaming Format specification(v1.3).
lz4demo is replaced by lz4c. lz4c supports both the new streaming and
legacy format with -l option.

This patch makes use of lz4c to support legacy format which is
used for LZ4 De/compression in the linux kernel.

Link: https://code.google.com/p/lz4/source/checkout

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Yann Collet <yann.collet.73@gmail.com>
Cc: Chanho Min <chanho.min@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.lib |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/Makefile.lib~lib-add-support-for-lz4-compressed-kernel-kbuild-fix-for-updated-lz4-tool-with-the-new-streaming-format scripts/Makefile.lib
--- a/scripts/Makefile.lib~lib-add-support-for-lz4-compressed-kernel-kbuild-fix-for-updated-lz4-tool-with-the-new-streaming-format
+++ a/scripts/Makefile.lib
@@ -313,7 +313,7 @@ cmd_lzo = (cat $(filter-out FORCE,$^) |
 
 quiet_cmd_lz4 = LZ4     $@
 cmd_lz4 = (cat $(filter-out FORCE,$^) | \
-	lz4demo -c1 stdin stdout && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
+	lz4c -l -c1 stdin stdout && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
 	(rm -f $@ ; false)
 
 # U-Boot mkimage
_

Patches currently in -mm which might be from kyungsik.lee@lge.com are

lib-add-weak-clz-ctz-functions.patch
decompressor-add-lz4-decompressor-module.patch
lib-add-support-for-lz4-compressed-kernel.patch
arm-add-support-for-lz4-compressed-kernel.patch
lib-add-lz4-compressor-module.patch
crypto-add-lz4-cryptographic-api.patch

