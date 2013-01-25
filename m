From: akpm@linux-foundation.org
Subject: + decompressors-drop-dependency-on-config_expert.patch added to -mm tree
Date: Fri, 25 Jan 2013 15:23:35 -0800
Message-ID: <20130125232336.23CEB5A429A@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:36371 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3AYXXh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 18:23:37 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so91399ggn.2
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 15:23:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florian@openwrt.org, lasse.collin@tukaani.org


The patch titled
     Subject: decompressors: drop dependency on CONFIG_EXPERT
has been added to the -mm tree.  Its filename is
     decompressors-drop-dependency-on-config_expert.patch

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
Subject: decompressors: drop dependency on CONFIG_EXPERT

Remove the XZ_DEC_* depedencey on CONFIG_EXPERT as recommended by Lasse
Colin.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Acked-by: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xz/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN lib/xz/Kconfig~decompressors-drop-dependency-on-config_expert lib/xz/Kconfig
--- a/lib/xz/Kconfig~decompressors-drop-dependency-on-config_expert
+++ a/lib/xz/Kconfig
@@ -9,32 +9,32 @@ config XZ_DEC
 if XZ_DEC
 
 config XZ_DEC_X86
-	bool "x86 BCJ filter decoder" if EXPERT
+	bool "x86 BCJ filter decoder"
 	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_POWERPC
-	bool "PowerPC BCJ filter decoder" if EXPERT
+	bool "PowerPC BCJ filter decoder"
 	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_IA64
-	bool "IA-64 BCJ filter decoder" if EXPERT
+	bool "IA-64 BCJ filter decoder"
 	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARM
-	bool "ARM BCJ filter decoder" if EXPERT
+	bool "ARM BCJ filter decoder"
 	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARMTHUMB
-	bool "ARM-Thumb BCJ filter decoder" if EXPERT
+	bool "ARM-Thumb BCJ filter decoder"
 	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_SPARC
-	bool "SPARC BCJ filter decoder" if EXPERT
+	bool "SPARC BCJ filter decoder"
 	default y
 	select XZ_DEC_BCJ
 
_

Patches currently in -mm which might be from florian@openwrt.org are

linux-next.patch
decompressors-group-xz_dec_-symbols-under-an-if-xz_bcj-endif.patch
decompressors-drop-dependency-on-config_expert.patch
decompressors-make-the-default-xz_dec_-config-match-the-selected-architecture.patch

