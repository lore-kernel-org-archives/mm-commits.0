From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-drivers-net-hamradio.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:13:09 -0700
Message-ID: <20121005201310.15D1B5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:52293 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2JEUNL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:13:11 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so138307fae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:13:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in drivers/net/hamradio
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-drivers-net-hamradio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in drivers/net/hamradio

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/hamradio/6pack.c    |    2 +-
 drivers/net/hamradio/bpqether.c |    2 +-
 drivers/net/hamradio/mkiss.c    |    6 +++---
 drivers/net/hamradio/scc.c      |    2 +-
 drivers/net/hamradio/yam.c      |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/net/hamradio/6pack.c~sections-fix-section-conflicts-in-drivers-net-hamradio drivers/net/hamradio/6pack.c
--- a/drivers/net/hamradio/6pack.c~sections-fix-section-conflicts-in-drivers-net-hamradio
+++ a/drivers/net/hamradio/6pack.c
@@ -829,7 +829,7 @@ static int __init sixpack_init_driver(vo
 	return status;
 }
 
-static const char msg_unregfail[] __exitdata = KERN_ERR \
+static const char msg_unregfail[] = KERN_ERR \
 	"6pack: can't unregister line discipline (err = %d)\n";
 
 static void __exit sixpack_exit_driver(void)
diff -puN drivers/net/hamradio/bpqether.c~sections-fix-section-conflicts-in-drivers-net-hamradio drivers/net/hamradio/bpqether.c
--- a/drivers/net/hamradio/bpqether.c~sections-fix-section-conflicts-in-drivers-net-hamradio
+++ a/drivers/net/hamradio/bpqether.c
@@ -87,7 +87,7 @@
 
 #include <linux/bpqether.h>
 
-static const char banner[] __initdata = KERN_INFO \
+static const char banner[] __initconst = KERN_INFO \
 	"AX.25: bpqether driver version 004\n";
 
 static char bcast_addr[6]={0xFF,0xFF,0xFF,0xFF,0xFF,0xFF};
diff -puN drivers/net/hamradio/mkiss.c~sections-fix-section-conflicts-in-drivers-net-hamradio drivers/net/hamradio/mkiss.c
--- a/drivers/net/hamradio/mkiss.c~sections-fix-section-conflicts-in-drivers-net-hamradio
+++ a/drivers/net/hamradio/mkiss.c
@@ -997,9 +997,9 @@ static struct tty_ldisc_ops ax_ldisc = {
 	.write_wakeup	= mkiss_write_wakeup
 };
 
-static const char banner[] __initdata = KERN_INFO \
+static const char banner[] __initconst = KERN_INFO \
 	"mkiss: AX.25 Multikiss, Hans Albas PE1AYX\n";
-static const char msg_regfail[] __initdata = KERN_ERR \
+static const char msg_regfail[] __initconst = KERN_ERR \
 	"mkiss: can't register line discipline (err = %d)\n";
 
 static int __init mkiss_init_driver(void)
@@ -1015,7 +1015,7 @@ static int __init mkiss_init_driver(void
 	return status;
 }
 
-static const char msg_unregfail[] __exitdata = KERN_ERR \
+static const char msg_unregfail[] = KERN_ERR \
 	"mkiss: can't unregister line discipline (err = %d)\n";
 
 static void __exit mkiss_exit_driver(void)
diff -puN drivers/net/hamradio/scc.c~sections-fix-section-conflicts-in-drivers-net-hamradio drivers/net/hamradio/scc.c
--- a/drivers/net/hamradio/scc.c~sections-fix-section-conflicts-in-drivers-net-hamradio
+++ a/drivers/net/hamradio/scc.c
@@ -182,7 +182,7 @@
 
 #include "z8530.h"
 
-static const char banner[] __initdata = KERN_INFO \
+static const char banner[] __initconst = KERN_INFO \
 	"AX.25: Z8530 SCC driver version "VERSION".dl1bke\n";
 
 static void t_dwait(unsigned long);
diff -puN drivers/net/hamradio/yam.c~sections-fix-section-conflicts-in-drivers-net-hamradio drivers/net/hamradio/yam.c
--- a/drivers/net/hamradio/yam.c~sections-fix-section-conflicts-in-drivers-net-hamradio
+++ a/drivers/net/hamradio/yam.c
@@ -76,7 +76,7 @@
 /* --------------------------------------------------------------------- */
 
 static const char yam_drvname[] = "yam";
-static const char yam_drvinfo[] __initdata = KERN_INFO \
+static const char yam_drvinfo[] __initconst = KERN_INFO \
 	"YAM driver version 0.8 by F1OAT/F6FBB\n";
 
 /* --------------------------------------------------------------------- */
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

