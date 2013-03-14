From: akpm@linux-foundation.org
Subject: [merged] decompressors-fix-typo-powerpc.patch removed from -mm tree
Date: Thu, 14 Mar 2013 11:52:39 -0700
Message-ID: <20130314185239.7D3035A41B0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:40354 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3CNSwk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 14:52:40 -0400
Received: by mail-yh0-f74.google.com with SMTP id z6so258620yhz.5
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 11:52:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pebolle@tiscali.nl, benh@kernel.crashing.org, florian@openwrt.org, lasse.collin@tukaani.org, mm-commits@vger.kernel.org


The patch titled
     Subject: decompressors: fix typo "POWERPC"
has been removed from the -mm tree.  Its filename was
     decompressors-fix-typo-powerpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paul Bolle <pebolle@tiscali.nl>
Subject: decompressors: fix typo "POWERPC"

Commit 5dc49c75a2 ("decompressors: make the default XZ_DEC_* config match
the selected architecture") added

	default y if POWERPC

to lib/xz/Kconfig.  But there is no Kconfig symbol POWERPC.  The most
general Kconfig symbol for the powerpc architecture is PPC.  So let's use
that.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Lasse Collin <lasse.collin@tukaani.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xz/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/xz/Kconfig~decompressors-fix-typo-powerpc lib/xz/Kconfig
--- a/lib/xz/Kconfig~decompressors-fix-typo-powerpc
+++ a/lib/xz/Kconfig
@@ -15,7 +15,7 @@ config XZ_DEC_X86
 
 config XZ_DEC_POWERPC
 	bool "PowerPC BCJ filter decoder"
-	default y if POWERPC
+	default y if PPC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_IA64
_

Patches currently in -mm which might be from pebolle@tiscali.nl are

origin.patch
linux-next.patch
drivers-video-backlight-kconfig-fix-typo-mach_sam9ek-three-times.patch

