From: akpm@linux-foundation.org
Subject: [merged] edac-add-more-verbose-debug-info.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:36:38 -0700
Message-ID: <200904061936.n36JacMx012555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754915AbZDFTjE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:39:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: h.mitake@gmail.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: add more verbose debug info
has been removed from the -mm tree.  Its filename was
     edac-add-more-verbose-debug-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: add more verbose debug info
From: Hitoshi Mitake <h.mitake@gmail.com>

A patch for making a debugging information more verbose for use in
development debugging.

By enabling the new option "More verbose debugging", information about
source file and line number will be added to debugging message.

This is sample output,

EDAC MC0: Giving out device to 'e7xxx_edac' 'E7205': DEV 0000:00:00.0
EDAC DEBUG: in drivers/edac/edac_pci.c, line at 48: edac_pci_alloc_ctl_info()
EDAC DEBUG: in drivers/edac/edac_pci.c, line at 334: edac_pci_add_device()
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig     |    8 ++++++++
 drivers/edac/edac_core.h |   15 ++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff -puN drivers/edac/Kconfig~edac-add-more-verbose-debug-info drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~edac-add-more-verbose-debug-info
+++ a/drivers/edac/Kconfig
@@ -40,6 +40,14 @@ config EDAC_DEBUG
 	  there're four debug levels (x=0,1,2,3 from low to high).
 	  Usually you should select 'N'.
 
+config EDAC_DEBUG_VERBOSE
+	bool "More verbose debugging"
+	depends on EDAC_DEBUG
+	help
+	  This option makes debugging information more verbose.
+	  Source file name and line number where debugging message
+	  printed will be added to debugging message.
+
 config EDAC_MM_EDAC
 	tristate "Main Memory EDAC (Error Detection And Correction) reporting"
 	default y
diff -puN drivers/edac/edac_core.h~edac-add-more-verbose-debug-info drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~edac-add-more-verbose-debug-info
+++ a/drivers/edac/edac_core.h
@@ -49,6 +49,10 @@
 #define edac_printk(level, prefix, fmt, arg...) \
 	printk(level "EDAC " prefix ": " fmt, ##arg)
 
+#define edac_printk_verbose(level, prefix, fmt, arg...) \
+	printk(level "EDAC " prefix ": " "in %s, line at %d: " fmt,	\
+	       __FILE__, __LINE__, ##arg)
+
 #define edac_mc_printk(mci, level, fmt, arg...) \
 	printk(level "EDAC MC%d: " fmt, mci->mc_idx, ##arg)
 
@@ -71,11 +75,20 @@
 #ifdef CONFIG_EDAC_DEBUG
 extern int edac_debug_level;
 
+#ifndef CONFIG_EDAC_DEBUG_VERBOSE
 #define edac_debug_printk(level, fmt, arg...)                            \
 	do {                                                             \
 		if (level <= edac_debug_level)                           \
 			edac_printk(KERN_DEBUG, EDAC_DEBUG, fmt, ##arg); \
-	} while(0)
+	} while (0)
+#else  /* CONFIG_EDAC_DEBUG_VERBOSE */
+#define edac_debug_printk(level, fmt, arg...)                            \
+	do {                                                             \
+		if (level <= edac_debug_level)                           \
+			edac_printk_verbose(KERN_DEBUG, EDAC_DEBUG, fmt, \
+					    ##arg);			\
+	} while (0)
+#endif
 
 #define debugf0( ... ) edac_debug_printk(0, __VA_ARGS__ )
 #define debugf1( ... ) edac_debug_printk(1, __VA_ARGS__ )
_

Patches currently in -mm which might be from h.mitake@gmail.com are

origin.patch

