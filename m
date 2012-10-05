From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-net-can.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:13:31 -0700
Message-ID: <20121005201331.AA5CB100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:42422 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800Ab2JEUNc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:13:32 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so93671qae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:13:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, davem@davemloft.net, socketcan@hartkopp.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in net/can
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-net-can.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

