From: akpm@linux-foundation.org
Subject: + kernel-hacking-move-strip_asm_syms-from-general.patch added to -mm tree
Date: Wed, 01 Jul 2009 15:34:34 -0700
Message-ID: <200907012234.n61MYYee016957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946AbZGAWej (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 18:34:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, sam@ravnborg.org


The patch titled
     kernel hacking: move STRIP_ASM_SYMS from General
has been added to the -mm tree.  Its filename is
     kernel-hacking-move-strip_asm_syms-from-general.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel hacking: move STRIP_ASM_SYMS from General
From: Randy Dunlap <randy.dunlap@oracle.com>

Sam suggested moving STRIP_ASM_SYMS into the Kernel hacking menu
from the General Setup menu.  It makes more sense there.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig      |    8 --------
 lib/Kconfig.debug |    8 ++++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN init/Kconfig~kernel-hacking-move-strip_asm_syms-from-general init/Kconfig
--- a/init/Kconfig~kernel-hacking-move-strip_asm_syms-from-general
+++ a/init/Kconfig
@@ -991,14 +991,6 @@ config SLUB_DEBUG
 	  SLUB sysfs support. /sys/slab will not exist and there will be
 	  no support for cache validation etc.
 
-config STRIP_ASM_SYMS
-	bool "Strip assembler-generated symbols during link"
-	default n
-	help
-	  Strip internal assembler-generated symbols during a link (symbols
-	  that look like '.Lxxx') so they don't pollute the output of
-	  get_wchan() and suchlike.
-
 config COMPAT_BRK
 	bool "Disable heap randomization"
 	default y
diff -puN lib/Kconfig.debug~kernel-hacking-move-strip_asm_syms-from-general lib/Kconfig.debug
--- a/lib/Kconfig.debug~kernel-hacking-move-strip_asm_syms-from-general
+++ a/lib/Kconfig.debug
@@ -50,6 +50,14 @@ config MAGIC_SYSRQ
 	  keys are documented in <file:Documentation/sysrq.txt>. Don't say Y
 	  unless you really know what this hack does.
 
+config STRIP_ASM_SYMS
+	bool "Strip assembler-generated symbols during link"
+	default n
+	help
+	  Strip internal assembler-generated symbols during a link (symbols
+	  that look like '.Lxxx') so they don't pollute the output of
+	  get_wchan() and suchlike.
+
 config UNUSED_SYMBOLS
 	bool "Enable unused/obsolete exported symbols"
 	default y if X86
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
kernel-doc-move-ignoring-kmemcheck.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
lis3-add-power-management-functions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch

