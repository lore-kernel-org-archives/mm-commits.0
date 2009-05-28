From: akpm@linux-foundation.org
Subject: + kconfig-resort-the-documentation-of-the-environment-variables.patch added to -mm tree
Date: Wed, 27 May 2009 23:43:49 -0700
Message-ID: <200905280643.n4S6hoBc014978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758985AbZE1GoN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:44:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: markus.heidelberg@web.de, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     kconfig: resort the documentation of the environment variables
has been added to the -mm tree.  Its filename is
     kconfig-resort-the-documentation-of-the-environment-variables.patch

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
Subject: kconfig: resort the documentation of the environment variables
From: Markus Heidelberg <markus.heidelberg@web.de>

All the KCONFIG_ environment variables were previously located in a
section "Environment variables in 'menuconfig'", but neither are they
restricted to 'menuconfig' nor are they all used by 'menuconfig'.

Introduce the following three sections for these variables:
  * Environment variables for '*config'
  * Environment variables for '{allyes/allmod/allno/rand}config'
  * Environment variables for 'silentoldconfig'

Furthermore this puts MENUCONFIG_MODE next to MENUCONFIG_COLOR into a
common section "User interface options for 'menuconfig'".

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kbuild/kconfig.txt |  116 +++++++++++++++--------------
 1 file changed, 60 insertions(+), 56 deletions(-)

diff -puN Documentation/kbuild/kconfig.txt~kconfig-resort-the-documentation-of-the-environment-variables Documentation/kbuild/kconfig.txt
--- a/Documentation/kbuild/kconfig.txt~kconfig-resort-the-documentation-of-the-environment-variables
+++ a/Documentation/kbuild/kconfig.txt
@@ -35,48 +35,26 @@ new .config files to see the differences
 
 (Yes, we need something better here.)
 
-
-======================================================================
-menuconfig
---------------------------------------------------
-
-SEARCHING for CONFIG symbols
-
-Searching in menuconfig:
-
-	The Search function searches for kernel configuration symbol
-	names, so you have to know something close to what you are
-	looking for.
-
-	Example:
-		/hotplug
-		This lists all config symbols that contain "hotplug",
-		e.g., HOTPLUG, HOTPLUG_CPU, MEMORY_HOTPLUG.
-
-	For search help, enter / followed TAB-TAB-TAB (to highlight
-	<Help>) and Enter.  This will tell you that you can also use
-	regular expressions (regexes) in the search string, so if you
-	are not interested in MEMORY_HOTPLUG, you could try
-
-		/^hotplug
-
-
 ______________________________________________________________________
-Color Themes for 'menuconfig'
+Environment variables for '*config'
 
-It is possible to select different color themes using the variable
-MENUCONFIG_COLOR.  To select a theme use:
+KCONFIG_CONFIG
+--------------------------------------------------
+This environment variable can be used to specify a default kernel config
+file name to override the default name of ".config".
 
-	make MENUCONFIG_COLOR=<theme> menuconfig
+KCONFIG_OVERWRITECONFIG
+--------------------------------------------------
+If you set KCONFIG_OVERWRITECONFIG in the environment, Kconfig will not
+break symlinks when .config is a symlink to somewhere else.
 
-Available themes are:
-  mono       => selects colors suitable for monochrome displays
-  blackbg    => selects a color scheme with black background
-  classic    => theme with blue background. The classic look
-  bluetitle  => a LCD friendly version of classic. (default)
+KCONFIG_NOTIMESTAMP
+--------------------------------------------------
+If this environment variable exists and is non-null, the timestamp line
+in generated .config files is omitted.
 
 ______________________________________________________________________
-Environment variables in 'menuconfig'
+Environment variables for '{allyes/allmod/allno/rand}config'
 
 KCONFIG_ALLCONFIG
 --------------------------------------------------
@@ -95,8 +73,7 @@ values.
 This enables you to create "miniature" config (miniconfig) or custom
 config files containing just the config symbols that you are interested
 in.  Then the kernel config system generates the full .config file,
