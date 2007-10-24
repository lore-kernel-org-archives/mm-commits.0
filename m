From: akpm@linux-foundation.org
Subject: + m68k-use-cc-cross-prefix.patch added to -mm tree
Date: Tue, 23 Oct 2007 23:32:14 -0700
Message-ID: <200710240632.l9O6WEFl026528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33842 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753517AbXJXGdj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 02:33:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, sam@ravnborg.org, schwab@suse.de


The patch titled
     m68k: Use cc-cross-prefix
has been added to the -mm tree.  Its filename is
     m68k-use-cc-cross-prefix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68k: Use cc-cross-prefix
From: Geert Uytterhoeven <geert@linux-m68k.org>

The cc-cross-prefix is new and developed on request from Geert Uytterhoeven.

With cc-cross-prefix it is now much easier to have a few default cross compile
prefixes and defaulting to none - if none of them were present.  ARCH
maintainers are expected to pick up this feature soon.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andreas Schwab <schwab@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/Makefile |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN arch/m68k/Makefile~m68k-use-cc-cross-prefix arch/m68k/Makefile
--- a/arch/m68k/Makefile~m68k-use-cc-cross-prefix
+++ a/arch/m68k/Makefile
@@ -13,16 +13,15 @@
 # Copyright (C) 1994 by Hamish Macdonald
 #
 
-# test for cross compiling
-COMPILE_ARCH = $(shell uname -m)
-
 # override top level makefile
 AS += -m68020
 LDFLAGS := -m m68kelf
 LDFLAGS_MODULE += -T $(srctree)/arch/m68k/kernel/module.lds
-ifneq ($(COMPILE_ARCH),$(ARCH))
-	# prefix for cross-compiling binaries
-	CROSS_COMPILE = m68k-linux-gnu-
+ifneq ($(SUBARCH),$(ARCH))
+	ifeq ($(CROSS_COMPILE),)
+		CROSS_COMPILE := $(call cc-cross-prefix, \
+			m68k-linux-gnu- m68k-linux- m68k-unknown-linux-gnu-)
+	endif
 endif
 
 ifdef CONFIG_SUN3
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
m68k-use-cc-cross-prefix.patch
