From: akpm@linux-foundation.org
Subject: - hwmon-pc87360-separate-alarm-files-define-ldni_max-const.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:34:56 -0700
Message-ID: <200810202034.m9KKYul4010974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753636AbYJTUfg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:35:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jim.cromie@gmail.com, khali@linux-fr.org, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     hwmon/pc87360 separate alarm files: define LDNI_MAX const
has been removed from the -mm tree.  Its filename was
     hwmon-pc87360-separate-alarm-files-define-ldni_max-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