-including dependencies of your miniconfig file, based on the miniconfig
-file.
+including symbols of your miniconfig file.
 
 This 'KCONFIG_ALLCONFIG' file is a config file which contains
 (usually a subset of all) preset config symbols.  These variable
@@ -113,26 +90,14 @@ These examples will disable most options
 disable the options that are explicitly listed in the specified
 mini-config files.
 
+______________________________________________________________________
+Environment variables for 'silentoldconfig'
+
 KCONFIG_NOSILENTUPDATE
 --------------------------------------------------
 If this variable has a non-blank value, it prevents silent kernel
 config udpates (requires explicit updates).
 
-KCONFIG_CONFIG
---------------------------------------------------
-This environment variable can be used to specify a default kernel config
-file name to override the default name of ".config".
-
-KCONFIG_OVERWRITECONFIG
---------------------------------------------------
-If you set KCONFIG_OVERWRITECONFIG in the environment, Kconfig will not
-break symlinks when .config is a symlink to somewhere else.
-
-KCONFIG_NOTIMESTAMP
---------------------------------------------------
-If this environment variable exists and is non-null, the timestamp line
-in generated .config files is omitted.
-
 KCONFIG_AUTOCONFIG
 --------------------------------------------------
 This environment variable can be set to specify the path & name of the
@@ -143,15 +108,54 @@ KCONFIG_AUTOHEADER
 This environment variable can be set to specify the path & name of the
 "autoconf.h" (header) file.  Its default value is "include/linux/autoconf.h".
 
+
+======================================================================
+menuconfig
+--------------------------------------------------
+
+SEARCHING for CONFIG symbols
+
+Searching in menuconfig:
+
+	The Search function searches for kernel configuration symbol
+	names, so you have to know something close to what you are
+	looking for.
+
+	Example:
+		/hotplug
+		This lists all config symbols that contain "hotplug",
+		e.g., HOTPLUG, HOTPLUG_CPU, MEMORY_HOTPLUG.
+
+	For search help, enter / followed TAB-TAB-TAB (to highlight
+	<Help>) and Enter.  This will tell you that you can also use
+	regular expressions (regexes) in the search string, so if you
+	are not interested in MEMORY_HOTPLUG, you could try
+
+		/^hotplug
+
 ______________________________________________________________________
-menuconfig User Interface Options
-----------------------------------------------------------------------
+User interface options for 'menuconfig'
+
+MENUCONFIG_COLOR
+--------------------------------------------------
+It is possible to select different color themes using the variable
+MENUCONFIG_COLOR.  To select a theme use:
+
+	make MENUCONFIG_COLOR=<theme> menuconfig
+
+Available themes are:
+  mono       => selects colors suitable for monochrome displays
+  blackbg    => selects a color scheme with black background
+  classic    => theme with blue background. The classic look
+  bluetitle  => a LCD friendly version of classic. (default)
+
 MENUCONFIG_MODE
 --------------------------------------------------
 This mode shows all sub-menus in one large tree.
 
 Example:
-	MENUCONFIG_MODE=single_menu make menuconfig
+	make MENUCONFIG_MODE=single_menu menuconfig
+
 
 ======================================================================
 xconfig
_

Patches currently in -mm which might be from markus.heidelberg@web.de are

kconfig-fix-typo-mconfig-to-menuconfig-in-a-comment.patch
kconfig-add-a-note-about-the-deps-to-the-silentoldconfig-help.patch
kconfig-resort-the-documentation-of-the-environment-variables.patch
gitignore-ignore-kconfig-i18n-files.patch
kconfig-qconf-fix-wall-compiler-warnings.patch
kconfig-qconf-fix-namespace-for-horizontal-and-vertical-enum-values.patch
kconfig-qconf-add-namespace-for-use-of-key_-enum-values.patch
kconfig-qconf-fix-the-type-of-the-desktop-widget.patch
kconfig-do-not-hardcode-config-filename.patch
kconfig-do-not-hardcode-include-config-autoconf-filename.patch

