From: akpm@linux-foundation.org
Subject: + hwmon-pc87360-separate-alarm-files-define-ldni_max-const.patch added to -mm tree
Date: Wed, 10 Sep 2008 17:03:31 -0700
Message-ID: <200809110003.m8B03VkW001232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752304AbYIKADm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 20:03:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jim.cromie@gmail.com, khali@linux-fr.org, mhoffman@lightlink.com


The patch titled
     hwmon/pc87360 separate alarm files: define LDNI_MAX const
has been added to the -mm tree.  Its filename is
     hwmon-pc87360-separate-alarm-files-define-ldni_max-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon/pc87360 separate alarm files: define LDNI_MAX const
From: Jim Cromie <jim.cromie@gmail.com>

Driver handles 3 logical devices in fixed length array.  Give this a
define-d constant.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/pc87360.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/pc87360.c~hwmon-pc87360-separate-alarm-files-define-ldni_max-const drivers/hwmon/pc87360.c
--- a/drivers/hwmon/pc87360.c~hwmon-pc87360-separate-alarm-files-define-ldni_max-const
+++ a/drivers/hwmon/pc87360.c
@@ -75,7 +75,8 @@ MODULE_PARM_DESC(force_id, "Override the
 #define FSCM	0x09	/* Logical device: fans */
 #define VLM	0x0d	/* Logical device: voltages */
 #define TMS	0x0e	/* Logical device: temperatures */
-static const u8 logdev[3] = { FSCM, VLM, TMS };
+#define LDNI_MAX 3
+static const u8 logdev[LDNI_MAX] = { FSCM, VLM, TMS };
 
 #define LD_FAN		0
 #define LD_IN		1
@@ -1074,7 +1075,7 @@ static int __devinit pc87360_probe(struc
 	mutex_init(&data->update_lock);
 	platform_set_drvdata(pdev, data);
 
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < LDNI_MAX; i++) {
 		if (((data->address[i] = extra_isa[i]))
 		 && !request_region(extra_isa[i], PC87360_EXTENT,
 		 		    pc87360_driver.driver.name)) {
_

Patches currently in -mm which might be from jim.cromie@gmail.com are

hwmon-pc87360-separate-alarm-files-define-some-constants.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-define-ldni_max-const.patch
hwmon-pc87360-separate-alarm-files-add-dev_dbg-help.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch

