From: akpm@linux-foundation.org
Subject: - i386-fix-usage-of-mtune-when-x86_generic=y-or-config_mcore2=y.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:38:23 -0700
Message-ID: <200703292338.l2TNcNga015216@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43092 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934380AbXC2Xif (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:38:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasse.collin@tukaani.org, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: fix usage of -mtune when X86_GENERIC=y or CONFIG_MCORE2=y
has been removed from the -mm tree.  Its filename was
     i386-fix-usage-of-mtune-when-x86_generic=y-or-config_mcore2=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: fix usage of -mtune when X86_GENERIC=y or CONFIG_MCORE2=y
From: Lasse Collin <lasse.collin@tukaani.org>

Two fixes to arch/i386/Makefile.cpu:

1) When X86_GENERIC=y is set, use -mtune=i686 if $(CC) doesn't
   support -mtune=generic. GCC 4.1.2 and earlier don't support
   -mtune=generic. When building a generic kernel for a distro
   that runs on i586 and better, it is nice to use
   -march=i586 -mtune=i686 instead of plain -march=i586.

2) Use $(call tune) instead of hardcoded -mtune when CONFIG_MCORE2=y.
   This makes it possible to have CONFIG_MCORE2=y when using GCC 3.3,
   which uses -mcpu instead of -mtune. Also dropped fallback to
   -mtune=generic and -mtune=i686, because -march=i686 already
   implies -mtune=i686.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Makefile.cpu |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/i386/Makefile.cpu~i386-fix-usage-of-mtune-when-x86_generic=y-or-config_mcore2=y arch/i386/Makefile.cpu
--- a/arch/i386/Makefile.cpu~i386-fix-usage-of-mtune-when-x86_generic=y-or-config_mcore2=y
+++ a/arch/i386/Makefile.cpu
@@ -4,9 +4,9 @@
 #-mtune exists since gcc 3.4
 HAS_MTUNE	:= $(call cc-option-yn, -mtune=i386)
 ifeq ($(HAS_MTUNE),y)
-tune		= $(call cc-option,-mtune=$(1),)
+tune		= $(call cc-option,-mtune=$(1),$(2))
 else
-tune		= $(call cc-option,-mcpu=$(1),)
+tune		= $(call cc-option,-mcpu=$(1),$(2))
 endif
 
 align := $(cc-option-align)
@@ -33,7 +33,7 @@ cflags-$(CONFIG_MWINCHIP3D)	+= $(call cc
 cflags-$(CONFIG_MCYRIXIII)	+= $(call cc-option,-march=c3,-march=i486) $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
 cflags-$(CONFIG_MVIAC3_2)	+= $(call cc-option,-march=c3-2,-march=i686)
 cflags-$(CONFIG_MVIAC7)		+= -march=i686
-cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call cc-option,-mtune=core2,$(call cc-option,-mtune=generic,-mtune=i686))
+cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call tune,core2)
 
 # AMD Elan support
 cflags-$(CONFIG_X86_ELAN)	+= -march=i486
@@ -43,5 +43,5 @@ cflags-$(CONFIG_MGEODEGX1)	+= -march=pen
 
 # add at the end to overwrite eventual tuning options from earlier
 # cpu entries
-cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic)
+cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic,$(call tune,i686))
 
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are
