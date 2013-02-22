From: akpm@linux-foundation.org
Subject: [merged] decompressors-make-the-default-xz_dec_-config-match-the-selected-architecture.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:42 -0800
Message-ID: <20130222204242.AC8FF31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:33882 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:43 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so104051ggi.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: florian@openwrt.org, lasse.collin@tukaani.org, mm-commits@vger.kernel.org


The patch titled
     Subject: decompressors: make the default XZ_DEC_* config match the selected architecture
has been removed from the -mm tree.  Its filename was
     decompressors-make-the-default-xz_dec_-config-match-the-selected-architecture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Florian Fainelli <florian@openwrt.org>
Subject: decompressors: make the default XZ_DEC_* config match the selected architecture

Change the defautl XZ_DEC_* config symbol to match the configured
architecture.  It is perfectly legitimate to support multiple XZ BCJ
filters for different architectures (e.g.: to mount foreign squashfs/xz
compressed filesystems), it is however more natural not to select them all
by default, but only the one matching the configured architecture.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Acked-by: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xz/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN lib/xz/Kconfig~decompressors-make-the-default-xz_dec_-config-match-the-selected-architecture lib/xz/Kconfig
--- a/lib/xz/Kconfig~decompressors-make-the-default-xz_dec_-config-match-the-selected-architecture
+++ a/lib/xz/Kconfig
@@ -10,32 +10,32 @@ if XZ_DEC
 
 config XZ_DEC_X86
 	bool "x86 BCJ filter decoder"
-	default y
+	default y if X86
 	select XZ_DEC_BCJ
 
 config XZ_DEC_POWERPC
 	bool "PowerPC BCJ filter decoder"
-	default y
+	default y if POWERPC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_IA64
 	bool "IA-64 BCJ filter decoder"
-	default y
+	default y if IA64
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARM
 	bool "ARM BCJ filter decoder"
-	default y
+	default y if ARM
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARMTHUMB
 	bool "ARM-Thumb BCJ filter decoder"
-	default y
+	default y if (ARM && ARM_THUMB)
 	select XZ_DEC_BCJ
 
 config XZ_DEC_SPARC
 	bool "SPARC BCJ filter decoder"
-	default y
+	default y if SPARC
 	select XZ_DEC_BCJ
 
 endif
_

Patches currently in -mm which might be from florian@openwrt.org are

origin.patch
linux-next.patch

