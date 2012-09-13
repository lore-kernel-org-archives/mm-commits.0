From: akpm@linux-foundation.org
Subject: + sections-fix-section-conflicts-in-arch-powerpc.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:36:53 -0700
Message-ID: <20120913233654.34FDA1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:33886 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759090Ab2IMXg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:36:56 -0400
Received: by yenq6 with SMTP id q6so389740yen.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:36:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, benh@kernel.crashing.org


The patch titled
     Subject: sections: fix section conflicts in arch/powerpc
has been added to the -mm tree.  Its filename is
     sections-fix-section-conflicts-in-arch-powerpc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -108,7 +108,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_T
 
 machine_arch_initcall(tqm85xx, mpc85xx_common_publish_devices);
 
-static const char *board[] __initdata = {
+static const char * const board[] __initconst = {
 	"tqc,tqm8540",
 	"tqc,tqm8541",
 	"tqc,tqm8548",
_

Patches currently in -mm which might be from ak@linux.intel.com are

compilerh-add-__visible.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
sections-disable-const-sections-for-pa-risc-v2.patch
sections-fix-section-conflicts-in-arch-arm.patch
sections-fix-section-conflicts-in-arch-frv.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-arch-ia64.patch
sections-fix-section-conflicts-in-arch-mips.patch
sections-fix-section-conflicts-in-arch-powerpc.patch
sections-fix-section-conflicts-in-arch-score.patch
sections-fix-section-conflicts-in-arch-sh.patch
sections-fix-section-conflicts-in-arch-x86.patch
sections-fix-section-conflicts-in-drivers-atm.patch
sections-fix-section-conflicts-in-drivers-char.patch
sections-fix-section-conflicts-in-drivers-cpufreq.patch
sections-fix-section-conflicts-in-drivers-ide.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sections-fix-section-conflicts-in-drivers-mfd.patch
sections-fix-section-conflicts-in-drivers-mmc.patch
sections-fix-section-conflicts-in-drivers-net.patch
sections-fix-section-conflicts-in-drivers-net-hamradio.patch
sections-fix-section-conflicts-in-drivers-net-wan.patch
sections-fix-section-conflicts-in-drivers-platform-x86.patch
sections-fix-section-conflicts-in-drivers-scsi.patch
sections-fix-section-conflicts-in-drivers-video.patch
sections-fix-section-conflicts-in-mm-percpuc.patch
sections-fix-section-conflicts-in-net-can.patch
sections-fix-section-conflicts-in-net.patch
sections-fix-section-conflicts-in-sound.patch
sectons-fix-const-sections-for-crc32-table.patch
compat_ioctl-remove-unused-local-typedef.patch

