From: akpm@linux-foundation.org
Subject: - bq27x00_battery-use-unaligned-access-helper.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:51:43 -0700
Message-ID: <200810012151.m91Lphgm005951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754424AbYJAVvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:51:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, cbouatmailru@gmail.com, giometti@linux.it, mm-commits@vger.kernel.org


The patch titled
     bq27x00_battery: use unaligned access helper
has been removed from the -mm tree.  Its filename was
     bq27x00_battery-use-unaligned-access-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bq27x00_battery: use unaligned access helper
From: Harvey Harrison <harvey.harrison@gmail.com>

Remove hand-rolled get_unaligned_be16, this points to a possible bug as
bq27x00_read does another endian byteswap which sparse notices:

drivers/power/bq27x00_battery.c:81:14: warning: cast to restricted __be16
Which should probably be checked.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Rodolfo Giometti <giometti@linux.it>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/bq27x00_battery.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/power/bq27x00_battery.c~bq27x00_battery-use-unaligned-access-helper drivers/power/bq27x00_battery.c
--- a/drivers/power/bq27x00_battery.c~bq27x00_battery-use-unaligned-access-helper
+++ a/drivers/power/bq27x00_battery.c
@@ -23,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
 #include <linux/idr.h>
+#include <asm/unaligned.h>
 
 #include <linux/i2c.h>
 
@@ -33,7 +34,6 @@
 #define BQ27x00_REG_RSOC		0x0B /* Relative State-of-Charge */
 #define BQ27x00_REG_AI			0x14
 #define BQ27x00_REG_FLAGS		0x0A
-#define HIGH_BYTE(A)			((A) << 8)
 
 /* If the system has several batteries we need a different name for each
  * of them...
@@ -239,7 +239,7 @@ static int bq27200_read(u8 reg, int *rt_
 		err = i2c_transfer(client->adapter, msg, 1);
 		if (err >= 0) {
 			if (!b_single)
-				*rt_value = data[1] | HIGH_BYTE(data[0]);
+				*rt_value = get_unaligned_be16(data);
 			else
 				*rt_value = data[0];
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

fbcon-fix-monochrome-color-value-calculation.patch
git-avr32.patch
git-powerpc.patch
git-x86.patch
git-xtensa.patch
git-hid.patch
git-v4l-dvb.patch
git-xfs.patch
git-net.patch
git-sound.patch
git-block.patch
git-pcmcia.patch
git-battery.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
char-moxac-sparse-annotation.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
lib-pull-base-guessing-logic-to-helper-function.patch
lib-trivial-whitespace-tidy.patch
lib-remove-defining-macros-for-strict_strto.patch

