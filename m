From: akpm@linux-foundation.org
Subject: + prohibit-rcutorture-from-being-compiled-into-the-kernel.patch added to -mm tree
Date: Thu, 17 May 2007 11:35:03 -0700
Message-ID: <200705171835.l4HIZ3hf030109@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755399AbXEQSip (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 14:38:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, josh@kernel.org, rdunlap@xenotime.net


The patch titled
     prohibit rcutorture from being compiled into the kernel
has been added to the -mm tree.  Its filename is
     prohibit-rcutorture-from-being-compiled-into-the-kernel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: prohibit rcutorture from being compiled into the kernel
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

There have been a number of instances where people have accidentally compiled
rcutorture into the kernel (CONFIG_RCU_TORTURE_TEST=y), which has never been
useful, and has often resulted in great frustration.  The attached patch
prohibits rcutorture from being compiled into the kernel.  It may be excluded
altogether or compiled as a module.  People wishing to have rcutorture hammer
their machine immediately upon boot are free to hand-edit lib/Kconfig.debug to
remove the "depends on m" line.

Thanks to Randy Dunlap for the trick that makes this work.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Josh Triplett <josh@kernel.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/Kconfig.debug~prohibit-rcutorture-from-being-compiled-into-the-kernel lib/Kconfig.debug
--- a/lib/Kconfig.debug~prohibit-rcutorture-from-being-compiled-into-the-kernel
+++ a/lib/Kconfig.debug
@@ -396,14 +396,13 @@ config FORCED_INLINING
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
+	depends on m
 	default n
 	help
 	  This option provides a kernel module that runs torture tests
 	  on the RCU infrastructure.  The kernel module may be built
 	  after the fact on the running kernel to be tested, if desired.
 
-	  Say Y here if you want RCU torture tests to start automatically
-	  at boot time (you probably don't).
 	  Say M if you want the RCU torture tests to build as a module.
 	  Say N if you are unsure.
 
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

prohibit-rcutorture-from-being-compiled-into-the-kernel.patch
