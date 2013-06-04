From: akpm@linux-foundation.org
Subject: [merged] w1-add-family-based-automatic-module-loading.patch
 removed from -mm tree
Date: Tue, 04 Jun 2013 13:05:15 -0700
Message-ID: <51ae487b.K6fzO7Gdz/9T+WWt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3FDUFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jun 2013 16:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zbr@ioremap.net, rob@landley.net, gregkh@linuxfoundation.org, alexander.stein@informatik.tu-chemnitz.de

Subject: [merged] w1-add-family-based-automatic-module-loading.patch removed from -mm tree
To: alexander.stein@informatik.tu-chemnitz.de,gregkh@linuxfoundation.org,rob@landley.net,zbr@ioremap.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Jun 2013 13:05:15 -0700


The patch titled
     Subject: w1: add family based automatic module loading
has been removed from the -mm tree.  Its filename was
     w1-add-family-based-automatic-module-loading.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Subject: w1: add family based automatic module loading

Allow the 1-wire bus to autoload the corresponding module for each slave
being attached.  This works similar to bluetooth protocols.

Signed-off-by: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/w1/w1.generic    |    4 ++--
 drivers/w1/slaves/w1_ds2408.c  |    1 +
 drivers/w1/slaves/w1_ds2413.c  |    1 +
 drivers/w1/slaves/w1_ds2423.c  |    1 +
 drivers/w1/slaves/w1_ds2431.c  |    1 +
 drivers/w1/slaves/w1_ds2433.c  |    1 +
 drivers/w1/slaves/w1_ds2760.c  |    1 +
 drivers/w1/slaves/w1_ds2780.c  |    1 +
 drivers/w1/slaves/w1_ds2781.c  |    1 +
 drivers/w1/slaves/w1_ds28e04.c |    1 +
 drivers/w1/slaves/w1_smem.c    |    2 ++
 drivers/w1/slaves/w1_therm.c   |    5 +++++
 drivers/w1/w1.c                |    2 ++
 13 files changed, 20 insertions(+), 2 deletions(-)

diff -puN Documentation/w1/w1.generic~w1-add-family-based-automatic-module-loading Documentation/w1/w1.generic
--- a/Documentation/w1/w1.generic~w1-add-family-based-automatic-module-loading
+++ a/Documentation/w1/w1.generic
@@ -25,8 +25,8 @@ When a w1 master driver registers with t
  - sysfs entries for that w1 master are created
  - the w1 bus is periodically searched for new slave devices
 
-When a device is found on the bus, w1 core checks if driver for its family is
-loaded. If so, the family driver is attached to the slave.
+When a device is found on the bus, w1 core tries to load the driver for its family
+and check if it is loaded. If so, the family driver is attached to the slave.
 If there is no driver for the family, default one is assigned, which allows to perform
 almost any kind of operations. Each logical operation is a transaction
 in nature, which can contain several (two or one) low-level operations.
diff -puN drivers/w1/slaves/w1_ds2408.c~w1-add-family-based-automatic-module-loading drivers/w1/slaves/w1_ds2408.c
--- a/drivers/w1/slaves/w1_ds2408.c~w1-add-family-based-automatic-module-loading
+++ a/drivers/w1/slaves/w1_ds2408.c
@@ -22,6 +22,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jean-Francois Dagenais <dagenaisj@sonatest.com>");
 MODULE_DESCRIPTION("w1 family 29 driver for DS2408 8 Pin IO");
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_DS2408));
 
 
 #define W1_F29_RETRIES		3
diff -puN drivers/w1/slaves/w1_ds2413.c~w1-add-family-based-automatic-module-loading drivers/w1/slaves/w1_ds2413.c
--- a/drivers/w1/slaves/w1_ds2413.c~w1-add-family-based-automatic-module-loading
+++ a/drivers/w1/slaves/w1_ds2413.c
@@ -23,6 +23,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mariusz Bialonczyk <manio@skyboo.net>");
 MODULE_DESCRIPTION("w1 family 3a driver for DS2413 2 Pin IO");
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_DS2413));
 
 #define W1_F3A_RETRIES                     3
 #define W1_F3A_FUNC_PIO_ACCESS_READ        0xF5
