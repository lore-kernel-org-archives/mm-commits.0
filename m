From: akpm@linux-foundation.org
Subject: + make-runtime_tests-a-menuconfig-to-ease-disabling-it-all.patch
 added to -mm tree
Date: Tue, 12 Dec 2017 15:16:08 -0800
Message-ID: <5a306338.gF6LcobmXVKQPZ4F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37342 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752690AbdLLXQJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Dec 2017 18:16:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vincent.legoll@gmail.com, byungchul.park@lge.com, geert@linux-m68k.org, jpoimboe@redhat.com, mcgrof@kernel.org, mingo@kernel.org, npiggin@gmail.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rdunlap@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/: make RUNTIME_TESTS a menuconfig to ease disabling it all
has been added to the -mm tree.  Its filename is
     make-runtime_tests-a-menuconfig-to-ease-disabling-it-all.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/make-runtime_tests-a-menuconfig-to-ease-disabling-it-all.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/make-runtime_tests-a-menuconfig-to-ease-disabling-it-all.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1660,7 +1660,10 @@ config DMA_API_DEBUG
 
 	  If unsure, say N.
 
-menu "Runtime Testing"
+menuconfig RUNTIME_TESTING_MENU
+	bool "Runtime Testing"
+
+if RUNTIME_TESTING_MENU
 
 config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
@@ -1948,7 +1951,7 @@ config TEST_DEBUG_VIRTUAL
 
 	  If unsure, say N.
 
-endmenu # runtime tests
+endif # RUNTIME_TESTING_MENU
 
 config MEMTEST
 	bool "Memtest"
_

Patches currently in -mm which might be from vincent.legoll@gmail.com are

make-runtime_tests-a-menuconfig-to-ease-disabling-it-all.patch

