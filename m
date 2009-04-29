From: akpm@linux-foundation.org
Subject: [merged] input-add-a-detailed-multi-touch-finger-data-report-protocol-rev2.patch removed from -mm tree
Date: Wed, 29 Apr 2009 12:17:49 -0700
Message-ID: <200904291917.n3TJHn0Y030764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753112AbZD2T3t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 15:29:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: add a detailed multi-touch finger data report protocol
has been removed from the -mm tree.  Its filename was
     input-add-a-detailed-multi-touch-finger-data-report-protocol-rev2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: add a detailed multi-touch finger data report protocol
From: Henrik Rydberg <rydberg@euromail.se>

In order to utilize the full power of the new multi-touch devices, a way
to report detailed finger data to user space is needed.  This patch adds a
multi-touch (MT) protocol which allows drivers to report details for an
arbitrary number of fingers.

The driver sends a SYN_MT_REPORT event via the input_mt_sync() function
when a complete finger has been reported.

In order to stay compatible with existing applications, the data reported
in a finger packet must not be recognized as single-touch events.  In
addition, all finger data must bypass input filtering, since subsequent
events of the same type refer to different fingers.

A set of ABS_MT events with the desired properties are defined.  The
events are divided into categories, to allow for partial implementation. 
The minimum set consists of ABS_MT_TOUCH_MAJOR, ABS_MT_POSITION_X and
ABS_MT_POSITION_Y, which allows for multiple fingers to be tracked.  If
the device supports it, the ABS_MT_WIDTH_MAJOR may be used to provide the
size of the approaching finger.  Anisotropy and direction may be specified
with ABS_MT_TOUCH_MINOR, ABS_MT_WIDTH_MINOR and ABS_MT_ORIENTATION. 
Devices with more granular information may specify general shapes as
blobs, i.e., as a sequence of rectangular shapes grouped together by a
ABS_MT_BLOB_ID.  Finally, the ABS_MT_TOOL_TYPE may be used to specify
whether the touching tool is a finger or a pen.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/input.c |   13 +++++++++++++
 include/linux/input.h |   27 +++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff -puN drivers/input/input.c~input-add-a-detailed-multi-touch-finger-data-report-protocol-rev2 drivers/input/input.c
--- a/drivers/input/input.c~input-add-a-detailed-multi-touch-finger-data-report-protocol-rev2
+++ a/drivers/input/input.c
@@ -33,6 +33,15 @@ MODULE_LICENSE("GPL");
  * EV_ABS events which should not be cached are listed here.
  */
 static __initdata unsigned int input_abs_bypass_init_data[] = {
+	ABS_MT_TOUCH_MAJOR,
+	ABS_MT_TOUCH_MINOR,
+	ABS_MT_WIDTH_MAJOR,
+	ABS_MT_WIDTH_MINOR,
+	ABS_MT_ORIENTATION,
+	ABS_MT_POSITION_X,
+	ABS_MT_POSITION_Y,
+	ABS_MT_TOOL_TYPE,
+	ABS_MT_BLOB_ID,
 	0
 };
 
@@ -170,6 +179,10 @@ static void input_handle_event(struct in
 				disposition = INPUT_PASS_TO_HANDLERS;
 			}
 			break;
+		case SYN_MT_REPORT:
+			dev->sync = 0;
+			disposition = INPUT_PASS_TO_HANDLERS;
+			break;
 		}
 		break;
 
diff -puN include/linux/input.h~input-add-a-detailed-multi-touch-finger-data-report-protocol-rev2 include/linux/input.h
--- a/include/linux/input.h~input-add-a-detailed-multi-touch-finger-data-report-protocol-rev2
+++ a/include/linux/input.h
@@ -106,6 +106,7 @@ struct input_absinfo {
 
 #define SYN_REPORT		0
 #define SYN_CONFIG		1
+#define SYN_MT_REPORT		2
 
 /*
  * Keys and buttons
@@ -646,6 +647,19 @@ struct input_absinfo {
 #define ABS_TOOL_WIDTH		0x1c
 #define ABS_VOLUME		0x20
 #define ABS_MISC		0x28
+
+#define ABS_MT_TOUCH		0x30	/* Diameter of touching circle */
+#define ABS_MT_TOUCH_MAJOR	0x30	/* Major axis of touching ellipse */
+#define ABS_MT_TOUCH_MINOR	0x31	/* Minor axis of touching ellipse */
+#define ABS_MT_WIDTH		0x32	/* Diameter of approaching circle */
+#define ABS_MT_WIDTH_MAJOR	0x32	/* Major axis of approaching ellipse */
+#define ABS_MT_WIDTH_MINOR	0x33	/* Minor axis of approaching ellipse */
+#define ABS_MT_ORIENTATION	0x34	/* Ellipse orientation */
+#define ABS_MT_POSITION_X	0x35	/* Center X ellipse position */
+#define ABS_MT_POSITION_Y	0x36	/* Center Y ellipse position */
+#define ABS_MT_TOOL_TYPE	0x37	/* Type of touching device */
+#define ABS_MT_BLOB_ID		0x38	/* Group a set of packets as a blob */
+
 #define ABS_MAX			0x3f
 #define ABS_CNT			(ABS_MAX+1)
 
@@ -745,6 +759,14 @@ struct input_absinfo {
 #define BUS_ATARI		0x1B
 
 /*
+ * MT_TOOL types
+ */
+#define MT_TOOL_FINGER		0
+#define MT_TOOL_PEN		1
+#define MT_TOOL_MAX		9
+#define MT_TOOL_CNT		(MT_TOOL_MAX + 1)
+
+/*
  * Values describing the status of a force-feedback effect
  */
 #define FF_STATUS_STOPPED	0x00
@@ -1313,6 +1335,11 @@ static inline void input_sync(struct inp
 	input_event(dev, EV_SYN, SYN_REPORT, 0);
 }
 
+static inline void input_mt_sync(struct input_dev *dev)
+{
+	input_event(dev, EV_SYN, SYN_MT_REPORT, 0);
+}
+
 void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int code);
 
 static inline void input_set_abs_params(struct input_dev *dev, int axis, int min, int max, int fuzz, int flat)
_

Patches currently in -mm which might be from rydberg@euromail.se are

linux-next.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch

