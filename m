From: akpm@linux-foundation.org
Subject: [folded-merged] watchdog-split-up-config-options-fix.patch
 removed from -mm tree
Date: Wed, 12 Jul 2017 14:18:31 -0700
Message-ID: <59669227.p/6VXJUEiFDbyDeR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52560 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGLVSc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:18:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog-split-up-config-options-fix
has been removed from the -mm tree.  Its filename was
     watchdog-split-up-config-options-fix.patch

This patch was dropped because it was folded into watchdog-split-up-config-options.patch

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: watchdog-split-up-config-options-fix

Link: http://lkml.kernel.org/r/20170617223522.66c0ad88@roar.ozlabs.ibm.com

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/Kconfig~watchdog-split-up-config-options-fix arch/Kconfig
--- a/arch/Kconfig~watchdog-split-up-config-options-fix
+++ a/arch/Kconfig
@@ -198,9 +198,6 @@ config HAVE_KPROBES_ON_FTRACE
 config HAVE_NMI
 	bool
 
-config HAVE_NMI_WATCHDOG
-	depends on HAVE_NMI
-	bool
 #
 # An arch should select this if it provides all these things:
 #
@@ -288,7 +285,6 @@ config HAVE_PERF_EVENTS_NMI
 	  subsystem.  Also has support for calculating CPU cycle events
 	  to determine how many clock cycles in a given period.
 
-
 config HAVE_HARDLOCKUP_DETECTOR_PERF
 	bool
 	depends on HAVE_PERF_EVENTS_NMI
@@ -297,6 +293,7 @@ config HAVE_HARDLOCKUP_DETECTOR_PERF
 	  detector. Must define HAVE_PERF_EVENTS_NMI.
 
 config HAVE_NMI_WATCHDOG
+	depends on HAVE_NMI
 	bool
 	help
 	  The arch provides a low level NMI watchdog. It provides
@@ -310,7 +307,6 @@ config HAVE_HARDLOCKUP_DETECTOR_ARCH
 	  a superset of the HAVE_NMI_WATCHDOG. It also conforms to config
 	  interfaces and parameters provided by hardlockup detector subsystem.
 
