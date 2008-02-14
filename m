From: akpm@linux-foundation.org
Subject: + m68knommu-use-asflags-instead-of-extra_aflags.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:07:56 -0800
Message-ID: <200802142107.m1EL7uBj002884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756783AbYBNVJQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:09:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org, sam@ravnborg.org


The patch titled
     m68knommu: use asflags instead of EXTRA_AFLAGS
has been added to the -mm tree.  Its filename is
     m68knommu-use-asflags-instead-of-extra_aflags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: use asflags instead of EXTRA_AFLAGS
From: Greg Ungerer <gerg@snapgear.com>

Modify the extra asm flags for debugger capabilities, use asflags instead for
EXTRA_AFLAGS.  Suggestion from Sam Ravnborg.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/platform/5206/Makefile     |    4 +---
 arch/m68knommu/platform/5206e/Makefile    |    4 +---
 arch/m68knommu/platform/520x/Makefile     |    4 +---
 arch/m68knommu/platform/523x/Makefile     |    4 +---
 arch/m68knommu/platform/5249/Makefile     |    4 +---
 arch/m68knommu/platform/5272/Makefile     |    4 +---
 arch/m68knommu/platform/527x/Makefile     |    4 +---
 arch/m68knommu/platform/528x/Makefile     |    4 +---
 arch/m68knommu/platform/5307/Makefile     |    4 +---
 arch/m68knommu/platform/532x/Makefile     |    4 +---
 arch/m68knommu/platform/5407/Makefile     |    4 +---
 arch/m68knommu/platform/coldfire/Makefile |    4 +---
 12 files changed, 12 insertions(+), 36 deletions(-)

diff -puN arch/m68knommu/platform/5206/Makefile~m68knommu-use-asflags-instead-of-extra_aflags arch/m68knommu/platform/5206/Makefile
--- a/arch/m68knommu/platform/5206/Makefile~m68knommu-use-asflags-instead-of-extra_aflags
+++ a/arch/m68knommu/platform/5206/Makefile
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
 
diff -puN arch/m68knommu/platform/5206e/Makefile~m68knommu-use-asflags-instead-of-extra_aflags arch/m68knommu/platform/5206e/Makefile
--- a/arch/m68knommu/platform/5206e/Makefile~m68knommu-use-asflags-instead-of-extra_aflags
+++ a/arch/m68knommu/platform/5206e/Makefile
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
 
diff -puN arch/m68knommu/platform/520x/Makefile~m68knommu-use-asflags-instead-of-extra_aflags arch/m68knommu/platform/520x/Makefile
--- a/arch/m68knommu/platform/520x/Makefile~m68knommu-use-asflags-instead-of-extra_aflags
+++ a/arch/m68knommu/platform/520x/Makefile
@@ -12,8 +12,6 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
diff -puN arch/m68knommu/platform/523x/Makefile~m68knommu-use-asflags-instead-of-extra_aflags arch/m68knommu/platform/523x/Makefile
--- a/arch/m68knommu/platform/523x/Makefile~m68knommu-use-asflags-instead-of-extra_aflags
+++ a/arch/m68knommu/platform/523x/Makefile
@@ -12,8 +12,6 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
diff -puN arch/m68knommu/platform/5249/Makefile~m68knommu-use-asflags-instead-of-extra_aflags arch/m68knommu/platform/5249/Makefile
--- a/arch/m68knommu/platform/5249/Makefile~m68knommu-use-asflags-instead-of-extra_aflags
+++ a/arch/m68knommu/platform/5249/Makefile
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
 
diff -puN arch/m68knommu/platform/5272/Makefile~m68knommu-use-asflags-instead-of-extra_aflags arch/m68knommu/platform/5272/Makefile
--- a/arch/m68knommu/platform/5272/Makefile~m68knommu-use-asflags-instead-of-extra_aflags
+++ a/arch/m68knommu/platform/5272/Makefile
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
 
diff -puN arch/m68knommu/platform/527x/Makefile~m68knommu-use-asflags-instead-of-extra_aflags arch/m68knommu/platform/527x/Makefile
--- a/arch/m68knommu/platform/527x/Makefile~m68knommu-use-asflags-instead-of-extra_aflags
+++ a/arch/m68knommu/platform/527x/Makefile
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
 
diff -puN arch/m68knommu/platform/528x/Makefile~m68knommu-use-asflags-instead-of-extra_aflags arch/m68knommu/platform/528x/Makefile
--- a/arch/m68knommu/platform/528x/Makefile~m68knommu-use-asflags-instead-of-extra_aflags
+++ a/arch/m68knommu/platform/528x/Makefile
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
 
diff -puN arch/m68knommu/platform/5307/Makefile~m68knommu-use-asflags-instead-of-extra_aflags arch/m68knommu/platform/5307/Makefile
--- a/arch/m68knommu/platform/5307/Makefile~m68knommu-use-asflags-instead-of-extra_aflags
+++ a/arch/m68knommu/platform/5307/Makefile
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y	+= config.o
 
diff -puN arch/m68knommu/platform/532x/Makefile~m68knommu-use-asflags-instead-of-extra_aflags arch/m68knommu/platform/532x/Makefile
--- a/arch/m68knommu/platform/532x/Makefile~m68knommu-use-asflags-instead-of-extra_aflags
+++ a/arch/m68knommu/platform/532x/Makefile
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 #obj-y := config.o usb-mcf532x.o spi-mcf532x.o
 obj-y := config.o
diff -puN arch/m68knommu/platform/5407/Makefile~m68knommu-use-asflags-instead-of-extra_aflags arch/m68knommu/platform/5407/Makefile
--- a/arch/m68knommu/platform/5407/Makefile~m68knommu-use-asflags-instead-of-extra_aflags
+++ a/arch/m68knommu/platform/5407/Makefile
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-y := config.o
 
diff -puN arch/m68knommu/platform/coldfire/Makefile~m68knommu-use-asflags-instead-of-extra_aflags arch/m68knommu/platform/coldfire/Makefile
--- a/arch/m68knommu/platform/coldfire/Makefile~m68knommu-use-asflags-instead-of-extra_aflags
+++ a/arch/m68knommu/platform/coldfire/Makefile
@@ -12,9 +12,7 @@
 # EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
 #
 
-ifdef CONFIG_FULLDEBUG
-AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
-endif
+asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 obj-$(CONFIG_COLDFIRE)	+= dma.o entry.o vectors.o
 obj-$(CONFIG_M5206)	+= timers.o
_

Patches currently in -mm which might be from gerg@snapgear.com are

m68knommu-avoid-unneccessary-use-of-xchg-in-set_mb.patch
m68knommu-use-asflags-instead-of-extra_aflags.patch
m68knommu-use-tabs-not-spaces-in-cacheflushh.patch
