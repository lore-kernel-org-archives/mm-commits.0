From: akpm@linux-foundation.org
Subject: + decompressors-group-xz_dec_-symbols-under-an-if-xz_bcj-endif.patch added to -mm tree
Date: Fri, 25 Jan 2013 15:23:32 -0800
Message-ID: <20130125232333.2834031C00F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:42848 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3AYXXe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 18:23:34 -0500
Received: by mail-qa0-f73.google.com with SMTP id dx4so6535qab.2
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 15:23:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florian@openwrt.org, lasse.collin@tukaani.org


The patch titled
     Subject: decompressors: group XZ_DEC_* symbols under an if XZ_BCJ / endif
has been added to the -mm tree.  Its filename is
     decompressors-group-xz_dec_-symbols-under-an-if-xz_bcj-endif.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
decompressors-group-xz_dec_-symbols-under-an-if-xz_bcj-endif.patch
decompressors-drop-dependency-on-config_expert.patch
decompressors-make-the-default-xz_dec_-config-match-the-selected-architecture.patch

