From: akpm@linux-foundation.org
Subject: [merged] rapidio-tsi721-fix-bug-in-register-offset-definitions.patch removed from -mm tree
Date: Fri, 16 Mar 2012 13:57:55 -0700
Message-ID: <20120316205755.66860A0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:59388 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031888Ab2CPU56 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2012 16:57:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, chul.kim@idt.com, mporter@kernel.crashing.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: fix bug in register offset definitions
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-fix-bug-in-register-offset-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: fix bug in register offset definitions

Fix indexed register offset definitions that use decimal (wrong) instead
of hexadecimal (correct) notation for indexing multipliers.

Incorrect definitions do not affect Tsi721 driver in its current default
configuration because it uses only IDB queue 0.  Loss of inbound doorbell
functionality should be observed if queue other than 0 is used.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Chul Kim <chul.kim@idt.com>
Cc: <stable@vger.kernel.org>		[3.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.h |   30 ++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.h~rapidio-tsi721-fix-bug-in-register-offset-definitions drivers/rapidio/devices/tsi721.h
--- a/drivers/rapidio/devices/tsi721.h~rapidio-tsi721-fix-bug-in-register-offset-definitions
+++ a/drivers/rapidio/devices/tsi721.h
@@ -118,34 +118,34 @@
 
 #define TSI721_IDB_ENTRY_SIZE	64
 
-#define TSI721_IDQ_CTL(x)	(0x20000 + (x) * 1000)
+#define TSI721_IDQ_CTL(x)	(0x20000 + (x) * 0x1000)
 #define TSI721_IDQ_SUSPEND	0x00000002
 #define TSI721_IDQ_INIT		0x00000001
 
-#define TSI721_IDQ_STS(x)	(0x20004 + (x) * 1000)
+#define TSI721_IDQ_STS(x)	(0x20004 + (x) * 0x1000)
 #define TSI721_IDQ_RUN		0x00200000
 
-#define TSI721_IDQ_MASK(x)	(0x20008 + (x) * 1000)
+#define TSI721_IDQ_MASK(x)	(0x20008 + (x) * 0x1000)
 #define TSI721_IDQ_MASK_MASK	0xffff0000
 #define TSI721_IDQ_MASK_PATT	0x0000ffff
 
-#define TSI721_IDQ_RP(x)	(0x2000c + (x) * 1000)
+#define TSI721_IDQ_RP(x)	(0x2000c + (x) * 0x1000)
 #define TSI721_IDQ_RP_PTR	0x0007ffff
 
-#define TSI721_IDQ_WP(x)	(0x20010 + (x) * 1000)
+#define TSI721_IDQ_WP(x)	(0x20010 + (x) * 0x1000)
 #define TSI721_IDQ_WP_PTR	0x0007ffff
 
-#define TSI721_IDQ_BASEL(x)	(0x20014 + (x) * 1000)
+#define TSI721_IDQ_BASEL(x)	(0x20014 + (x) * 0x1000)
 #define TSI721_IDQ_BASEL_ADDR	0xffffffc0
-#define TSI721_IDQ_BASEU(x)	(0x20018 + (x) * 1000)
-#define TSI721_IDQ_SIZE(x)	(0x2001c + (x) * 1000)
+#define TSI721_IDQ_BASEU(x)	(0x20018 + (x) * 0x1000)
+#define TSI721_IDQ_SIZE(x)	(0x2001c + (x) * 0x1000)
 #define TSI721_IDQ_SIZE_VAL(size)	(__fls(size) - 4)
 #define TSI721_IDQ_SIZE_MIN	512
 #define TSI721_IDQ_SIZE_MAX	(512 * 1024)
 
-#define TSI721_SR_CHINT(x)	(0x20040 + (x) * 1000)
-#define TSI721_SR_CHINTE(x)	(0x20044 + (x) * 1000)
-#define TSI721_SR_CHINTSET(x)	(0x20048 + (x) * 1000)
+#define TSI721_SR_CHINT(x)	(0x20040 + (x) * 0x1000)
+#define TSI721_SR_CHINTE(x)	(0x20044 + (x) * 0x1000)
+#define TSI721_SR_CHINTSET(x)	(0x20048 + (x) * 0x1000)
 #define TSI721_SR_CHINT_ODBOK	0x00000020
 #define TSI721_SR_CHINT_IDBQRCV	0x00000010
 #define TSI721_SR_CHINT_SUSP	0x00000008
@@ -156,7 +156,7 @@
 
 #define TSI721_IBWIN_NUM	8
 
-#define TSI721_IBWINLB(x)	(0x29000 + (x) * 20)
+#define TSI721_IBWINLB(x)	(0x29000 + (x) * 0x20)
 #define TSI721_IBWINLB_BA	0xfffff000
 #define TSI721_IBWINLB_WEN	0x00000001
 
@@ -187,13 +187,13 @@
  */
 #define TSI721_OBWIN_NUM	TSI721_PC2SR_WINS
 
-#define TSI721_OBWINLB(x)	(0x40000 + (x) * 20)
+#define TSI721_OBWINLB(x)	(0x40000 + (x) * 0x20)
 #define TSI721_OBWINLB_BA	0xffff8000
 #define TSI721_OBWINLB_WEN	0x00000001
 
-#define TSI721_OBWINUB(x)	(0x40004 + (x) * 20)
+#define TSI721_OBWINUB(x)	(0x40004 + (x) * 0x20)
 
-#define TSI721_OBWINSZ(x)	(0x40008 + (x) * 20)
+#define TSI721_OBWINSZ(x)	(0x40008 + (x) * 0x20)
 #define TSI721_OBWINSZ_SIZE	0x00001f00
 #define TSI721_OBWIN_SIZE(size)	(__fls(size) - 15)
 
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

