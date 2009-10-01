From: akpm@linux-foundation.org
Subject: [failures] dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patch removed from -mm tree
Date: Thu, 01 Oct 2009 14:35:08 -0700
Message-ID: <200910012157.n91Lvjoo012448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753344AbZJAV55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2009 17:57:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, greg@kroah.com, jbaron@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dynamic_debug.h/kernel.h: Remove KBUILD_MODNAME from dynamic_pr_de=
bug
has been removed from the -mm tree.  Its filename was
     dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug=
=2Epatch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: dynamic_debug.h/kernel.h: Remove KBUILD_MODNAME from dynamic_p=
r_debug
=46rom: Joe Perches <joe@perches.com>

If CONFIG_DYNAMIC_DEBUG is enabled and a source file has:

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
#include <linux/kernel.h>

dynamic_debug.h will duplicate KBUILD_MODNAME in the output string.

Remove the use of KBUILD_MODNAME from the output format string generate=
d
by dynamic_debug.h

If CONFIG_DYNAMIC_DEBUG is not enabled, no compile-time check is done t=
o
printk/dev_printk arguments.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dynamic_debug.h |   12 ++++++------
 include/linux/kernel.h        |    6 ++----
 2 files changed, 8 insertions(+), 10 deletions(-)

diff -puN include/linux/dynamic_debug.h~dynamic_debugh-kernelh-remove-k=
build_modname-from-dynamic_pr_debug include/linux/dynamic_debug.h
--- a/include/linux/dynamic_debug.h~dynamic_debugh-kernelh-remove-kbuil=
d_modname-from-dynamic_pr_debug
+++ a/include/linux/dynamic_debug.h
@@ -57,8 +57,7 @@ extern int ddebug_remove_module(char *mo
 	{ KBUILD_MODNAME, __func__, __FILE__, fmt, DEBUG_HASH,	\
 		DEBUG_HASH2, __LINE__, _DPRINTK_FLAGS_DEFAULT };	\
 	if (__dynamic_dbg_enabled(descriptor))				\
-		printk(KERN_DEBUG KBUILD_MODNAME ":" pr_fmt(fmt),	\
-				##__VA_ARGS__);				\
+		printk(KERN_DEBUG fmt,	##__VA_ARGS__);			\
 	} while (0)
=20
=20
@@ -70,8 +69,7 @@ extern int ddebug_remove_module(char *mo
 		DEBUG_HASH2, __LINE__, _DPRINTK_FLAGS_DEFAULT };	\
 	if (__dynamic_dbg_enabled(descriptor))				\
 			dev_printk(KERN_DEBUG, dev,			\
-					KBUILD_MODNAME ": " fmt,	\
-					##__VA_ARGS__);			\
+				   fmt,	 ##__VA_ARGS__);		\
 	} while (0)
=20
 #else
@@ -81,8 +79,10 @@ static inline int ddebug_remove_module(c
 	return 0;
 }
=20
-#define dynamic_pr_debug(fmt, ...)  do { } while (0)
-#define dynamic_dev_dbg(dev, format, ...)  do { } while (0)
+#define dynamic_pr_debug(fmt, ...)					\
+	do { if (0) printk(KERN_DEBUG fmt, ##__VA_ARGS__); } while (0)
+#define dynamic_dev_dbg(dev, format, ...)				\
+	do { if (0) dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__); } while =
(0)
 #endif
=20
 #endif
diff -puN include/linux/kernel.h~dynamic_debugh-kernelh-remove-kbuild_m=
odname-from-dynamic_pr_debug include/linux/kernel.h
--- a/include/linux/kernel.h~dynamic_debugh-kernelh-remove-kbuild_modna=
me-from-dynamic_pr_debug
+++ a/include/linux/kernel.h
@@ -397,10 +397,8 @@ static inline char *pack_hex_byte(char *
 #define pr_debug(fmt, ...) \
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #elif defined(CONFIG_DYNAMIC_DEBUG)
-/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it her=
e */
-#define pr_debug(fmt, ...) do { \
-	dynamic_pr_debug(fmt, ##__VA_ARGS__); \
-	} while (0)
+#define pr_debug(fmt, ...) \
+	dynamic_pr_debug(pr_fmt(fmt), ##__VA_ARGS__)
 #else
 #define pr_debug(fmt, ...) \
 	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-arm-palm-file-patterns.patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patc=
h
maintainers-update-generic-uio-for-pci-devices.patch
maintainers-update-tracing-section.patch
maintainers-update-omap-tony-lindgren-email-name.patch
maintainers-change-atm-mailing-list-to-moderated.patch
maintainers-use-tab-not-spaces-after-field-types.patch
maintainers-update-kernel-janitors-after-mismerge.patch
maintainers-update-score-architecture-name-style-and-add-file-pattern.p=
atch
maintainers-simple-firmware-interface-update-email-style.patch
maintainers-winbond-cir-integrate-p-m-lines-fixup-david-h=E4rdemans-nam=
e.patch
maintainers-fix-up-peripheral-spelling.patch
maintainers-update-wolfson-microelectronics.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
