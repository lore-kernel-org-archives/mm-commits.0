From: akpm@linux-foundation.org
Subject: + sections-fix-section-conflicts-in-drivers-net-hamradio.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:37:31 -0700
Message-ID: <20120913233732.56E031E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:33886 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759057Ab2IMXhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:37:32 -0400
Received: by mail-yx0-f202.google.com with SMTP id q6so389740yen.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:37:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, davem@davemloft.net


The patch titled
     Subject: sections: fix section conflicts in drivers/net/hamradio
has been added to the -mm tree.  Its filename is
     sections-fix-section-conflicts-in-drivers-net-hamradio.patch

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

