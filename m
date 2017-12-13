From: akpm@linux-foundation.org
Subject: [to-be-updated]
 make-memory-debugging-a-menuconfig-to-ease-disabling-it-all.patch removed
 from -mm tree
Date: Wed, 13 Dec 2017 15:51:38 -0800
Message-ID: <5a31bd0a.yuzSseqEl5MSVRxn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55400 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750751AbdLMXvk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Dec 2017 18:51:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vincent.legoll@gmail.com, byungchul.park@lge.com, geert@linux-m68k.org, jpoimboe@redhat.com, mcgrof@kernel.org, mingo@kernel.org, npiggin@gmail.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rdunlap@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/: make "Memory Debugging" a menuconfig to ease disabling it all
has been removed from the -mm tree.  Its filename was
     make-memory-debugging-a-menuconfig-to-ease-disabling-it-all.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vincent Legoll <vincent.legoll@gmail.com>
Subject: lib/: make "Memory Debugging" a menuconfig to ease disabling it all

No need to get into the submenu to disable all "Memory Debugging"-related
config entries.

This makes it easier to disable all "Memory Debugging" config options
without entering the submenu.  It will also enable one to see that
en/dis-abled state from the outside menu.

This is only intended to change menuconfig UI, not change the config
dependencies.

Link: http://lkml.kernel.org/r/20171209174033.9425-2-vincent.legoll@gmail.com
Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Byungchul Park <byungchul.park@lge.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |   28 +++++++++++++++++-----------
 lib/Kconfig.kasan |    3 ---
 2 files changed, 17 insertions(+), 14 deletions(-)

diff -puN lib/Kconfig.debug~make-memory-debugging-a-menuconfig-to-ease-disabling-it-all lib/Kconfig.debug
--- a/lib/Kconfig.debug~make-memory-debugging-a-menuconfig-to-ease-disabling-it-all
+++ a/lib/Kconfig.debug
@@ -436,7 +436,10 @@ config DEBUG_KERNEL
 	  Say Y here if you are developing drivers or trying to debug and
 	  identify kernel problems.
 
-menu "Memory Debugging"
+menuconfig DEBUG_MEMORY
+	bool "Memory Debugging"
+
+if DEBUG_MEMORY
 
 source mm/Kconfig.debug
 
@@ -539,9 +542,6 @@ config SLUB_STATS
 	  out which slabs are relevant to a particular load.
 	  Try running: slabinfo -DA
 
-config HAVE_DEBUG_KMEMLEAK
-	bool
-
 config DEBUG_KMEMLEAK
 	bool "Kernel memory leak detector"
 	depends on DEBUG_KERNEL && HAVE_DEBUG_KMEMLEAK
@@ -636,9 +636,6 @@ config DEBUG_VM_PGFLAGS
 
 	  If unsure, say N.
 
-config ARCH_HAS_DEBUG_VIRTUAL
-	bool
-
 config DEBUG_VIRTUAL
 	bool "Debug VM translations"
 	depends on DEBUG_KERNEL && ARCH_HAS_DEBUG_VIRTUAL
@@ -708,9 +705,6 @@ config DEBUG_HIGHMEM
 	  This option enables additional error checking for high memory
 	  systems.  Disable for production systems.
 
-config HAVE_DEBUG_STACKOVERFLOW
-	bool
-
 config DEBUG_STACKOVERFLOW
 	bool "Check for stack overflows"
 	depends on DEBUG_KERNEL && HAVE_DEBUG_STACKOVERFLOW
@@ -731,7 +725,19 @@ config DEBUG_STACKOVERFLOW
 
 source "lib/Kconfig.kasan"
 
-endmenu # "Memory Debugging"
+endif # DEBUG_MEMORY
+
+config HAVE_ARCH_KASAN
+	bool
+
+config ARCH_HAS_DEBUG_VIRTUAL
+	bool
+
+config HAVE_DEBUG_KMEMLEAK
+	bool
+
+config HAVE_DEBUG_STACKOVERFLOW
+	bool
 
 config ARCH_HAS_KCOV
 	bool
diff -puN lib/Kconfig.kasan~make-memory-debugging-a-menuconfig-to-ease-disabling-it-all lib/Kconfig.kasan
--- a/lib/Kconfig.kasan~make-memory-debugging-a-menuconfig-to-ease-disabling-it-all
+++ a/lib/Kconfig.kasan
@@ -1,6 +1,3 @@
-config HAVE_ARCH_KASAN
-	bool
