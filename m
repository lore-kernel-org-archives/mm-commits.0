From: akpm@linux-foundation.org
Subject: [merged] openrisc-remove-use-of-seq_printf-return-value.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:55:26 -0700
Message-ID: <552fe97e.v/5t9au1kjx/Lx92%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbbDPQt5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jonas@southpole.se, mm-commits@vger.kernel.org


The patch titled
     Subject: openrisc: remove use of seq_printf return value
has been removed from the -mm tree.  Its filename was
     openrisc-remove-use-of-seq_printf-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch
checkpatch-add-define-foo-string-long-line-exception.patch
checkpatch-add-uart_ops-to-normally-const-structs.patch
checkpatch-add-prefer-array_size-test.patch
checkpatch-improve-operator-spacing-check.patch
checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch
checkpatchpl-new-instances-of-enosys-are-errors.patch
errnoh-improve-enosyss-comment.patch
checkpatch-fix-fix-use-with-a-patch-of-multiple-files.patch
checkpatch-avoid-spaces-required-around-that-false-positive.patch
rtc-use-more-standard-kernel-logging-styles.patch
adfs-returning-correct-return-values.patch
linux-next.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch

