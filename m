From: akpm@linux-foundation.org
Subject: [merged] decompressors-group-xz_dec_-symbols-under-an-if-xz_bcj-endif.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:36 -0800
Message-ID: <20130222204236.ACA4B5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:40411 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUmh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:37 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so104122vea.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: florian@openwrt.org, lasse.collin@tukaani.org, mm-commits@vger.kernel.org


The patch titled
     Subject: decompressors: group XZ_DEC_* symbols under an if XZ_BCJ / endif
has been removed from the -mm tree.  Its filename was
     decompressors-group-xz_dec_-symbols-under-an-if-xz_bcj-endif.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Florian Fainelli <florian@openwrt.org>
Subject: decompressors: group XZ_DEC_* symbols under an if XZ_BCJ / endif

Group all architecture-specific BCJ filter configuration symbols under an
if XZ_BCJ / endif statement.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Acked-by: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xz/Kconfig |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN lib/xz/Kconfig~decompressors-group-xz_dec_-symbols-under-an-if-xz_bcj-endif lib/xz/Kconfig
--- a/lib/xz/Kconfig~decompressors-group-xz_dec_-symbols-under-an-if-xz_bcj-endif
+++ a/lib/xz/Kconfig
@@ -6,42 +6,40 @@ config XZ_DEC
 	  the .xz file format as the container. For integrity checking,
 	  CRC32 is supported. See Documentation/xz.txt for more information.
 
+if XZ_DEC
+
 config XZ_DEC_X86
 	bool "x86 BCJ filter decoder" if EXPERT
 	default y
-	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_POWERPC
 	bool "PowerPC BCJ filter decoder" if EXPERT
 	default y
-	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_IA64
 	bool "IA-64 BCJ filter decoder" if EXPERT
 	default y
-	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARM
 	bool "ARM BCJ filter decoder" if EXPERT
 	default y
-	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARMTHUMB
 	bool "ARM-Thumb BCJ filter decoder" if EXPERT
 	default y
-	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_SPARC
 	bool "SPARC BCJ filter decoder" if EXPERT
 	default y
-	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
+endif
+
 config XZ_DEC_BCJ
 	bool
 	default n
_

Patches currently in -mm which might be from florian@openwrt.org are

origin.patch
linux-next.patch

