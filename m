From: akpm@linux-foundation.org
Subject: [merged] kernel-hacking-move-strip_asm_syms-from-general.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:04:14 -0700
Message-ID: <200909232004.n8NK4EOb020854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753948AbZIWUE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:04:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kernel hacking: move STRIP_ASM_SYMS from General
has been removed from the -mm tree.  Its filename was
     kernel-hacking-move-strip_asm_syms-from-general.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -993,14 +993,6 @@ config SLUB_DEBUG
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
isdn-fix-netjet-build-errors.patch
include-linux-credh-fix-build.patch
scsi-fix-func-names-in-kernel-doc.patch
scsi_transport_fc-fix-missing-kernel-doc.patch
wl12xx-fix-kconfig-link-errors.patch
readahead-add-blk_run_backing_dev.patch
pcmcia-fix-controller-printk-warnings.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
includecheck-fix-documentation-cfag12864b-examplec.patch
docs-fix-various-documentation-paths-in-header-files.patch
reiser4-export-remove_from_page_cache-fix.patch

