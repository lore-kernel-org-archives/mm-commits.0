From: akpm@linux-foundation.org
Subject: + menu-fix-embedded-menu-order.patch added to -mm tree
Date: Mon, 04 May 2009 14:37:53 -0700
Message-ID: <200905042137.n44LbrBq010120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbZEDVjr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 17:39:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, sam@ravnborg.org


The patch titled
     menu: fix embedded menu order
has been added to the -mm tree.  Its filename is
     menu-fix-embedded-menu-order.patch

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
Subject: menu: fix embedded menu order
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix Embedded menu order/structure.

The "EMBEDDED" menu display is broken, i.e., it is split apart, not
displayed entirely in one place, due to some symbols not being listed as
"if EMBEDDED".  Make them be displayed all together.

Tested with menuconfig, xconfig, & gconfig.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN init/Kconfig~menu-fix-embedded-menu-order init/Kconfig
--- a/init/Kconfig~menu-fix-embedded-menu-order
+++ a/init/Kconfig
@@ -786,7 +786,7 @@ config KALLSYMS
 	   somewhat, as all symbols have to be loaded into the kernel image.
 
 config KALLSYMS_ALL
-	bool "Include all symbols in kallsyms"
+	bool "Include all symbols in kallsyms" if EMBEDDED
 	depends on DEBUG_KERNEL && KALLSYMS
 	help
 	   Normally kallsyms only contains the symbols of functions, for nicer
@@ -797,7 +797,7 @@ config KALLSYMS_ALL
 	   Say N.
 
 config KALLSYMS_EXTRA_PASS
-	bool "Do an extra kallsyms pass"
+	bool "Do an extra kallsyms pass" if EMBEDDED
 	depends on KALLSYMS
 	help
 	   If kallsyms is not working correctly, the build will fail with
@@ -807,9 +807,8 @@ config KALLSYMS_EXTRA_PASS
 	   reported.  KALLSYMS_EXTRA_PASS is only a temporary workaround while
 	   you wait for kallsyms to be fixed.
 
-
 config STRIP_ASM_SYMS
-	bool "Strip assembler-generated symbols during link"
+	bool "Strip assembler-generated symbols during link" if EMBEDDED
 	default n
 	help
 	  Strip internal assembler-generated symbols during a link (symbols
@@ -961,6 +960,9 @@ config SLUB_DEBUG
 	  SLUB sysfs support. /sys/slab will not exist and there will be
 	  no support for cache validation etc.
 
+# end EMBEDDED menu -- don't put non-EMBEDDED items between
+# "menuconfig EMBEDDED" and here.
+
 config COMPAT_BRK
 	bool "Disable heap randomization"
 	default y
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
nfsd-use-c99-struct-initializers.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
menu-fix-embedded-menu-order.patch
lockd-fix-file_locking=n-build-error.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

