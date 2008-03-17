From: akpm@linux-foundation.org
Subject: - input-fix-cobalt_btns-loadable-keymap-support.patch removed from -mm tree
Date: Mon, 17 Mar 2008 14:00:54 -0700
Message-ID: <200803172100.m2HL0s00030892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757202AbYCQVB0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:01:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoichi_yuasa@tripeaks.co.jp, dtor@mail.ru, jkosina@suse.cz, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     input: fix cobalt_btns loadable keymap support
has been removed from the -mm tree.  Its filename was
     input-fix-cobalt_btns-loadable-keymap-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: fix cobalt_btns loadable keymap support
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Without this patch the Cobalt defconfig won't build.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/cobalt_btns.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/input/misc/cobalt_btns.c~input-fix-cobalt_btns-loadable-keymap-support drivers/input/misc/cobalt_btns.c
--- a/drivers/input/misc/cobalt_btns.c~input-fix-cobalt_btns-loadable-keymap-support
+++ a/drivers/input/misc/cobalt_btns.c
@@ -1,7 +1,7 @@
 /*
  *  Cobalt button interface driver.
  *
- *  Copyright (C) 2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2007-2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -15,7 +15,7 @@
  *
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
  */
 #include <linux/init.h>
 #include <linux/input-polldev.h>
@@ -55,7 +55,7 @@ static void handle_buttons(struct input_
 	status = ~readl(bdev->reg) >> 24;
 
 	for (i = 0; i < ARRAY_SIZE(bdev->keymap); i++) {
-		if (status & (1UL << i)) {
+		if (status & (1U << i)) {
 			if (++bdev->count[i] == BUTTONS_COUNT_THRESHOLD) {
 				input_event(input, EV_MSC, MSC_SCAN, i);
 				input_report_key(input, bdev->keymap[i], 1);
@@ -97,16 +97,16 @@ static int __devinit cobalt_buttons_prob
 	input->name = "Cobalt buttons";
 	input->phys = "cobalt/input0";
 	input->id.bustype = BUS_HOST;
-	input->cdev.dev = &pdev->dev;
+	input->dev.parent = &pdev->dev;
 
-	input->keycode = pdev->keymap;
-	input->keycodemax = ARRAY_SIZE(pdev->keymap);
+	input->keycode = bdev->keymap;
+	input->keycodemax = ARRAY_SIZE(bdev->keymap);
 	input->keycodesize = sizeof(unsigned short);
 
 	input_set_capability(input, EV_MSC, MSC_SCAN);
 	__set_bit(EV_KEY, input->evbit);
-	for (i = 0; i < ARRAY_SIZE(buttons_map); i++)
-		__set_bit(input->keycode[i], input->keybit);
+	for (i = 0; i < ARRAY_SIZE(cobalt_map); i++)
+		__set_bit(bdev->keymap[i], input->keybit);
 	__clear_bit(KEY_RESERVED, input->keybit);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

git-input.patch

