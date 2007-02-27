From: akpm@linux-foundation.org
Subject: + drivers-isdn-gigaset-mark-some-static-data-as-const-v2.patch added to -mm tree
Date: Tue, 27 Feb 2007 13:00:35 -0800
Message-ID: <200702272100.l1RL0dnl028476@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52037 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbXB0VAn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 16:00:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc, hjlipp@web.de


The patch titled
     drivers/isdn/gigaset: mark some static data as const (v2)
has been added to the -mm tree.  Its filename is
     drivers-isdn-gigaset-mark-some-static-data-as-const-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/isdn/gigaset: mark some static data as const (v2)
From: Tilman Schmidt <tilman@imap.cc>

Mark some static arrays as const that aren't and shouldn't be modified, and
remove incorrect static attribute from some variables.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Hansjoerg Lipp <hjlipp@web.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/bas-gigaset.c |    4 ++--
 drivers/isdn/gigaset/common.c      |    6 +++---
 drivers/isdn/gigaset/ev-layer.c    |    4 ++--
 drivers/isdn/gigaset/isocdata.c    |    4 ++--
 drivers/isdn/gigaset/ser-gigaset.c |    2 +-
 drivers/isdn/gigaset/usb-gigaset.c |    4 ++--
 6 files changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/isdn/gigaset/bas-gigaset.c~drivers-isdn-gigaset-mark-some-static-data-as-const-v2 drivers/isdn/gigaset/bas-gigaset.c
