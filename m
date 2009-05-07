From: akpm@linux-foundation.org
Subject: + menu-fix-embedded-menu-presentation.patch added to -mm tree
Date: Thu, 07 May 2009 13:07:39 -0700
Message-ID: <200905072007.n47K7dpi020411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753990AbZEGUKR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 16:10:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, sam@ravnborg.org


The patch titled
     menu: fix embedded menu presentation
has been added to the -mm tree.  Its filename is
     menu-fix-embedded-menu-presentation.patch

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
@@ -808,14 +808,6 @@ config KALLSYMS_EXTRA_PASS
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
@@ -961,6 +953,14 @@ config SLUB_DEBUG
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

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
menu-fix-embedded-menu-presentation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
lockd-fix-file_locking=n-build-error.patch
xen-use-header-for-export_symbol_gpl.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

