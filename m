From: akpm@linux-foundation.org
Subject: + sections-fix-section-conflicts-in-net-can.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:37:52 -0700
Message-ID: <20120913233752.89430100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:40019 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759061Ab2IMXhx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:37:53 -0400
Received: by ggnu1 with SMTP id u1so389061ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:37:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, davem@davemloft.net, socketcan@hartkopp.net


The patch titled
     Subject: sections: fix section conflicts in net/can
has been added to the -mm tree.  Its filename is
     sections-fix-section-conflicts-in-net-can.patch

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
Subject: sections: fix section conflicts in net/can

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/can/af_can.c |    2 +-
 net/can/bcm.c    |    2 +-
 net/can/gw.c     |    2 +-
 net/can/raw.c    |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN net/can/af_can.c~sections-fix-section-conflicts-in-net-can net/can/af_can.c
--- a/net/can/af_can.c~sections-fix-section-conflicts-in-net-can
+++ a/net/can/af_can.c
@@ -63,7 +63,7 @@
 
 #include "af_can.h"
 
-static __initdata const char banner[] = KERN_INFO
+static __initconst const char banner[] = KERN_INFO
 	"can: controller area network core (" CAN_VERSION_STRING ")\n";
 
 MODULE_DESCRIPTION("Controller Area Network PF_CAN core");
diff -puN net/can/bcm.c~sections-fix-section-conflicts-in-net-can net/can/bcm.c
--- a/net/can/bcm.c~sections-fix-section-conflicts-in-net-can
+++ a/net/can/bcm.c
@@ -77,7 +77,7 @@
 		     (CAN_SFF_MASK | CAN_EFF_FLAG | CAN_RTR_FLAG))
 
 #define CAN_BCM_VERSION CAN_VERSION
-static __initdata const char banner[] = KERN_INFO
+static __initconst const char banner[] = KERN_INFO
 	"can: broadcast manager protocol (rev " CAN_BCM_VERSION " t)\n";
 
 MODULE_DESCRIPTION("PF_CAN broadcast manager protocol");
diff -puN net/can/gw.c~sections-fix-section-conflicts-in-net-can net/can/gw.c
--- a/net/can/gw.c~sections-fix-section-conflicts-in-net-can
+++ a/net/can/gw.c
@@ -58,7 +58,7 @@
 #include <net/sock.h>
 
 #define CAN_GW_VERSION "20101209"
-static __initdata const char banner[] =
+static __initconst const char banner[] =
 	KERN_INFO "can: netlink gateway (rev " CAN_GW_VERSION ")\n";
 
 MODULE_DESCRIPTION("PF_CAN netlink gateway");
diff -puN net/can/raw.c~sections-fix-section-conflicts-in-net-can net/can/raw.c
--- a/net/can/raw.c~sections-fix-section-conflicts-in-net-can
+++ a/net/can/raw.c
@@ -55,7 +55,7 @@
 #include <net/net_namespace.h>
 
 #define CAN_RAW_VERSION CAN_VERSION
-static __initdata const char banner[] =
+static __initconst const char banner[] =
 	KERN_INFO "can: raw protocol (rev " CAN_RAW_VERSION ")\n";
 
 MODULE_DESCRIPTION("PF_CAN raw protocol");
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

