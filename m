From: akpm@linux-foundation.org
Subject: + hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors-v3.patch added to -mm tree
Date: Mon, 12 Jul 2010 16:22:11 -0700
Message-ID: <201007122322.o6CNMBBP002961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755569Ab0GLXXG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 19:23:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: guenter.roeck@ericsson.com, broonie@opensource.wolfsonmicro.com, hdegoede@redhat.com, khali@linux-fr.org, rdunlap@xenotime.net


The patch titled
     hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors-v3
has been added to the -mm tree.  Its filename is
     hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors-v3
From: Guenter Roeck <guenter.roeck@ericsson.com>

- Access struct jc42_chips array through local variable
- Added a couple of comments
- Minor formatting changes
- Removed unnecessary "data->valid = false;"

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/jc42.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/hwmon/jc42.c~hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors-v3 drivers/hwmon/jc42.c
--- a/drivers/hwmon/jc42.c~hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors-v3
+++ a/drivers/hwmon/jc42.c
@@ -136,12 +136,12 @@ static struct jc42_chips jc42_chips[] = 
 /* Each client has this additional data */
 struct jc42_data {
 	struct device	*hwmon_dev;
-	struct mutex	update_lock;
+	struct mutex	update_lock;	/* protect register access */
 	bool		extended;	/* true if extended range supported */
 	bool		valid;
 	unsigned long	last_updated;	/* In jiffies */
 	u16		orig_config;	/* original configuration */
-	u16		config;		/* configuration */
+	u16		config;		/* current configuration */
 	u16		temp_input;	/* Temperatures */
 	u16		temp_crit;
 	u16		temp_min;
@@ -439,9 +439,9 @@ static int jc42_detect(struct i2c_client
 		return -ENODEV;
 
 	for (i = 0; i < ARRAY_SIZE(jc42_chips); i++) {
-		if (manid == jc42_chips[i].manid
-		    && (devid & jc42_chips[i].devid_mask) ==
-					    jc42_chips[i].devid) {
+		struct jc42_chips *chip = &jc42_chips[i];
+		if (manid == chip->manid &&
+		    (devid & chip->devid_mask) == chip->devid) {
 			strlcpy(info->type, "jc42", I2C_NAME_SIZE);
 			return 0;
 		}
@@ -462,7 +462,6 @@ static int jc42_probe(struct i2c_client 
 	}
 
 	i2c_set_clientdata(new_client, data);
-	data->valid = false;
 	mutex_init(&data->update_lock);
 
 	cap = jc42_read_value(new_client, JC42_REG_CAP);
_

Patches currently in -mm which might be from guenter.roeck@ericsson.com are

origin.patch
linux-next.patch
hwmon-driver-for-smm665-six-channel-active-dc-output-controller-monitor.patch
hwmon-smm665-driver-documentation.patch
hwmon-update-maintainers-for-smm665-driver.patch
hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors.patch
hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors-v3.patch

