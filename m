From: akpm@linux-foundation.org
Subject: - alpha-parisc-removing-config-variable-debug_rwlock.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:22:34 -0800
Message-ID: <200802070022.m170MFEm006410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48335 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761301AbYBGAqg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:46:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olsajiri@gmail.com, grundler@parisc-linux.org, ink@jurassic.park.msu.ru, kyle@mcmartin.ca, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha/parisc: remove config variable DEBUG_RWLOCK
has been removed from the -mm tree.  Its filename was
     alpha-parisc-removing-config-variable-debug_rwlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha/parisc: remove config variable DEBUG_RWLOCK
From: Jiri Olsa <olsajiri@gmail.com>

Remove config variable DEBUG_RWLOCK, since it is not used.

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Acked-by: Grant Grundler <grundler@parisc-linux.org>
Acked-by: Kyle McMartin <kyle@mcmartin.ca>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig.debug           |    9 ---------
 arch/alpha/defconfig               |    1 -
 arch/parisc/Kconfig.debug          |    9 ---------
 arch/parisc/configs/a500_defconfig |    1 -
 4 files changed, 20 deletions(-)

diff -puN arch/alpha/Kconfig.debug~alpha-parisc-removing-config-variable-debug_rwlock arch/alpha/Kconfig.debug
--- a/arch/alpha/Kconfig.debug~alpha-parisc-removing-config-variable-debug_rwlock
+++ a/arch/alpha/Kconfig.debug
@@ -7,15 +7,6 @@ config EARLY_PRINTK
 	depends on ALPHA_GENERIC || ALPHA_SRM
 	default y
 
-config DEBUG_RWLOCK
-	bool "Read-write spinlock debugging"
-	depends on DEBUG_KERNEL
-	help
-	  If you say Y here then read-write lock processing will count how many
-	  times it has tried to get the lock and issue an error message after
-	  too many attempts.  If you suspect a rwlock problem or a kernel
-	  hacker asks for this option then say Y.  Otherwise say N.
-
 config ALPHA_LEGACY_START_ADDRESS
 	bool "Legacy kernel start address"
 	depends on ALPHA_GENERIC
diff -puN arch/alpha/defconfig~alpha-parisc-removing-config-variable-debug_rwlock arch/alpha/defconfig
--- a/arch/alpha/defconfig~alpha-parisc-removing-config-variable-debug_rwlock
+++ a/arch/alpha/defconfig
@@ -882,7 +882,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_SPINLOCK is not set
 CONFIG_DEBUG_INFO=y
 CONFIG_EARLY_PRINTK=y
-# CONFIG_DEBUG_RWLOCK is not set
 # CONFIG_DEBUG_SEMAPHORE is not set
 CONFIG_ALPHA_LEGACY_START_ADDRESS=y
 CONFIG_MATHEMU=y
diff -puN arch/parisc/Kconfig.debug~alpha-parisc-removing-config-variable-debug_rwlock arch/parisc/Kconfig.debug
--- a/arch/parisc/Kconfig.debug~alpha-parisc-removing-config-variable-debug_rwlock
+++ a/arch/parisc/Kconfig.debug
@@ -2,15 +2,6 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config DEBUG_RWLOCK
-        bool "Read-write spinlock debugging"
-        depends on DEBUG_KERNEL && SMP
-        help
-          If you say Y here then read-write lock processing will count how many
-          times it has tried to get the lock and issue an error message after
-          too many attempts.  If you suspect a rwlock problem or a kernel
-          hacker asks for this option then say Y.  Otherwise say N.
-
 config DEBUG_RODATA
        bool "Write protect kernel read-only data structures"
        depends on DEBUG_KERNEL
diff -puN arch/parisc/configs/a500_defconfig~alpha-parisc-removing-config-variable-debug_rwlock arch/parisc/configs/a500_defconfig
--- a/arch/parisc/configs/a500_defconfig~alpha-parisc-removing-config-variable-debug_rwlock
+++ a/arch/parisc/configs/a500_defconfig
@@ -1050,7 +1050,6 @@ CONFIG_SCHED_DEBUG=y
 CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
-# CONFIG_DEBUG_RWLOCK is not set
 # CONFIG_DEBUG_RODATA is not set
 
 #
_

Patches currently in -mm which might be from olsajiri@gmail.com are

origin.patch
