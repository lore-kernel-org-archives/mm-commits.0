From: akpm@linux-foundation.org
Subject: + lib-xz-enable-all-filters-by-default-in-kconfig.patch added to
 -mm tree
Date: Wed, 05 Mar 2014 12:21:14 -0800
Message-ID: <5317873a.3PzSxlL/P6CZEjFf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbaCEUVP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2014 15:21:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, phillip@lougher.demon.co.uk, kyle@infradead.org, f.fainelli@gmail.com, lasse.collin@tukaani.org

Subject: + lib-xz-enable-all-filters-by-default-in-kconfig.patch added to -mm tree
To: lasse.collin@tukaani.org,f.fainelli@gmail.com,kyle@infradead.org,phillip@lougher.demon.co.uk
From: akpm@linux-foundation.org
Date: Wed, 05 Mar 2014 12:21:14 -0800


The patch titled
     Subject: lib/xz: enable all filters by default in Kconfig
has been added to the -mm tree.  Its filename is
     lib-xz-enable-all-filters-by-default-in-kconfig.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-xz-enable-all-filters-by-default-in-kconfig.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-xz-enable-all-filters-by-default-in-kconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: lib/xz: enable all filters by default in Kconfig

This restores the old behavior that existed before 2013-02-22.  Disabling
the filters only makes sense on embedded systems.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: Kyle McMartin <kyle@infradead.org>
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

lib-xz-enable-all-filters-by-default-in-kconfig.patch

