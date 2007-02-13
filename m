From: akpm@linux-foundation.org
Subject: + move-variables-in-drivers-macintosh-to-bss.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:37:31 -0800
Message-ID: <200702130537.l1D5bVhu022756@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55309 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161080AbXBMFhj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:37:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de, benh@kernel.crashing.org


The patch titled
     move variables in drivers/macintosh to bss
has been added to the -mm tree.  Its filename is
     move-variables-in-drivers-macintosh-to-bss.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: move variables in drivers/macintosh to bss
From: Olaf Hering <olaf@aepfle.de>

Move all the initialized variables to bss.  Mark a version string as const.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/adbhid.c        |    4 ++--
 drivers/macintosh/apm_emu.c       |    2 +-
 drivers/macintosh/mac_hid.c       |    4 ++--
 drivers/macintosh/therm_adt746x.c |    6 +++---
 drivers/macintosh/via-cuda.c      |    2 +-
 drivers/macintosh/via-macii.c     |   10 +++++-----
 drivers/macintosh/via-maciisi.c   |    6 +++---
 drivers/macintosh/via-pmu.c       |   11 +++++------
 drivers/macintosh/via-pmu68k.c    |    4 ++--
 9 files changed, 24 insertions(+), 25 deletions(-)

diff -puN drivers/macintosh/adbhid.c~move-variables-in-drivers-macintosh-to-bss drivers/macintosh/adbhid.c
--- a/drivers/macintosh/adbhid.c~move-variables-in-drivers-macintosh-to-bss
+++ a/drivers/macintosh/adbhid.c
@@ -574,8 +574,8 @@ static struct adb_request led_request;
 static int leds_pending[16];
 static int leds_req_pending;
 static int pending_devs[16];
-static int pending_led_start=0;
-static int pending_led_end=0;
+static int pending_led_start;
+static int pending_led_end;
 static DEFINE_SPINLOCK(leds_lock);
 
 static void leds_done(struct adb_request *req)
diff -puN drivers/macintosh/apm_emu.c~move-variables-in-drivers-macintosh-to-bss drivers/macintosh/apm_emu.c
--- a/drivers/macintosh/apm_emu.c~move-variables-in-drivers-macintosh-to-bss
+++ a/drivers/macintosh/apm_emu.c
@@ -102,7 +102,7 @@ static struct pmu_sleep_notifier apm_sle
 	SLEEP_LEVEL_USERLAND,
 };
 
