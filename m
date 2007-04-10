From: akpm@linux-foundation.org
Subject: + input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes.patch added to -mm tree
Date: Mon, 09 Apr 2007 23:42:18 -0700
Message-ID: <200704100642.l3A6gIBS000927@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46094 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030417AbXDJGnM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 02:43:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dtor@insightbb.com, IvDoorn@gmail.com, davem@davemloft.net, dtor@mail.ru, linville@tuxdriver.com, marcel@holtmann.org


The patch titled
     input-rfkill-add-support-for-input-key-to-control-wireless-radio fixes
has been added to the -mm tree.  Its filename is
     input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: input-rfkill-add-support-for-input-key-to-control-wireless-radio fixes
From: Dmitry Torokhov <dtor@insightbb.com>

Well, Andrew found bunch of issues with the patch so here is an
updated version...

Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rfkill.h    |    2 ++
 net/rfkill/rfkill-input.c |   27 ++++++++++++++-------------
 net/rfkill/rfkill.c       |    6 ++++++
 3 files changed, 22 insertions(+), 13 deletions(-)

diff -puN include/linux/rfkill.h~input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes include/linux/rfkill.h
--- a/include/linux/rfkill.h~input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes
+++ a/include/linux/rfkill.h
@@ -21,6 +21,8 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/device.h>
 
 /**
diff -puN net/rfkill/rfkill-input.c~input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes net/rfkill/rfkill-input.c
--- a/net/rfkill/rfkill-input.c~input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes
+++ a/net/rfkill/rfkill-input.c
@@ -64,7 +64,7 @@ static void rfkill_schedule_toggle(struc
 	spin_unlock_irqrestore(&task->lock, flags);
 }
 
-#define DECLARE_RFKILL_TASK(n, t)			\
+#define DEFINE_RFKILL_TASK(n, t)			\
 	struct rfkill_task n = {			\
 		.work = __WORK_INITIALIZER(n.work,	\
 				rfkill_task_handler),	\
@@ -75,22 +75,22 @@ static void rfkill_schedule_toggle(struc
 		.current_state = RFKILL_STATE_ON,	\
 	}
 
-static DECLARE_RFKILL_TASK(rfkill_wlan, RFKILL_TYPE_WLAN);
-static DECLARE_RFKILL_TASK(rfkill_bt, RFKILL_TYPE_BLUETOOTH);
+static DEFINE_RFKILL_TASK(rfkill_wlan, RFKILL_TYPE_WLAN);
+static DEFINE_RFKILL_TASK(rfkill_bt, RFKILL_TYPE_BLUETOOTH);
 
 static void rfkill_event(struct input_handle *handle, unsigned int type,
 		        unsigned int code, int down)
 {
 	if (type == EV_KEY && down == 1) {
 		switch (code) {
-			case KEY_WLAN:
-				rfkill_schedule_toggle(&rfkill_wlan);
-				break;
-			case KEY_BLUETOOTH:
-				rfkill_schedule_toggle(&rfkill_bt);
-				break;
-			default:
-				break;
+		case KEY_WLAN:
+			rfkill_schedule_toggle(&rfkill_wlan);
+			break;
+		case KEY_BLUETOOTH:
+			rfkill_schedule_toggle(&rfkill_bt);
+			break;
+		default:
+			break;
 		}
 	}
 }
@@ -137,13 +137,14 @@ static const struct input_device_id rfki
 	{
 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
 		.evbit = { BIT(EV_KEY) },
-		.keybit = { [LONG(KEY_WLAN)] = BIT(KEY_WLAN) }
+		.keybit = { [LONG(KEY_WLAN)] = BIT(KEY_WLAN) },
 	},
 	{
 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
 		.evbit = { BIT(EV_KEY) },
-		.keybit = { [LONG(KEY_BLUETOOTH)] = BIT(KEY_BLUETOOTH) }
+		.keybit = { [LONG(KEY_BLUETOOTH)] = BIT(KEY_BLUETOOTH) },
 	},
+	{ }
 };
 
 static struct input_handler rfkill_handler = {
diff -puN net/rfkill/rfkill.c~input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes net/rfkill/rfkill.c
--- a/net/rfkill/rfkill.c~input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes
+++ a/net/rfkill/rfkill.c
@@ -199,6 +199,7 @@ static void rfkill_release(struct device
 	module_put(THIS_MODULE);
 }
 
+#ifdef CONFIG_PM
 static int rfkill_suspend(struct device *dev, pm_message_t state)
 {
 	struct rfkill *rfkill = to_rfkill(dev);
@@ -236,13 +237,16 @@ static int rfkill_resume(struct device *
 	dev->power.power_state = PMSG_ON;
 	return 0;
 }
+#endif
 
 static struct class rfkill_class = {
 	.name		= "rfkill",
 	.dev_release	= rfkill_release,
 	.dev_attrs	= rfkill_dev_attrs,
+#ifdef CONFIG_PM
 	.suspend	= rfkill_suspend,
 	.resume		= rfkill_resume,
+#endif
 };
 
 static int rfkill_add_switch(struct rfkill *rfkill)
@@ -302,6 +306,8 @@ struct rfkill *rfkill_allocate(struct de
 	dev->parent = parent;
 	device_initialize(dev);
 
+	__module_get(THIS_MODULE);
+
 	return rfkill;
 }
 EXPORT_SYMBOL(rfkill_allocate);
_

Patches currently in -mm which might be from dtor@insightbb.com are

git-input.patch
convert-input-core-to-struct-device.patch
add-locking-to-evdev.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-fix.patch
