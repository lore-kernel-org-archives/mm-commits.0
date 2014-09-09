From: akpm@linux-foundation.org
Subject: [alternative-merged]
 init-kconfig-move-rcu_nocb_cpu-dependencies-to-choice.patch removed from
 -mm tree
Date: Tue, 09 Sep 2014 12:18:01 -0700
Message-ID: <540f5269.Msx6feKv+5kCe8iV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbaIITSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Sep 2014 15:18:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefan.hengelein@fau.de, josh@joshtriplett.org, rupran@einserver.de, mm-commits@vger.kernel.org


The patch titled
     Subject: init/Kconfig: move RCU_NOCB_CPU dependencies to choice
has been removed from the -mm tree.  Its filename was
     init-kconfig-move-rcu_nocb_cpu-dependencies-to-choice.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Stefan Hengelein <stefan.hengelein@fau.de>
Subject: init/Kconfig: move RCU_NOCB_CPU dependencies to choice

Every choice item of the "Build-forced no-CBs CPUs" choice had a
dependency to RCU_NOCB_CPU.  It's more comprehensible if the choice itself
has the dependency instead of every choice item.  The choice itself
doesn't need to be visible if there are no items selectable (i.e.  on
arch/frv) or RCU_NOCB_CPU is not defined.

Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>
Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN init/Kconfig~init-kconfig-move-rcu_nocb_cpu-dependencies-to-choice init/Kconfig
--- a/init/Kconfig~init-kconfig-move-rcu_nocb_cpu-dependencies-to-choice
+++ a/init/Kconfig
@@ -729,6 +729,7 @@ config RCU_NOCB_CPU
 choice
 	prompt "Build-forced no-CBs CPUs"
 	default RCU_NOCB_CPU_NONE
+	depends on RCU_NOCB_CPU
 	help
 	  This option allows no-CBs CPUs (whose RCU callbacks are invoked
 	  from kthreads rather than from softirq context) to be specified
@@ -737,7 +738,7 @@ choice
 
 config RCU_NOCB_CPU_NONE
 	bool "No build_forced no-CBs CPUs"
-	depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
+	depends on !NO_HZ_FULL_ALL
 	help
 	  This option does not force any of the CPUs to be no-CBs CPUs.
 	  Only CPUs designated by the rcu_nocbs= boot parameter will be
@@ -751,7 +752,7 @@ config RCU_NOCB_CPU_NONE
 
 config RCU_NOCB_CPU_ZERO
 	bool "CPU 0 is a build_forced no-CBs CPU"
-	depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
+	depends on !NO_HZ_FULL_ALL
 	help
 	  This option forces CPU 0 to be a no-CBs CPU, so that its RCU
 	  callbacks are invoked by a per-CPU kthread whose name begins
@@ -766,7 +767,6 @@ config RCU_NOCB_CPU_ZERO
 
 config RCU_NOCB_CPU_ALL
 	bool "All CPUs are build_forced no-CBs CPUs"
-	depends on RCU_NOCB_CPU
 	help
 	  This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
 	  boot parameter will be ignored.  All CPUs' RCU callbacks will
_

Patches currently in -mm which might be from stefan.hengelein@fau.de are

linux-next.patch

