From: akpm@linux-foundation.org
Subject: [merged] lib-xz-enable-all-filters-by-default-in-kconfig.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 13:05:11 -0700
Message-ID: <5390cd77.037qcLmmLD5qSg3V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaFEUFM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:05:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, phillip@lougher.demon.co.uk, kyle@infradead.org, f.fainelli@gmail.com, lasse.collin@tukaani.org

Subject: [merged] lib-xz-enable-all-filters-by-default-in-kconfig.patch removed from -mm tree
To: lasse.collin@tukaani.org,f.fainelli@gmail.com,kyle@infradead.org,phillip@lougher.demon.co.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:05:11 -0700


The patch titled
     Subject: lib/xz: enable all filters by default in Kconfig
has been removed from the -mm tree.  Its filename was
     lib-xz-enable-all-filters-by-default-in-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: lib/xz: enable all filters by default in Kconfig

This restores the old behavior that existed before 2013-02-22, when
changes were made by 64dbfb444c150 ("decompressors: drop dependency on
CONFIG_EXPERT") and 5dc49c75a2 ("decompressors: make the default XZ_DEC_*
config match the selected architecture").

Disabling the filters only makes sense on embedded systems.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Acked-by: Kyle McMartin <kyle@infradead.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xz/Kconfig |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN lib/xz/Kconfig~lib-xz-enable-all-filters-by-default-in-kconfig lib/xz/Kconfig
--- a/lib/xz/Kconfig~lib-xz-enable-all-filters-by-default-in-kconfig
+++ a/lib/xz/Kconfig
@@ -9,33 +9,33 @@ config XZ_DEC
 if XZ_DEC
 
 config XZ_DEC_X86
-	bool "x86 BCJ filter decoder"
-	default y if X86
+	bool "x86 BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_POWERPC
-	bool "PowerPC BCJ filter decoder"
-	default y if PPC
+	bool "PowerPC BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_IA64
-	bool "IA-64 BCJ filter decoder"
-	default y if IA64
+	bool "IA-64 BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARM
-	bool "ARM BCJ filter decoder"
-	default y if ARM
+	bool "ARM BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARMTHUMB
-	bool "ARM-Thumb BCJ filter decoder"
-	default y if (ARM && ARM_THUMB)
+	bool "ARM-Thumb BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_SPARC
-	bool "SPARC BCJ filter decoder"
-	default y if SPARC
+	bool "SPARC BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 endif
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

origin.patch
linux-next.patch

