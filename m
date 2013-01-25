From: akpm@linux-foundation.org
Subject: + decompressors-make-the-default-xz_dec_-config-match-the-selected-architecture.patch added to -mm tree
Date: Fri, 25 Jan 2013 15:23:37 -0800
Message-ID: <20130125232338.3178C5A4241@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:42769 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab3AYXXj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 18:23:39 -0500
Received: by mail-qc0-f201.google.com with SMTP id a22so91212qcs.2
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 15:23:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florian@openwrt.org, lasse.collin@tukaani.org


The patch titled
     Subject: decompressors: make the default XZ_DEC_* config match the selected architecture
has been added to the -mm tree.  Its filename is
     decompressors-make-the-default-xz_dec_-config-match-the-selected-architecture.patch

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

linux-next.patch
decompressors-group-xz_dec_-symbols-under-an-if-xz_bcj-endif.patch
decompressors-drop-dependency-on-config_expert.patch
decompressors-make-the-default-xz_dec_-config-match-the-selected-architecture.patch