diff -puN drivers/w1/slaves/w1_ds2423.c~w1-add-family-based-automatic-module-loading drivers/w1/slaves/w1_ds2423.c
--- a/drivers/w1/slaves/w1_ds2423.c~w1-add-family-based-automatic-module-loading
+++ a/drivers/w1/slaves/w1_ds2423.c
@@ -164,3 +164,4 @@ module_exit(w1_f1d_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mika Laitio <lamikr@pilppa.org>");
 MODULE_DESCRIPTION("w1 family 1d driver for DS2423, 4 counters and 4kb ram");
+MODULE_ALIAS("w1-family-" __stringify(W1_COUNTER_DS2423));
diff -puN drivers/w1/slaves/w1_ds2431.c~w1-add-family-based-automatic-module-loading drivers/w1/slaves/w1_ds2431.c
--- a/drivers/w1/slaves/w1_ds2431.c~w1-add-family-based-automatic-module-loading
+++ a/drivers/w1/slaves/w1_ds2431.c
@@ -310,3 +310,4 @@ module_exit(w1_f2d_fini);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Bernhard Weirich <bernhard.weirich@riedel.net>");
 MODULE_DESCRIPTION("w1 family 2d driver for DS2431, 1kb EEPROM");
+MODULE_ALIAS("w1-family-" __stringify(W1_EEPROM_DS2431));
diff -puN drivers/w1/slaves/w1_ds2433.c~w1-add-family-based-automatic-module-loading drivers/w1/slaves/w1_ds2433.c
--- a/drivers/w1/slaves/w1_ds2433.c~w1-add-family-based-automatic-module-loading
+++ a/drivers/w1/slaves/w1_ds2433.c
@@ -29,6 +29,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ben Gardner <bgardner@wabtec.com>");
 MODULE_DESCRIPTION("w1 family 23 driver for DS2433, 4kb EEPROM");
+MODULE_ALIAS("w1-family-" __stringify(W1_EEPROM_DS2433));
 
 #define W1_EEPROM_SIZE		512
 #define W1_PAGE_COUNT		16
diff -puN drivers/w1/slaves/w1_ds2760.c~w1-add-family-based-automatic-module-loading drivers/w1/slaves/w1_ds2760.c
--- a/drivers/w1/slaves/w1_ds2760.c~w1-add-family-based-automatic-module-loading
+++ a/drivers/w1/slaves/w1_ds2760.c
@@ -203,3 +203,4 @@ module_exit(w1_ds2760_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>");
 MODULE_DESCRIPTION("1-wire Driver Dallas 2760 battery monitor chip");
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_DS2760));
diff -puN drivers/w1/slaves/w1_ds2780.c~w1-add-family-based-automatic-module-loading drivers/w1/slaves/w1_ds2780.c
--- a/drivers/w1/slaves/w1_ds2780.c~w1-add-family-based-automatic-module-loading
+++ a/drivers/w1/slaves/w1_ds2780.c
@@ -188,3 +188,4 @@ module_exit(w1_ds2780_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Clifton Barnes <cabarnes@indesign-llc.com>");
 MODULE_DESCRIPTION("1-wire Driver for Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC");
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_DS2780));
diff -puN drivers/w1/slaves/w1_ds2781.c~w1-add-family-based-automatic-module-loading drivers/w1/slaves/w1_ds2781.c
--- a/drivers/w1/slaves/w1_ds2781.c~w1-add-family-based-automatic-module-loading
+++ a/drivers/w1/slaves/w1_ds2781.c
@@ -186,3 +186,4 @@ module_exit(w1_ds2781_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Renata Sayakhova <renata@oktetlabs.ru>");
 MODULE_DESCRIPTION("1-wire Driver for Maxim/Dallas DS2781 Stand-Alone Fuel Gauge IC");
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_DS2781));
diff -puN drivers/w1/slaves/w1_ds28e04.c~w1-add-family-based-automatic-module-loading drivers/w1/slaves/w1_ds28e04.c
--- a/drivers/w1/slaves/w1_ds28e04.c~w1-add-family-based-automatic-module-loading
+++ a/drivers/w1/slaves/w1_ds28e04.c
@@ -27,6 +27,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Markus Franke <franke.m@sebakmt.com>, <franm@hrz.tu-chemnitz.de>");
 MODULE_DESCRIPTION("w1 family 1C driver for DS28E04, 4kb EEPROM and PIO");
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_DS28E04));
 
 /* Allow the strong pullup to be disabled, but default to enabled.
  * If it was disabled a parasite powered device might not get the required
diff -puN drivers/w1/slaves/w1_smem.c~w1-add-family-based-automatic-module-loading drivers/w1/slaves/w1_smem.c
--- a/drivers/w1/slaves/w1_smem.c~w1-add-family-based-automatic-module-loading
+++ a/drivers/w1/slaves/w1_smem.c
@@ -34,6 +34,8 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
 MODULE_DESCRIPTION("Driver for 1-wire Dallas network protocol, 64bit memory family.");
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_SMEM_01));
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_SMEM_81));
 
 static struct w1_family w1_smem_family_01 = {
 	.fid = W1_FAMILY_SMEM_01,
diff -puN drivers/w1/slaves/w1_therm.c~w1-add-family-based-automatic-module-loading drivers/w1/slaves/w1_therm.c
--- a/drivers/w1/slaves/w1_therm.c~w1-add-family-based-automatic-module-loading
+++ a/drivers/w1/slaves/w1_therm.c
@@ -36,6 +36,11 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
 MODULE_DESCRIPTION("Driver for 1-wire Dallas network protocol, temperature family.");
+MODULE_ALIAS("w1-family-" __stringify(W1_THERM_DS18S20));
+MODULE_ALIAS("w1-family-" __stringify(W1_THERM_DS1822));
+MODULE_ALIAS("w1-family-" __stringify(W1_THERM_DS18B20));
+MODULE_ALIAS("w1-family-" __stringify(W1_THERM_DS1825));
+MODULE_ALIAS("w1-family-" __stringify(W1_THERM_DS28EA00));
 
 /* Allow the strong pullup to be disabled, but default to enabled.
  * If it was disabled a parasite powered device might not get the require
diff -puN drivers/w1/w1.c~w1-add-family-based-automatic-module-loading drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-add-family-based-automatic-module-loading
+++ a/drivers/w1/w1.c
@@ -680,6 +680,8 @@ static int w1_attach_slave_device(struct
 	atomic_set(&sl->refcnt, 0);
 	init_completion(&sl->released);
 
+	request_module("w1-family-0x%0x", rn->family);
+
 	spin_lock(&w1_flock);
 	f = w1_family_registered(rn->family);
 	if (!f) {
_

Patches currently in -mm which might be from alexander.stein@informatik.tu-chemnitz.de are

linux-next.patch

