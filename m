From: akpm@linux-foundation.org
Subject: + rtc-ds1307-long-block-operations-bugfix-fix.patch added to -mm tree
Date: Tue, 18 Dec 2012 16:19:19 -0800
Message-ID: <20121219001920.82A2420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:50802 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab2LSATX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 19:19:23 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so71122wgb.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 16:19:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ba@cykian.net


The patch titled
     Subject: rtc-ds1307-long-block-operations-bugfix-fix
has been added to the -mm tree.  Its filename is
     rtc-ds1307-long-block-operations-bugfix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
memory-hotplug-document-and-enable-config_movable_node.patch
memcg-kmem-accounting-basic-infrastructure.patch
slub-slub-specific-propagation-changes.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch
sgi-xp-handle-non-fatal-traps-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
block-remove-deadlock-in-disk_clear_events.patch
block-prevent-race-cleanup.patch
mm.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sendfile-allows-bypassing-of-notifier-events.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

