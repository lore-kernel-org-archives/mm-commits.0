From: akpm@linux-foundation.org
Subject: + lib-add-support-for-lz4-compressed-kernel-kbuild-fix-for-updated-lz4-tool-with-the-new-streaming-format.patch added to -mm tree
Date: Wed, 08 May 2013 12:34:15 -0700
Message-ID: <20130508193415.92BC431C1EA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:61501 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3EHTeR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 15:34:17 -0400
Received: by mail-ve0-f202.google.com with SMTP id 15so214431vea.3
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 12:34:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungsik.lee@lge.com, bp@alien8.de, chanho.min@lge.com, florian@openwrt.org, hpa@zytor.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, yann.collet.73@gmail.com


The patch titled
     Subject: kbuild: fix for updated LZ4 tool with the new streaming format
has been added to the -mm tree.  Its filename is
     lib-add-support-for-lz4-compressed-kernel-kbuild-fix-for-updated-lz4-tool-with-the-new-streaming-format.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
lib-add-support-for-lz4-compressed-kernel-kbuild-fix-for-updated-lz4-tool-with-the-new-streaming-format.patch
arm-add-support-for-lz4-compressed-kernel.patch
arm-add-support-for-lz4-compressed-kernel-fix.patch
x86-add-support-for-lz4-compressed-kernel.patch
x86-add-support-for-lz4-compressed-kernel-doc-add-lz4-magic-number-for-the-new-compression.patch
lib-add-lz4-compressor-module.patch
crypto-add-lz4-cryptographic-api.patch
crypto-add-lz4-cryptographic-api-fix.patch

