From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch removed
 from -mm tree
Date: Thu, 16 Apr 2015 12:06:03 -0700
Message-ID: <5530081b.BjCsk8qez59I1H4t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbbDPTGE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 15:06:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, baruch@tkos.co.il, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix
has been removed from the -mm tree.  Its filename was
     rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch

This patch was dropped because it was folded into rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix

build command arrays at compile-time

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-digicolor.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-digicolor.c~rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix drivers/rtc/rtc-digicolor.c
--- a/drivers/rtc/rtc-digicolor.c~rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix
+++ a/drivers/rtc/rtc-digicolor.c
@@ -42,7 +42,7 @@ struct dc_rtc {
 	void __iomem		*regs;
 };
 
-static int dc_rtc_cmds(struct dc_rtc *rtc, u8 *cmds, int len)
+static int dc_rtc_cmds(struct dc_rtc *rtc, const u8 *cmds, int len)
 {
 	u8 val;
 	int i, ret;
@@ -62,7 +62,7 @@ static int dc_rtc_cmds(struct dc_rtc *rt
 
 static int dc_rtc_read(struct dc_rtc *rtc, unsigned long *val)
 {
-	u8 read_cmds[] = {CMD_READ, CMD_NOP};
+	static const u8 read_cmds[] = {CMD_READ, CMD_NOP};
 	u32 reference, time1, time2;
 	int ret;
 
@@ -86,7 +86,7 @@ static int dc_rtc_read(struct dc_rtc *rt
 
 static int dc_rtc_write(struct dc_rtc *rtc, u32 val)
 {
-	u8 write_cmds[] = {CMD_WRITE, CMD_NOP, CMD_RESET, CMD_NOP};
+	static const u8 write_cmds[] = {CMD_WRITE, CMD_NOP, CMD_RESET, CMD_NOP};
 
 	writel_relaxed(val, rtc->regs + DC_RTC_REFERENCE);
 	return dc_rtc_cmds(rtc, write_cmds, ARRAY_SIZE(write_cmds));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-find__bit-reimplementation.patch
checkpatch-match-more-world-writable-permissions.patch
binfmt_misc-simplify-entry_status.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc.patch
fs-fat-remove-unnecessary-includes-fix.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
mm-rcu-protected-get_mm_exe_file.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch

