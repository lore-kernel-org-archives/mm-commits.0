From: akpm@linux-foundation.org
Subject: [merged]
 kernel-hacking-menu-runtime-testing-keep-tests-together.patch removed from
 -mm tree
Date: Mon, 16 Oct 2017 12:55:13 -0700
Message-ID: <20171016195513.k6CzC74gm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55490 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752199AbdJPTzQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 15:55:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@intel.com, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: lib/Kconfig.debug: kernel hacking menu: runtime testing: keep tests together
has been removed from the -mm tree.  Its filename was
     kernel-hacking-menu-runtime-testing-keep-tests-together.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib/Kconfig.debug: kernel hacking menu: runtime testing: keep tests together

Expand the "Runtime testing" menu by including more entries inside it
instead of after it.  This is just Kconfig symbol movement.

This causes the (arch-independent) Runtime tests to be presented (listed)
all in one place instead of in multiple places.

Link: http://lkml.kernel.org/r/c194e5c4-2042-bf94-a2d8-7aa13756e257@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |  143 +++++++++++++++++++++-----------------------
 1 file changed, 71 insertions(+), 72 deletions(-)

diff -puN lib/Kconfig.debug~kernel-hacking-menu-runtime-testing-keep-tests-together lib/Kconfig.debug
--- a/lib/Kconfig.debug~kernel-hacking-menu-runtime-testing-keep-tests-together
+++ a/lib/Kconfig.debug
@@ -1590,6 +1590,54 @@ config LATENCYTOP
 
 source kernel/trace/Kconfig
 
+config PROVIDE_OHCI1394_DMA_INIT
+	bool "Remote debugging over FireWire early on boot"
+	depends on PCI && X86
+	help
+	  If you want to debug problems which hang or crash the kernel early
+	  on boot and the crashing machine has a FireWire port, you can use
+	  this feature to remotely access the memory of the crashed machine
+	  over FireWire. This employs remote DMA as part of the OHCI1394
+	  specification which is now the standard for FireWire controllers.
+
+	  With remote DMA, you can monitor the printk buffer remotely using
+	  firescope and access all memory below 4GB using fireproxy from gdb.
+	  Even controlling a kernel debugger is possible using remote DMA.
+
+	  Usage:
+
+	  If ohci1394_dma=early is used as boot parameter, it will initialize
+	  all OHCI1394 controllers which are found in the PCI config space.
+
+	  As all changes to the FireWire bus such as enabling and disabling
+	  devices cause a bus reset and thereby disable remote DMA for all
+	  devices, be sure to have the cable plugged and FireWire enabled on
+	  the debugging host before booting the debug target for debugging.
+
+	  This code (~1k) is freed after boot. By then, the firewire stack
+	  in charge of the OHCI-1394 controllers should be used instead.
+
+	  See Documentation/debugging-via-ohci1394.txt for more information.
+
+config DMA_API_DEBUG
+	bool "Enable debugging of DMA-API usage"
+	depends on HAVE_DMA_API_DEBUG
+	help
+	  Enable this option to debug the use of the DMA API by device drivers.
+	  With this option you will be able to detect common bugs in device
+	  drivers like double-freeing of DMA mappings or freeing mappings that
+	  were never allocated.
+
+	  This also attempts to catch cases where a page owned by DMA is
+	  accessed by the cpu in a way that could cause data corruption.  For
+	  example, this enables cow_user_page() to check that the source page is
+	  not undergoing DMA.
+
+	  This option causes a performance degradation.  Use only if you want to
+	  debug device drivers and dma interactions.
+
+	  If unsure, say N.
+
 menu "Runtime Testing"
 
 config LKDTM
@@ -1749,56 +1797,6 @@ config TEST_PARMAN
 
 	  If unsure, say N.
 
-endmenu # runtime tests
-
-config PROVIDE_OHCI1394_DMA_INIT
-	bool "Remote debugging over FireWire early on boot"
-	depends on PCI && X86
-	help
-	  If you want to debug problems which hang or crash the kernel early
-	  on boot and the crashing machine has a FireWire port, you can use
-	  this feature to remotely access the memory of the crashed machine
-	  over FireWire. This employs remote DMA as part of the OHCI1394
-	  specification which is now the standard for FireWire controllers.
-
-	  With remote DMA, you can monitor the printk buffer remotely using
-	  firescope and access all memory below 4GB using fireproxy from gdb.
-	  Even controlling a kernel debugger is possible using remote DMA.
-
-	  Usage:
-
-	  If ohci1394_dma=early is used as boot parameter, it will initialize
-	  all OHCI1394 controllers which are found in the PCI config space.
-
-	  As all changes to the FireWire bus such as enabling and disabling
-	  devices cause a bus reset and thereby disable remote DMA for all
-	  devices, be sure to have the cable plugged and FireWire enabled on
-	  the debugging host before booting the debug target for debugging.
-
-	  This code (~1k) is freed after boot. By then, the firewire stack
-	  in charge of the OHCI-1394 controllers should be used instead.
-
-	  See Documentation/debugging-via-ohci1394.txt for more information.
-
-config DMA_API_DEBUG
-	bool "Enable debugging of DMA-API usage"
-	depends on HAVE_DMA_API_DEBUG
-	help
-	  Enable this option to debug the use of the DMA API by device drivers.
-	  With this option you will be able to detect common bugs in device
-	  drivers like double-freeing of DMA mappings or freeing mappings that
-	  were never allocated.
-
-	  This also attempts to catch cases where a page owned by DMA is
-	  accessed by the cpu in a way that could cause data corruption.  For
-	  example, this enables cow_user_page() to check that the source page is
-	  not undergoing DMA.
-
-	  This option causes a performance degradation.  Use only if you want to
-	  debug device drivers and dma interactions.
-
-	  If unsure, say N.
-
 config TEST_LKM
 	tristate "Test module loading with 'hello world' module"
 	default n
@@ -1873,18 +1871,6 @@ config TEST_UDELAY
 
 	  If unsure, say N.
 
-config MEMTEST
-	bool "Memtest"
-	depends on HAVE_MEMBLOCK
-	---help---
-	  This option adds a kernel parameter 'memtest', which allows memtest
-	  to be set.
-	        memtest=0, mean disabled; -- default
-	        memtest=1, mean do 1 test pattern;
-	        ...
-	        memtest=17, mean do 17 test patterns.
-	  If you are unsure how to answer this question, answer N.
-
 config TEST_STATIC_KEYS
 	tristate "Test static keys"
 	default n
@@ -1894,16 +1880,6 @@ config TEST_STATIC_KEYS
 
 	  If unsure, say N.
 
-config BUG_ON_DATA_CORRUPTION
-	bool "Trigger a BUG when data corruption is detected"
-	select DEBUG_LIST
-	help
-	  Select this option if the kernel should BUG when it encounters
-	  data corruption in kernel memory structures when they get checked
-	  for validity.
-
-	  If unsure, say N.
-
 config TEST_KMOD
 	tristate "kmod stress tester"
 	default n
@@ -1941,6 +1917,29 @@ config TEST_DEBUG_VIRTUAL
 
 	  If unsure, say N.
 
+endmenu # runtime tests
+
+config MEMTEST
+	bool "Memtest"
+	depends on HAVE_MEMBLOCK
+	---help---
+	  This option adds a kernel parameter 'memtest', which allows memtest
+	  to be set.
+	        memtest=0, mean disabled; -- default
+	        memtest=1, mean do 1 test pattern;
+	        ...
+	        memtest=17, mean do 17 test patterns.
+	  If you are unsure how to answer this question, answer N.
+
+config BUG_ON_DATA_CORRUPTION
+	bool "Trigger a BUG when data corruption is detected"
+	select DEBUG_LIST
+	help
+	  Select this option if the kernel should BUG when it encounters
+	  data corruption in kernel memory structures when they get checked
+	  for validity.
+
+	  If unsure, say N.
 
 source "samples/Kconfig"
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are


