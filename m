From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-ds1307-long-block-operations-bugfix-fix.patch removed from -mm tree
Date: Thu, 28 Feb 2013 13:34:57 -0800
Message-ID: <20130228213458.240B631C1E1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:64505 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab3B1Ve7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 16:34:59 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so254889ghb.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 13:34:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ba@cykian.net, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-ds1307-long-block-operations-bugfix-fix
has been removed from the -mm tree.  Its filename was
     rtc-ds1307-long-block-operations-bugfix-fix.patch

This patch was dropped because it was folded into rtc-ds1307-long-block-operations-bugfix.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-ds1307-long-block-operations-bugfix-fix

rework code to avoid 80-column overflows

Cc: Bertrand Achard <ba@cykian.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   52 ++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-long-block-operations-bugfix-fix drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-long-block-operations-bugfix-fix
+++ a/drivers/rtc/rtc-ds1307.c
@@ -259,45 +259,45 @@ static s32 ds1307_write_block_data(const
 static s32 ds1307_native_smbus_write_block_data(const struct i2c_client *client,
 				u8 command, u8 length, const u8 *values)
 {
-	if (length <= I2C_SMBUS_BLOCK_MAX) {
+	u8 suboffset = 0;
+
+	if (length <= I2C_SMBUS_BLOCK_MAX)
 		return i2c_smbus_write_i2c_block_data(client,
 					command, length, values);
-	} else {
-		u8 suboffset = 0;
-		while (suboffset < length) {
-			s32 retval = i2c_smbus_write_i2c_block_data(client,
-						command+suboffset,
-						min(I2C_SMBUS_BLOCK_MAX, length-suboffset),
-						values+suboffset);
-			if (retval < 0)
-				return retval;
 
-			suboffset += I2C_SMBUS_BLOCK_MAX;
-		}
-		return length;
+	while (suboffset < length) {
+		s32 retval = i2c_smbus_write_i2c_block_data(client,
+				command + suboffset,
+				min(I2C_SMBUS_BLOCK_MAX, length - suboffset),
+				values + suboffset);
+		if (retval < 0)
+			return retval;
+
+		suboffset += I2C_SMBUS_BLOCK_MAX;
 	}
+	return length;
 }
 
 static s32 ds1307_native_smbus_read_block_data(const struct i2c_client *client,
 				u8 command, u8 length, u8 *values)
 {
-	if (length <= I2C_SMBUS_BLOCK_MAX) {
+	u8 suboffset = 0;
+
+	if (length <= I2C_SMBUS_BLOCK_MAX)
 		return i2c_smbus_read_i2c_block_data(client,
 					command, length, values);
-	} else {
-		u8 suboffset = 0;
-		while (suboffset < length) {
-			s32 retval = i2c_smbus_read_i2c_block_data(client,
-						command+suboffset,
-						min(I2C_SMBUS_BLOCK_MAX, length-suboffset),
-						values+suboffset);
-			if (retval < 0)
-				return retval;
 
-			suboffset += I2C_SMBUS_BLOCK_MAX;
-		}
-		return length;
+	while (suboffset < length) {
+		s32 retval = i2c_smbus_read_i2c_block_data(client,
+				command + suboffset,
+				min(I2C_SMBUS_BLOCK_MAX, length - suboffset),
+				values + suboffset);
+		if (retval < 0)
+			return retval;
+
+		suboffset += I2C_SMBUS_BLOCK_MAX;
 	}
+	return length;
 }
 
 /*----------------------------------------------------------------------*/
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

