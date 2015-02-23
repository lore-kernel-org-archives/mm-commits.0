From: akpm@linux-foundation.org
Subject: + openrisc-remove-use-of-seq_printf-return-value.patch added to
 -mm tree
Date: Mon, 23 Feb 2015 15:58:58 -0800
Message-ID: <54ebbec2.bVvr83XR3F9FxDeZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbbBWX67 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 18:58:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jonas@southpole.se, mm-commits@vger.kernel.org


The patch titled
     Subject: openrisc: remove use of seq_printf return value
has been added to the -mm tree.  Its filename is
     openrisc-remove-use-of-seq_printf-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/openrisc-remove-use-of-seq_printf-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/openrisc-remove-use-of-seq_printf-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: openrisc: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jonas Bonn <jonas@southpole.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/kernel/setup.c |   50 +++++++++++++++++----------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff -puN arch/openrisc/kernel/setup.c~openrisc-remove-use-of-seq_printf-return-value arch/openrisc/kernel/setup.c
--- a/arch/openrisc/kernel/setup.c~openrisc-remove-use-of-seq_printf-return-value
+++ a/arch/openrisc/kernel/setup.c
@@ -329,30 +329,32 @@ static int show_cpuinfo(struct seq_file
 	version = (vr & SPR_VR_VER) >> 24;
 	revision = vr & SPR_VR_REV;
 
-	return seq_printf(m,
-			  "cpu\t\t: OpenRISC-%x\n"
-			  "revision\t: %d\n"
-			  "frequency\t: %ld\n"
-			  "dcache size\t: %d bytes\n"
-			  "dcache block size\t: %d bytes\n"
-			  "icache size\t: %d bytes\n"
-			  "icache block size\t: %d bytes\n"
-			  "immu\t\t: %d entries, %lu ways\n"
-			  "dmmu\t\t: %d entries, %lu ways\n"
-			  "bogomips\t: %lu.%02lu\n",
-			  version,
-			  revision,
-			  loops_per_jiffy * HZ,
-			  cpuinfo.dcache_size,
-			  cpuinfo.dcache_block_size,
-			  cpuinfo.icache_size,
-			  cpuinfo.icache_block_size,
-			  1 << ((mfspr(SPR_DMMUCFGR) & SPR_DMMUCFGR_NTS) >> 2),
-			  1 + (mfspr(SPR_DMMUCFGR) & SPR_DMMUCFGR_NTW),
-			  1 << ((mfspr(SPR_IMMUCFGR) & SPR_IMMUCFGR_NTS) >> 2),
-			  1 + (mfspr(SPR_IMMUCFGR) & SPR_IMMUCFGR_NTW),
-			  (loops_per_jiffy * HZ) / 500000,
-			  ((loops_per_jiffy * HZ) / 5000) % 100);
+	seq_printf(m,
+		   "cpu\t\t: OpenRISC-%x\n"
+		   "revision\t: %d\n"
+		   "frequency\t: %ld\n"
+		   "dcache size\t: %d bytes\n"
+		   "dcache block size\t: %d bytes\n"
+		   "icache size\t: %d bytes\n"
+		   "icache block size\t: %d bytes\n"
+		   "immu\t\t: %d entries, %lu ways\n"
+		   "dmmu\t\t: %d entries, %lu ways\n"
+		   "bogomips\t: %lu.%02lu\n",
+		   version,
+		   revision,
+		   loops_per_jiffy * HZ,
+		   cpuinfo.dcache_size,
+		   cpuinfo.dcache_block_size,
+		   cpuinfo.icache_size,
+		   cpuinfo.icache_block_size,
+		   1 << ((mfspr(SPR_DMMUCFGR) & SPR_DMMUCFGR_NTS) >> 2),
+		   1 + (mfspr(SPR_DMMUCFGR) & SPR_DMMUCFGR_NTW),
+		   1 << ((mfspr(SPR_IMMUCFGR) & SPR_IMMUCFGR_NTS) >> 2),
+		   1 + (mfspr(SPR_IMMUCFGR) & SPR_IMMUCFGR_NTW),
+		   (loops_per_jiffy * HZ) / 500000,
+		   ((loops_per_jiffy * HZ) / 5000) % 100);
+
+	return 0;
 }
 
 static void *c_start(struct seq_file *m, loff_t * pos)
_

Patches currently in -mm which might be from joe@perches.com are

staging-lustre-convert-return-seq_printf-uses.patch
staging-lustre-convert-seq_-hash-functions-to-return-void.patch
staging-lustre-convert-uses-of-int-rc-=-seq_printf.patch
staging-lustre-convert-remaining-uses-of-=-seq_printf.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
pxa27x_udc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
mfd-ab8500-debugfs-remove-use-of-seq_printf-return-value.patch
staging-i2o-remove-use-of-seq_printf-return-value.patch
staging-rtl8192x-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
regulator-dbx500-remove-use-of-seq_puts-seq_printf-return-value.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
linux-next.patch

