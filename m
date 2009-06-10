From: akpm@linux-foundation.org
Subject: [merged] menu-fix-embedded-menu-presentation.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:44:10 -0700
Message-ID: <200906101744.n5AHiAAb030872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755976AbZFJRpD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:45:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     menu: fix embedded menu presentation
has been removed from the -mm tree.  Its filename was
     menu-fix-embedded-menu-presentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: menu: fix embedded menu presentation
From: Randy Dunlap <randy.dunlap@oracle.com>

The STRIP_ASM_SYMS kconfig symbol mucks up the embedded menu because
STRIP_ASM_SYMS is in the middle of the embedded menu items but it does not
depend on EMBEDDED.  Move it to beyond the end of the embedded menu so
that the menu is presented correctly.

Or if STRIP_ASM_SYMS should depend on EMBEDDED, that can also be fixed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN init/Kconfig~menu-fix-embedded-menu-presentation init/Kconfig
--- a/init/Kconfig~menu-fix-embedded-menu-presentation
+++ a/init/Kconfig
@@ -809,14 +809,6 @@ config KALLSYMS_EXTRA_PASS
 	   you wait for kallsyms to be fixed.
 
 
-config STRIP_ASM_SYMS
-	bool "Strip assembler-generated symbols during link"
-	default n
-	help
-	  Strip internal assembler-generated symbols during a link (symbols
-	  that look like '.Lxxx') so they don't pollute the output of
-	  get_wchan() and suchlike.
-
 config HOTPLUG
 	bool "Support for hot-pluggable devices" if EMBEDDED
 	default y
@@ -962,6 +954,14 @@ config SLUB_DEBUG
 	  SLUB sysfs support. /sys/slab will not exist and there will be
 	  no support for cache validation etc.
 
+config STRIP_ASM_SYMS
+	bool "Strip assembler-generated symbols during link"
+	default n
+	help
+	  Strip internal assembler-generated symbols during a link (symbols
+	  that look like '.Lxxx') so they don't pollute the output of
+	  get_wchan() and suchlike.
+
 config COMPAT_BRK
 	bool "Disable heap randomization"
 	default y
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
hexdump-remove-the-trailing-space.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
lis3-use-input_polled_device-fix.patch
lis3-use-input_polled_device-fix-2.patch
cgroups-make-messages-more-readable.patch
rapidio-fix-kerneldoc-for-rio_mem_ops.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

