From: akpm@linux-foundation.org
Subject: + sections-fix-section-conflicts-in-drivers-cpufreq.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:37:13 -0700
Message-ID: <20120913233714.34D851E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:59099 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759062Ab2IMXhP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:37:15 -0400
Received: by ghbz15 with SMTP id z15so201517ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:37:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, rjw@sisk.pl


The patch titled
     Subject: sections: fix section conflicts in drivers/cpufreq
has been added to the -mm tree.  Its filename is
     sections-fix-section-conflicts-in-drivers-cpufreq.patch

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
Subject: sections: fix section conflicts in drivers/cpufreq

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/longhaul.h |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/cpufreq/longhaul.h~sections-fix-section-conflicts-in-drivers-cpufreq drivers/cpufreq/longhaul.h
--- a/drivers/cpufreq/longhaul.h~sections-fix-section-conflicts-in-drivers-cpufreq
+++ a/drivers/cpufreq/longhaul.h
@@ -56,7 +56,7 @@ union msr_longhaul {
 /*
  * VIA C3 Samuel 1  & Samuel 2 (stepping 0)
  */
-static const int __cpuinitdata samuel1_mults[16] = {
+static const int __cpuinitconst samuel1_mults[16] = {
 	-1, /* 0000 -> RESERVED */
 	30, /* 0001 ->  3.0x */
 	40, /* 0010 ->  4.0x */
@@ -75,7 +75,7 @@ static const int __cpuinitdata samuel1_m
 	-1, /* 1111 -> RESERVED */
 };
 
-static const int __cpuinitdata samuel1_eblcr[16] = {
+static const int __cpuinitconst samuel1_eblcr[16] = {
 	50, /* 0000 -> RESERVED */
 	30, /* 0001 ->  3.0x */
 	40, /* 0010 ->  4.0x */
@@ -97,7 +97,7 @@ static const int __cpuinitdata samuel1_e
 /*
  * VIA C3 Samuel2 Stepping 1->15
  */
-static const int __cpuinitdata samuel2_eblcr[16] = {
+static const int __cpuinitconst samuel2_eblcr[16] = {
 	50,  /* 0000 ->  5.0x */
 	30,  /* 0001 ->  3.0x */
 	40,  /* 0010 ->  4.0x */
@@ -119,7 +119,7 @@ static const int __cpuinitdata samuel2_e
 /*
  * VIA C3 Ezra
  */
-static const int __cpuinitdata ezra_mults[16] = {
+static const int __cpuinitconst ezra_mults[16] = {
 	100, /* 0000 -> 10.0x */
 	30,  /* 0001 ->  3.0x */
 	40,  /* 0010 ->  4.0x */
@@ -138,7 +138,7 @@ static const int __cpuinitdata ezra_mult
 	120, /* 1111 -> 12.0x */
 };
 
-static const int __cpuinitdata ezra_eblcr[16] = {
+static const int __cpuinitconst ezra_eblcr[16] = {
 	50,  /* 0000 ->  5.0x */
 	30,  /* 0001 ->  3.0x */
 	40,  /* 0010 ->  4.0x */
@@ -160,7 +160,7 @@ static const int __cpuinitdata ezra_eblc
 /*
  * VIA C3 (Ezra-T) [C5M].
  */
-static const int __cpuinitdata ezrat_mults[32] = {
+static const int __cpuinitconst ezrat_mults[32] = {
 	100, /* 0000 -> 10.0x */
 	30,  /* 0001 ->  3.0x */
 	40,  /* 0010 ->  4.0x */
@@ -196,7 +196,7 @@ static const int __cpuinitdata ezrat_mul
 	-1,  /* 1111 -> RESERVED (12.0x) */
 };
 
-static const int __cpuinitdata ezrat_eblcr[32] = {
+static const int __cpuinitconst ezrat_eblcr[32] = {
 	50,  /* 0000 ->  5.0x */
 	30,  /* 0001 ->  3.0x */
 	40,  /* 0010 ->  4.0x */
@@ -235,7 +235,7 @@ static const int __cpuinitdata ezrat_ebl
 /*
  * VIA C3 Nehemiah */
 
-static const int __cpuinitdata nehemiah_mults[32] = {
+static const int __cpuinitconst nehemiah_mults[32] = {
 	100, /* 0000 -> 10.0x */
 	-1, /* 0001 -> 16.0x */
 	40,  /* 0010 ->  4.0x */
@@ -270,7 +270,7 @@ static const int __cpuinitdata nehemiah_
 	-1, /* 1111 -> 12.0x */
 };
 
-static const int __cpuinitdata nehemiah_eblcr[32] = {
+static const int __cpuinitconst nehemiah_eblcr[32] = {
 	50,  /* 0000 ->  5.0x */
 	160, /* 0001 -> 16.0x */
 	40,  /* 0010 ->  4.0x */
@@ -315,7 +315,7 @@ struct mV_pos {
 	unsigned short pos;
 };
 
-static const struct mV_pos __cpuinitdata vrm85_mV[32] = {
+static const struct mV_pos __cpuinitconst vrm85_mV[32] = {
 	{1250, 8},	{1200, 6},	{1150, 4},	{1100, 2},
 	{1050, 0},	{1800, 30},	{1750, 28},	{1700, 26},
 	{1650, 24},	{1600, 22},	{1550, 20},	{1500, 18},
@@ -326,14 +326,14 @@ static const struct mV_pos __cpuinitdata
 	{1475, 17},	{1425, 15},	{1375, 13},	{1325, 11}
 };
 
-static const unsigned char __cpuinitdata mV_vrm85[32] = {
+static const unsigned char __cpuinitconst mV_vrm85[32] = {
 	0x04,	0x14,	0x03,	0x13,	0x02,	0x12,	0x01,	0x11,
 	0x00,	0x10,	0x0f,	0x1f,	0x0e,	0x1e,	0x0d,	0x1d,
 	0x0c,	0x1c,	0x0b,	0x1b,	0x0a,	0x1a,	0x09,	0x19,
 	0x08,	0x18,	0x07,	0x17,	0x06,	0x16,	0x05,	0x15
 };
 
-static const struct mV_pos __cpuinitdata mobilevrm_mV[32] = {
+static const struct mV_pos __cpuinitconst mobilevrm_mV[32] = {
 	{1750, 31},	{1700, 30},	{1650, 29},	{1600, 28},
 	{1550, 27},	{1500, 26},	{1450, 25},	{1400, 24},
 	{1350, 23},	{1300, 22},	{1250, 21},	{1200, 20},
@@ -344,7 +344,7 @@ static const struct mV_pos __cpuinitdata
 	{675, 3},	{650, 2},	{625, 1},	{600, 0}
 };
 
-static const unsigned char __cpuinitdata mV_mobilevrm[32] = {
+static const unsigned char __cpuinitconst mV_mobilevrm[32] = {
 	0x1f,	0x1e,	0x1d,	0x1c,	0x1b,	0x1a,	0x19,	0x18,
 	0x17,	0x16,	0x15,	0x14,	0x13,	0x12,	0x11,	0x10,
 	0x0f,	0x0e,	0x0d,	0x0c,	0x0b,	0x0a,	0x09,	0x08,
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