-static char			driver_version[] = "0.5";	/* no spaces */
+static const char driver_version[] = "0.5";	/* no spaces */
 
 #ifdef DEBUG
 static char *	apm_event_name[] = {
diff -puN drivers/macintosh/mac_hid.c~move-variables-in-drivers-macintosh-to-bss drivers/macintosh/mac_hid.c
--- a/drivers/macintosh/mac_hid.c~move-variables-in-drivers-macintosh-to-bss
+++ a/drivers/macintosh/mac_hid.c
@@ -17,10 +17,10 @@
 
 static struct input_dev *emumousebtn;
 static int emumousebtn_input_register(void);
-static int mouse_emulate_buttons = 0;
+static int mouse_emulate_buttons;
 static int mouse_button2_keycode = KEY_RIGHTCTRL;	/* right control key */
 static int mouse_button3_keycode = KEY_RIGHTALT;	/* right option key */
-static int mouse_last_keycode = 0;
+static int mouse_last_keycode;
 
 #if defined(CONFIG_SYSCTL)
 /* file(s) in /proc/sys/dev/mac_hid */
diff -puN drivers/macintosh/therm_adt746x.c~move-variables-in-drivers-macintosh-to-bss drivers/macintosh/therm_adt746x.c
--- a/drivers/macintosh/therm_adt746x.c~move-variables-in-drivers-macintosh-to-bss
+++ a/drivers/macintosh/therm_adt746x.c
@@ -48,11 +48,11 @@ static u8 FAN_SPD_SET[2] = {0x30, 0x31};
 
 static u8 default_limits_local[3] = {70, 50, 70};    /* local, sensor1, sensor2 */
 static u8 default_limits_chip[3] = {80, 65, 80};    /* local, sensor1, sensor2 */
-static const char *sensor_location[3] = {NULL, NULL, NULL};
+static const char *sensor_location[3];
 
-static int limit_adjust = 0;
+static int limit_adjust;
 static int fan_speed = -1;
-static int verbose = 0;
+static int verbose;
 
 MODULE_AUTHOR("Colin Leroy <colin@colino.net>");
 MODULE_DESCRIPTION("Driver for ADT746x thermostat in iBook G4 and "
diff -puN drivers/macintosh/via-cuda.c~move-variables-in-drivers-macintosh-to-bss drivers/macintosh/via-cuda.c
--- a/drivers/macintosh/via-cuda.c~move-variables-in-drivers-macintosh-to-bss
+++ a/drivers/macintosh/via-cuda.c
@@ -86,7 +86,7 @@ static int data_index;
 #ifdef CONFIG_PPC
 static struct device_node *vias;
 #endif
-static int cuda_fully_inited = 0;
+static int cuda_fully_inited;
 
 #ifdef CONFIG_ADB
 static int cuda_probe(void);
diff -puN drivers/macintosh/via-macii.c~move-variables-in-drivers-macintosh-to-bss drivers/macintosh/via-macii.c
--- a/drivers/macintosh/via-macii.c~move-variables-in-drivers-macintosh-to-bss
+++ a/drivers/macintosh/via-macii.c
@@ -107,10 +107,10 @@ static enum macii_state {
 	awaiting_reply
 } macii_state;
 
-static int need_poll    = 0;
-static int command_byte = 0;
-static int last_reply   = 0;
-static int last_active  = 0;
+static int need_poll;
+static int command_byte;
+static int last_reply;
+static int last_active;
 
 static struct adb_request *current_req;
 static struct adb_request *last_req;
@@ -124,7 +124,7 @@ static int first_byte;
 static int prefix_len;
 static int status = ST_IDLE|TREQ;
 static int last_status;
-static int driver_running = 0;
+static int driver_running;
 
 /* debug level 10 required for ADB logging (should be && debug_adb, ideally) */
 
diff -puN drivers/macintosh/via-maciisi.c~move-variables-in-drivers-macintosh-to-bss drivers/macintosh/via-maciisi.c
--- a/drivers/macintosh/via-maciisi.c~move-variables-in-drivers-macintosh-to-bss
+++ a/drivers/macintosh/via-maciisi.c
@@ -63,10 +63,10 @@ static volatile unsigned char *via;
 
 #undef DEBUG_MACIISI_ADB
 
-static struct adb_request* current_req = NULL;
-static struct adb_request* last_req = NULL;
+static struct adb_request* current_req;
+static struct adb_request* last_req;
 static unsigned char maciisi_rbuf[16];
-static unsigned char *reply_ptr = NULL;
+static unsigned char *reply_ptr;
 static int data_index;
 static int reading_reply;
 static int reply_len;
diff -puN drivers/macintosh/via-pmu68k.c~move-variables-in-drivers-macintosh-to-bss drivers/macintosh/via-pmu68k.c
--- a/drivers/macintosh/via-pmu68k.c~move-variables-in-drivers-macintosh-to-bss
+++ a/drivers/macintosh/via-pmu68k.c
@@ -96,10 +96,10 @@ static int data_index;
 static int data_len;
 static int adb_int_pending;
 static int pmu_adb_flags;
-static int adb_dev_map = 0;
+static int adb_dev_map;
 static struct adb_request bright_req_1, bright_req_2, bright_req_3;
 static int pmu_kind = PMU_UNKNOWN;
-static int pmu_fully_inited = 0;
+static int pmu_fully_inited;
 
 int asleep;
 BLOCKING_NOTIFIER_HEAD(sleep_notifier_list);
diff -puN drivers/macintosh/via-pmu.c~move-variables-in-drivers-macintosh-to-bss drivers/macintosh/via-pmu.c
--- a/drivers/macintosh/via-pmu.c~move-variables-in-drivers-macintosh-to-bss
+++ a/drivers/macintosh/via-pmu.c
@@ -141,13 +141,13 @@ static volatile int adb_int_pending;
 static volatile int disable_poll;
 static struct device_node *vias;
 static int pmu_kind = PMU_UNKNOWN;
-static int pmu_fully_inited = 0;
+static int pmu_fully_inited;
 static int pmu_has_adb;
 static struct device_node *gpio_node;
-static unsigned char __iomem *gpio_reg = NULL;
+static unsigned char __iomem *gpio_reg;
 static int gpio_irq = NO_IRQ;
 static int gpio_irq_enabled = -1;
-static volatile int pmu_suspended = 0;
+static volatile int pmu_suspended;
 static spinlock_t pmu_lock;
 static u8 pmu_intr_mask;
 static int pmu_version;
@@ -180,7 +180,7 @@ int asleep;
 BLOCKING_NOTIFIER_HEAD(sleep_notifier_list);
 
 #ifdef CONFIG_ADB
-static int adb_dev_map = 0;
+static int adb_dev_map;
 static int pmu_adb_flags;
 
 static int pmu_probe(void);
@@ -2776,7 +2776,7 @@ pmu_polled_request(struct adb_request *r
 
 #if defined(CONFIG_PM) && defined(CONFIG_PPC32)
 
-static int pmu_sys_suspended = 0;
+static int pmu_sys_suspended;
 
 static int pmu_sys_suspend(struct sys_device *sysdev, pm_message_t state)
 {
@@ -2816,7 +2816,6 @@ static struct sysdev_class pmu_sysclass 
 };
 
 static struct sys_device device_pmu = {
-	.id		= 0,
 	.cls		= &pmu_sysclass,
 };
 
_

Patches currently in -mm which might be from olaf@aepfle.de are

origin.patch
move-variables-in-drivers-macintosh-to-bss.patch
add-delay-around-sl82c105_reset_engine-calls.patch
cleanup-variable-usage-in-mesh-interrupt-handler.patch
