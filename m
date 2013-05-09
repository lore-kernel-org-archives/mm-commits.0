From: akpm@linux-foundation.org
Subject: + drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode.patch added to -mm tree
Date: Thu, 09 May 2013 11:04:12 -0700
Message-ID: <20130509180412.D2FE55A4251@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:35908 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3EISMD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 14:12:03 -0400
Received: by mail-ve0-f201.google.com with SMTP id cz11so51725veb.2
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 11:12:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff.dagenais@gmail.com, greg@kroah.com, zbr@ioremap.net


The patch titled
     Subject: drivers/w1/slaves/w1_ds2408.c: add magic sequence to disable P0 test mode
has been added to the -mm tree.  Its filename is
     drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_ds2408.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff -puN drivers/w1/slaves/w1_ds2408.c~drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode drivers/w1/slaves/w1_ds2408.c
--- a/drivers/w1/slaves/w1_ds2408.c~drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode
+++ a/drivers/w1/slaves/w1_ds2408.c
@@ -301,7 +301,32 @@ error:
 	return -EIO;
 }
 
+/**
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
@@ -362,6 +387,10 @@ static int w1_f29_add_slave(struct w1_sl
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
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch

