From: akpm@linux-foundation.org
Subject: + kbuild-extend-menuconfig-for-modules-to-simplify-kconfig-file.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:08:33 -0700
Message-ID: <200808042108.m74L8Xbs030972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758769AbYHDVIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:08:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, randy.dunlap@oracle.com, sam@ravnborg.org


The patch titled
     kbuild: extend "menuconfig" for modules to simplify Kconfig file
has been added to the -mm tree.  Its filename is
     kbuild-extend-menuconfig-for-modules-to-simplify-kconfig-file.patch

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
Subject: kbuild: extend "menuconfig" for modules to simplify Kconfig file
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Given that the init/Kconfig file uses a "menuconfig" directive for modules
already, might as well wrap all the submenu entries in an "if" to toss all
those dependencies.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN init/Kconfig~kbuild-extend-menuconfig-for-modules-to-simplify-kconfig-file init/Kconfig
--- a/init/Kconfig~kbuild-extend-menuconfig-for-modules-to-simplify-kconfig-file
+++ a/init/Kconfig
@@ -845,9 +845,10 @@ menuconfig MODULES
 
 	  If unsure, say Y.
 
+if MODULES
+
 config MODULE_FORCE_LOAD
 	bool "Forced module loading"
-	depends on MODULES
 	default n
 	help
 	  Allow loading of modules without version information (ie. modprobe
@@ -856,7 +857,6 @@ config MODULE_FORCE_LOAD
 
 config MODULE_UNLOAD
 	bool "Module unloading"
-	depends on MODULES
 	help
 	  Without this option you will not be able to unload any
 	  modules (note that some modules may not be unloadable
@@ -875,7 +875,6 @@ config MODULE_FORCE_UNLOAD
 
 config MODVERSIONS
 	bool "Module versioning support"
-	depends on MODULES
 	help
 	  Usually, you have to use modules compiled with your kernel.
 	  Saying Y here makes it sometimes possible to use modules
@@ -886,7 +885,6 @@ config MODVERSIONS
 
 config MODULE_SRCVERSION_ALL
 	bool "Source checksum for all modules"
-	depends on MODULES
 	help
 	  Modules which contain a MODULE_VERSION get an extra "srcversion"
 	  field inserted into their modinfo section, which contains a
@@ -898,11 +896,12 @@ config MODULE_SRCVERSION_ALL
 
 config KMOD
 	def_bool y
-	depends on MODULES
 	help
 	  This is being removed soon.  These days, CONFIG_MODULES
 	  implies CONFIG_KMOD, so use that instead.
 
+endif # MODULES
+
 config STOP_MACHINE
 	bool
 	default y
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
kbuild-extend-menuconfig-for-modules-to-simplify-kconfig-file.patch
m32r-remove-the-unused-nohighmem-option.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
uml-remove-the-dead-tty_log-code.patch

