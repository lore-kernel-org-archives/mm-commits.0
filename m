From: akpm@osdl.org
Subject: - fix-hwrng-built-in-initcalls-priority.patch removed from -mm tree
Date: Fri, 12 Jan 2007 14:18:17 -0800
Message-ID: <200701122218.l0CMIHjO030781@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39104 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161143AbXALWSi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 17:18:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, greg@kroah.com, jbeulich@novell.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     Fix HWRNG built-in initcalls priority
has been removed from the -mm tree.  Its filename was
     fix-hwrng-built-in-initcalls-priority.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix HWRNG built-in initcalls priority
From: Michael Buesch <mb@bu3sch.de>

This changes all HWRNG driver initcalls to module_init().  We must probe
the RNGs after the major kernel subsystems are already up and running (like
PCI).

This fixes Bug 7730.
http://bugzilla.kernel.org/show_bug.cgi?id=7730

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/hw_random/amd-rng.c    |    2 +-
 drivers/char/hw_random/geode-rng.c  |    2 +-
 drivers/char/hw_random/intel-rng.c  |    2 +-
 drivers/char/hw_random/ixp4xx-rng.c |    2 +-
 drivers/char/hw_random/via-rng.c    |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/char/hw_random/amd-rng.c~fix-hwrng-built-in-initcalls-priority drivers/char/hw_random/amd-rng.c
--- a/drivers/char/hw_random/amd-rng.c~fix-hwrng-built-in-initcalls-priority
+++ a/drivers/char/hw_random/amd-rng.c
@@ -144,7 +144,7 @@ static void __exit mod_exit(void)
 	hwrng_unregister(&amd_rng);
 }
 
-subsys_initcall(mod_init);
+module_init(mod_init);
 module_exit(mod_exit);
 
 MODULE_AUTHOR("The Linux Kernel team");
diff -puN drivers/char/hw_random/geode-rng.c~fix-hwrng-built-in-initcalls-priority drivers/char/hw_random/geode-rng.c
--- a/drivers/char/hw_random/geode-rng.c~fix-hwrng-built-in-initcalls-priority
+++ a/drivers/char/hw_random/geode-rng.c
@@ -125,7 +125,7 @@ static void __exit mod_exit(void)
 	iounmap(mem);
 }
 
-subsys_initcall(mod_init);
+module_init(mod_init);
 module_exit(mod_exit);
 
 MODULE_DESCRIPTION("H/W RNG driver for AMD Geode LX CPUs");
diff -puN drivers/char/hw_random/intel-rng.c~fix-hwrng-built-in-initcalls-priority drivers/char/hw_random/intel-rng.c
--- a/drivers/char/hw_random/intel-rng.c~fix-hwrng-built-in-initcalls-priority
+++ a/drivers/char/hw_random/intel-rng.c
@@ -378,7 +378,7 @@ static void __exit mod_exit(void)
 	iounmap(mem);
 }
 
-subsys_initcall(mod_init);
+module_init(mod_init);
 module_exit(mod_exit);
 
 MODULE_DESCRIPTION("H/W RNG driver for Intel chipsets");
diff -puN drivers/char/hw_random/ixp4xx-rng.c~fix-hwrng-built-in-initcalls-priority drivers/char/hw_random/ixp4xx-rng.c
--- a/drivers/char/hw_random/ixp4xx-rng.c~fix-hwrng-built-in-initcalls-priority
+++ a/drivers/char/hw_random/ixp4xx-rng.c
@@ -64,7 +64,7 @@ static void __exit ixp4xx_rng_exit(void)
 	iounmap(rng_base);
 }
 
-subsys_initcall(ixp4xx_rng_init);
+module_init(ixp4xx_rng_init);
 module_exit(ixp4xx_rng_exit);
 
 MODULE_AUTHOR("Deepak Saxena <dsaxena@plexity.net>");
diff -puN drivers/char/hw_random/via-rng.c~fix-hwrng-built-in-initcalls-priority drivers/char/hw_random/via-rng.c
--- a/drivers/char/hw_random/via-rng.c~fix-hwrng-built-in-initcalls-priority
+++ a/drivers/char/hw_random/via-rng.c
@@ -176,7 +176,7 @@ static void __exit mod_exit(void)
 	hwrng_unregister(&via_rng);
 }
 
-subsys_initcall(mod_init);
+module_init(mod_init);
 module_exit(mod_exit);
 
 MODULE_DESCRIPTION("H/W RNG driver for VIA chipsets");
_

Patches currently in -mm which might be from mb@bu3sch.de are

git-wireless.patch