--- a/drivers/isdn/gigaset/bas-gigaset.c~drivers-isdn-gigaset-mark-some-static-data-as-const-v2
+++ a/drivers/isdn/gigaset/bas-gigaset.c
@@ -54,7 +54,7 @@ MODULE_PARM_DESC(cidmode, "Call-ID mode"
 #define USB_SX353_PRODUCT_ID    0x0022
 
 /* table of devices that work with this driver */
-static struct usb_device_id gigaset_table [] = {
+static const struct usb_device_id gigaset_table [] = {
 	{ USB_DEVICE(USB_GIGA_VENDOR_ID, USB_3070_PRODUCT_ID) },
 	{ USB_DEVICE(USB_GIGA_VENDOR_ID, USB_3075_PRODUCT_ID) },
 	{ USB_DEVICE(USB_GIGA_VENDOR_ID, USB_SX303_PRODUCT_ID) },
@@ -2305,7 +2305,7 @@ static void gigaset_disconnect(struct us
 	gigaset_unassign(cs);
 }
 
-static struct gigaset_ops gigops = {
+static const struct gigaset_ops gigops = {
 	gigaset_write_cmd,
 	gigaset_write_room,
 	gigaset_chars_in_buffer,
diff -puN drivers/isdn/gigaset/common.c~drivers-isdn-gigaset-mark-some-static-data-as-const-v2 drivers/isdn/gigaset/common.c
--- a/drivers/isdn/gigaset/common.c~drivers-isdn-gigaset-mark-some-static-data-as-const-v2
+++ a/drivers/isdn/gigaset/common.c
@@ -944,8 +944,8 @@ static DEFINE_SPINLOCK(driver_lock);
 struct cardstate *gigaset_get_cs_by_id(int id)
 {
 	unsigned long flags;
-	static struct cardstate *ret = NULL;
-	static struct cardstate *cs;
+	struct cardstate *ret = NULL;
+	struct cardstate *cs;
 	struct gigaset_driver *drv;
 	unsigned i;
 
@@ -999,7 +999,7 @@ void gigaset_debugdrivers(void)
 static struct cardstate *gigaset_get_cs_by_minor(unsigned minor)
 {
 	unsigned long flags;
-	static struct cardstate *ret = NULL;
+	struct cardstate *ret = NULL;
 	struct gigaset_driver *drv;
 	unsigned index;
 
diff -puN drivers/isdn/gigaset/ev-layer.c~drivers-isdn-gigaset-mark-some-static-data-as-const-v2 drivers/isdn/gigaset/ev-layer.c
--- a/drivers/isdn/gigaset/ev-layer.c~drivers-isdn-gigaset-mark-some-static-data-as-const-v2
+++ a/drivers/isdn/gigaset/ev-layer.c
@@ -409,7 +409,7 @@ static struct reply_t tab_cid[] = /* no 
 };
 #endif
 
-static struct resp_type_t resp_type[]=
+static const struct resp_type_t resp_type[] =
 {
 	/*{"",		RSP_EMPTY,	RT_NOTHING},*/
 	{"OK",		RSP_OK,		RT_NOTHING},
@@ -511,7 +511,7 @@ void gigaset_handle_modem_response(struc
 	unsigned char *argv[MAX_REC_PARAMS + 1];
 	int params;
 	int i, j;
-	struct resp_type_t *rt;
+	const struct resp_type_t *rt;
 	int curarg;
 	unsigned long flags;
 	unsigned next, tail, head;
diff -puN drivers/isdn/gigaset/isocdata.c~drivers-isdn-gigaset-mark-some-static-data-as-const-v2 drivers/isdn/gigaset/isocdata.c
--- a/drivers/isdn/gigaset/isocdata.c~drivers-isdn-gigaset-mark-some-static-data-as-const-v2
+++ a/drivers/isdn/gigaset/isocdata.c
@@ -274,7 +274,7 @@ static inline void dump_bytes(enum debug
  *        bit 12..10 = number of trailing '1' bits in result
  *        bit 14..13 = number of bits added by stuffing
  */
-static u16 stufftab[5 * 256] = {
+static const u16 stufftab[5 * 256] = {
 // previous 1s = 0:
  0x0000, 0x0001, 0x0002, 0x0003, 0x0004, 0x0005, 0x0006, 0x0007, 0x0008, 0x0009, 0x000a, 0x000b, 0x000c, 0x000d, 0x000e, 0x000f,
  0x0010, 0x0011, 0x0012, 0x0013, 0x0014, 0x0015, 0x0016, 0x0017, 0x0018, 0x0019, 0x001a, 0x001b, 0x001c, 0x001d, 0x001e, 0x201f,
@@ -629,7 +629,7 @@ static inline void hdlc_frag(struct bc_s
  *		     (replacing 8 by 7 to make it fit; the algorithm won't care)
  *        bit 7 set if there are 5 or more "interior" consecutive '1' bits
  */
-static unsigned char bitcounts[256] = {
+static const unsigned char bitcounts[256] = {
   0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x04,
   0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x05,
   0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x04,
diff -puN drivers/isdn/gigaset/ser-gigaset.c~drivers-isdn-gigaset-mark-some-static-data-as-const-v2 drivers/isdn/gigaset/ser-gigaset.c
--- a/drivers/isdn/gigaset/ser-gigaset.c~drivers-isdn-gigaset-mark-some-static-data-as-const-v2
+++ a/drivers/isdn/gigaset/ser-gigaset.c
@@ -459,7 +459,7 @@ static int gigaset_set_line_ctrl(struct 
 	return -EINVAL;
 }
 
-static struct gigaset_ops ops = {
+static const struct gigaset_ops ops = {
 	gigaset_write_cmd,
 	gigaset_write_room,
 	gigaset_chars_in_buffer,
diff -puN drivers/isdn/gigaset/usb-gigaset.c~drivers-isdn-gigaset-mark-some-static-data-as-const-v2 drivers/isdn/gigaset/usb-gigaset.c
--- a/drivers/isdn/gigaset/usb-gigaset.c~drivers-isdn-gigaset-mark-some-static-data-as-const-v2
+++ a/drivers/isdn/gigaset/usb-gigaset.c
@@ -50,7 +50,7 @@ MODULE_PARM_DESC(cidmode, "Call-ID mode"
 #define USB_M105_PRODUCT_ID	0x0009
 
 /* table of devices that work with this driver */
-static struct usb_device_id gigaset_table [] = {
+static const struct usb_device_id gigaset_table [] = {
 	{ USB_DEVICE(USB_M105_VENDOR_ID, USB_M105_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
@@ -860,7 +860,7 @@ static void gigaset_disconnect(struct us
 	gigaset_unassign(cs);
 }
 
-static struct gigaset_ops ops = {
+static const struct gigaset_ops ops = {
 	gigaset_write_cmd,
 	gigaset_write_room,
 	gigaset_chars_in_buffer,
_

Patches currently in -mm which might be from tilman@imap.cc are

drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module-fix.patch
drivers-isdn-gigaset-mark-some-static-data-as-const-v2.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch
