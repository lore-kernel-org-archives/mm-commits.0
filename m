From: akpm@linux-foundation.org
Subject: [merged]
 make-runtime_tests-a-menuconfig-to-ease-disabling-it-all.patch removed from
 -mm tree
Date: Wed, 07 Feb 2018 11:57:19 -0800
Message-ID: <20180207195719.Y1TWBmXHG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59596 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754422AbeBGT5V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:57:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: byungchul.park@lge.com, geert@linux-m68k.org, jpoimboe@redhat.com, mcgrof@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, npiggin@gmail.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rdunlap@infradead.org, tglx@linutronix.de, vincent.legoll@gmail.com


The patch titled
     Subject: lib/: make RUNTIME_TESTS a menuconfig to ease disabling it all
has been removed from the -mm tree.  Its filename was
     make-runtime_tests-a-menuconfig-to-ease-disabling-it-all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vincent Legoll <vincent.legoll@gmail.com>
Subject: lib/: make RUNTIME_TESTS a menuconfig to ease disabling it all

No need to get into the submenu to disable all related
config entries.

This makes it easier to disable all RUNTIME_TESTS config options
without entering the submenu. It will also enable one to see that
en/dis-abled state from the outside menu.

This is only intended to change menuconfig UI, not change
the config dependencies.

Link: http://lkml.kernel.org/r/20171209162742.7363-1-vincent.legoll@gmail.com
Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Byungchul Park <byungchul.park@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN lib/Kconfig.debug~make-runtime_tests-a-menuconfig-to-ease-disabling-it-all lib/Kconfig.debug
--- a/lib/Kconfig.debug~make-runtime_tests-a-menuconfig-to-ease-disabling-it-all
+++ a/lib/Kconfig.debug
@@ -1641,7 +1641,10 @@ config DMA_API_DEBUG
 
 	  If unsure, say N.
 
-menu "Runtime Testing"
+menuconfig RUNTIME_TESTING_MENU
+	bool "Runtime Testing"
+
+if RUNTIME_TESTING_MENU
 
 config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
@@ -1929,7 +1932,7 @@ config TEST_DEBUG_VIRTUAL
 
 	  If unsure, say N.
 
-endmenu # runtime tests
+endif # RUNTIME_TESTING_MENU
 
 config MEMTEST
 	bool "Memtest"
_

Patches currently in -mm which might be from vincent.legoll@gmail.com are


