From: akpm@linux-foundation.org
Subject: [merged]
 drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:16 -0700
Message-ID: <51db14ec.f2lKZ0M94eGFLr6T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51768 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab3GHThR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zbr@ioremap.net, greg@kroah.com, jeff.dagenais@gmail.com

Subject: [merged] drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode.patch removed from -mm tree
To: jeff.dagenais@gmail.com,greg@kroah.com,zbr@ioremap.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:16 -0700


The patch titled
     Subject: drivers/w1/slaves/w1_ds2408.c: add magic sequence to disable P0 test mode
has been removed from the -mm tree.  Its filename was
     drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Subject: drivers/w1/slaves/w1_ds2408.c: add magic sequence to disable P0 test mode

Power-up timing

The DS2408 is sensitive to the power-on slew rate and can inadvertently
power up with a test mode feature enabled.  When this occurs, the P0 port
does not respond to the Channel Access Write command.  For most reliable
operation, it is recommended to disable the test mode after every power-on
reset using the Disable Test Mode sequence shown below.  The 64-bit ROM
code must be transmitted in the same bit sequence as with the Match ROM
command, i.e., least significant bit first.  This precaution is
recommended in parasite power mode (VCC pin connected to GND) as well as
with VCC power.

Disable Test Mode:
RST,PD,96h,<64-bit DS2408 ROM Code>,3Ch,RST,PD

[akpm@linux-foundation.org: don't use kerenldoc token to introduce a non-kerneldoc comment, tweak whitespace]
Signed-off-by: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_ds2408.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN drivers/w1/slaves/w1_ds2408.c~drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode drivers/w1/slaves/w1_ds2408.c
--- a/drivers/w1/slaves/w1_ds2408.c~drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode
+++ a/drivers/w1/slaves/w1_ds2408.c
@@ -302,7 +302,33 @@ error:
 	return -EIO;
 }
 
+/*
+ * This is a special sequence we must do to ensure the P0 output is not stuck
+ * in test mode. This is described in rev 2 of the ds2408's datasheet
+ * (http://datasheets.maximintegrated.com/en/ds/DS2408.pdf) under
+ * "APPLICATION INFORMATION/Power-up timing".
+ */
+static int w1_f29_disable_test_mode(struct w1_slave *sl)
+{
+	int res;
+	u8 magic[10] = {0x96, };
+	u64 rn = le64_to_cpu(*((u64*)&sl->reg_num));
+
+	memcpy(&magic[1], &rn, 8);
+	magic[9] = 0x3C;
+
+	mutex_lock(&sl->master->bus_mutex);
 
+	res = w1_reset_bus(sl->master);
+	if (res)
+		goto out;
+	w1_write_block(sl->master, magic, ARRAY_SIZE(magic));
+
+	res = w1_reset_bus(sl->master);
+out:
+	mutex_unlock(&sl->master->bus_mutex);
+	return res;
+}
 
 static struct bin_attribute w1_f29_sysfs_bin_files[] = {
 	{
@@ -363,6 +389,10 @@ static int w1_f29_add_slave(struct w1_sl
 	int err = 0;
 	int i;
 
+	err = w1_f29_disable_test_mode(sl);
+	if (err)
+		return err;
+
 	for (i = 0; i < ARRAY_SIZE(w1_f29_sysfs_bin_files) && !err; ++i)
 		err = sysfs_create_bin_file(
 			&sl->dev.kobj,
_

Patches currently in -mm which might be from jeff.dagenais@gmail.com are

origin.patch

