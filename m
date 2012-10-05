From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-arch-powerpc.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:12:28 -0700
Message-ID: <20121005201229.135E75C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:40290 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263Ab2JEUMb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:12:31 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so138880bkw.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:12:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in arch/powerpc
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-arch-powerpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in arch/powerpc

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/40x/ppc40x_simple.c    |    2 +-
 arch/powerpc/platforms/512x/mpc5121_generic.c |    2 +-
 arch/powerpc/platforms/52xx/lite5200.c        |    2 +-
 arch/powerpc/platforms/52xx/media5200.c       |    2 +-
 arch/powerpc/platforms/83xx/mpc837x_rdb.c     |    2 +-
 arch/powerpc/platforms/85xx/tqm85xx.c         |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/platforms/40x/ppc40x_simple.c~sections-fix-section-conflicts-in-arch-powerpc arch/powerpc/platforms/40x/ppc40x_simple.c
--- a/arch/powerpc/platforms/40x/ppc40x_simple.c~sections-fix-section-conflicts-in-arch-powerpc
+++ a/arch/powerpc/platforms/40x/ppc40x_simple.c
@@ -50,7 +50,7 @@ machine_device_initcall(ppc40x_simple, p
  * Again, if your board needs to do things differently then create a
  * board.c file for it rather than adding it to this list.
  */
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"amcc,acadia",
 	"amcc,haleakala",
 	"amcc,kilauea",
diff -puN arch/powerpc/platforms/512x/mpc5121_generic.c~sections-fix-section-conflicts-in-arch-powerpc arch/powerpc/platforms/512x/mpc5121_generic.c
--- a/arch/powerpc/platforms/512x/mpc5121_generic.c~sections-fix-section-conflicts-in-arch-powerpc
+++ a/arch/powerpc/platforms/512x/mpc5121_generic.c
@@ -26,7 +26,7 @@
 /*
  * list of supported boards
  */
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"prt,prtlvt",
 	NULL
 };
diff -puN arch/powerpc/platforms/52xx/lite5200.c~sections-fix-section-conflicts-in-arch-powerpc arch/powerpc/platforms/52xx/lite5200.c
--- a/arch/powerpc/platforms/52xx/lite5200.c~sections-fix-section-conflicts-in-arch-powerpc
+++ a/arch/powerpc/platforms/52xx/lite5200.c
@@ -172,7 +172,7 @@ static void __init lite5200_setup_arch(v
 	mpc52xx_setup_pci();
 }
 
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"fsl,lite5200",
 	"fsl,lite5200b",
 	NULL,
diff -puN arch/powerpc/platforms/52xx/media5200.c~sections-fix-section-conflicts-in-arch-powerpc arch/powerpc/platforms/52xx/media5200.c
--- a/arch/powerpc/platforms/52xx/media5200.c~sections-fix-section-conflicts-in-arch-powerpc
+++ a/arch/powerpc/platforms/52xx/media5200.c
@@ -232,7 +232,7 @@ static void __init media5200_setup_arch(
 }
 
 /* list of the supported boards */
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"fsl,media5200",
 	NULL
 };
diff -puN arch/powerpc/platforms/83xx/mpc837x_rdb.c~sections-fix-section-conflicts-in-arch-powerpc arch/powerpc/platforms/83xx/mpc837x_rdb.c
--- a/arch/powerpc/platforms/83xx/mpc837x_rdb.c~sections-fix-section-conflicts-in-arch-powerpc
+++ a/arch/powerpc/platforms/83xx/mpc837x_rdb.c
@@ -60,7 +60,7 @@ static void __init mpc837x_rdb_setup_arc
 
 machine_device_initcall(mpc837x_rdb, mpc83xx_declare_of_platform_devices);
 
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"fsl,mpc8377rdb",
 	"fsl,mpc8378rdb",
 	"fsl,mpc8379rdb",
diff -puN arch/powerpc/platforms/85xx/tqm85xx.c~sections-fix-section-conflicts-in-arch-powerpc arch/powerpc/platforms/85xx/tqm85xx.c
--- a/arch/powerpc/platforms/85xx/tqm85xx.c~sections-fix-section-conflicts-in-arch-powerpc
+++ a/arch/powerpc/platforms/85xx/tqm85xx.c
@@ -125,7 +125,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_T
 
 machine_device_initcall(tqm85xx, mpc85xx_common_publish_devices);
 
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"tqc,tqm8540",
 	"tqc,tqm8541",
 	"tqc,tqm8548",
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

