From: akpm@osdl.org
Subject: - usbvision-possible-cleanups.patch removed from -mm tree
Date: Thu, 21 Dec 2006 12:10:18 -0800
Message-ID: <200612212010.kBLKAIXV003553@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36786 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423083AbWLUUNk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 15:13:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mchehab@infradead.org, thierry.merle@free.fr, mm-commits@vger.kernel.org


The patch titled
     usbvision: possible cleanups
has been removed from the -mm tree.  Its filename was
     usbvision-possible-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usbvision: possible cleanups
From: Adrian Bunk <bunk@stusta.de>

This patch contains the following possible cleanups:
- make needlessly global functions static
- remove the unused EXPORT_SYMBOL's

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Thierry MERLE <thierry.merle@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/video/usbvision/usbvision-core.c  |   33 ++++++++------
 drivers/media/video/usbvision/usbvision-i2c.c   |    5 --
 drivers/media/video/usbvision/usbvision-video.c |    2 
 drivers/media/video/usbvision/usbvision.h       |    2 
 4 files changed, 21 insertions(+), 21 deletions(-)

diff -puN drivers/media/video/usbvision/usbvision-core.c~usbvision-possible-cleanups drivers/media/video/usbvision/usbvision-core.c
--- a/drivers/media/video/usbvision/usbvision-core.c~usbvision-possible-cleanups
+++ a/drivers/media/video/usbvision/usbvision-core.c
@@ -118,7 +118,7 @@ static int usbvision_measure_bandwidth (
  * This is used when initializing the contents of the area.
  */
 
-void *usbvision_rvmalloc(unsigned long size)
+static void *usbvision_rvmalloc(unsigned long size)
 {
 	void *mem;
 	unsigned long adr;
@@ -181,7 +181,7 @@ static void usbvision_hexdump(const unsi
 /********************************
  * scratch ring buffer handling
  ********************************/
-int scratch_len(struct usb_usbvision *usbvision)    /*This returns the amount of data actually in the buffer */
+static int scratch_len(struct usb_usbvision *usbvision)    /*This returns the amount of data actually in the buffer */
 {
 	int len = usbvision->scratch_write_ptr - usbvision->scratch_read_ptr;
 	if (len < 0) {
@@ -194,7 +194,7 @@ int scratch_len(struct usb_usbvision *us
 
 
 /* This returns the free space left in the buffer */
-int scratch_free(struct usb_usbvision *usbvision)
+static int scratch_free(struct usb_usbvision *usbvision)
 {
 	int free = usbvision->scratch_read_ptr - usbvision->scratch_write_ptr;
 	if (free <= 0) {
@@ -211,7 +211,8 @@ int scratch_free(struct usb_usbvision *u
 
 
 /* This puts data into the buffer */
-int scratch_put(struct usb_usbvision *usbvision, unsigned char *data, int len)
+static int scratch_put(struct usb_usbvision *usbvision, unsigned char *data,
+		       int len)
 {
 	int len_part;
 
@@ -237,7 +238,7 @@ int scratch_put(struct usb_usbvision *us
 }
 
 /* This marks the write_ptr as position of new frame header */
-void scratch_mark_header(struct usb_usbvision *usbvision)
+static void scratch_mark_header(struct usb_usbvision *usbvision)
 {
 	PDEBUG(DBG_SCRATCH, "header at write_ptr=%d\n", usbvision->scratch_headermarker_write_ptr);
 
@@ -248,7 +249,8 @@ void scratch_mark_header(struct usb_usbv
 }
 
 /* This gets data from the buffer at the given "ptr" position */
-int scratch_get_extra(struct usb_usbvision *usbvision, unsigned char *data, int *ptr, int len)
+static int scratch_get_extra(struct usb_usbvision *usbvision,
+			     unsigned char *data, int *ptr, int len)
 {
 	int len_part;
 	if (*ptr + len < scratch_buf_size) {
@@ -274,7 +276,8 @@ int scratch_get_extra(struct usb_usbvisi
 
 
 /* This sets the scratch extra read pointer */
-void scratch_set_extra_ptr(struct usb_usbvision *usbvision, int *ptr, int len)
+static void scratch_set_extra_ptr(struct usb_usbvision *usbvision, int *ptr,
+				  int len)
 {
 	*ptr = (usbvision->scratch_read_ptr + len)%scratch_buf_size;
 
@@ -283,7 +286,7 @@ void scratch_set_extra_ptr(struct usb_us
 
 
 /*This increments the scratch extra read pointer */
-void scratch_inc_extra_ptr(int *ptr, int len)
+static void scratch_inc_extra_ptr(int *ptr, int len)
 {
 	*ptr = (*ptr + len) % scratch_buf_size;
 
@@ -292,7 +295,8 @@ void scratch_inc_extra_ptr(int *ptr, int
 
 
 /* This gets data from the buffer */
-int scratch_get(struct usb_usbvision *usbvision, unsigned char *data, int len)
+static int scratch_get(struct usb_usbvision *usbvision, unsigned char *data,
+		       int len)
 {
 	int len_part;
 	if (usbvision->scratch_read_ptr + len < scratch_buf_size) {
@@ -318,7 +322,8 @@ int scratch_get(struct usb_usbvision *us
 
 
 /* This sets read pointer to next header and returns it */
-int scratch_get_header(struct usb_usbvision *usbvision,struct usbvision_frame_header *header)
+static int scratch_get_header(struct usb_usbvision *usbvision,
+			      struct usbvision_frame_header *header)
 {
 	int errCode = 0;
 
@@ -346,7 +351,7 @@ int scratch_get_header(struct usb_usbvis
 
 
 /*This removes len bytes of old data from the buffer */
-void scratch_rm_old(struct usb_usbvision *usbvision, int len)
+static void scratch_rm_old(struct usb_usbvision *usbvision, int len)
 {
 
 	usbvision->scratch_read_ptr += len;
@@ -356,7 +361,7 @@ void scratch_rm_old(struct usb_usbvision
 
 
 /*This resets the buffer - kills all data in it too */
-void scratch_reset(struct usb_usbvision *usbvision)
+static void scratch_reset(struct usb_usbvision *usbvision)
 {
 	PDEBUG(DBG_SCRATCH, "\n");
 
@@ -399,8 +404,8 @@ void usbvision_scratch_free(struct usb_u
  *		1: Draw a colored grid
  *
  */
-void usbvision_testpattern(struct usb_usbvision *usbvision, int fullframe,
-			int pmode)
+static void usbvision_testpattern(struct usb_usbvision *usbvision,
+				  int fullframe, int pmode)
 {
 	static const char proc[] = "usbvision_testpattern";
 	struct usbvision_frame *frame;
diff -puN drivers/media/video/usbvision/usbvision-i2c.c~usbvision-possible-cleanups drivers/media/video/usbvision/usbvision-i2c.c
--- a/drivers/media/video/usbvision/usbvision-i2c.c~usbvision-possible-cleanups
+++ a/drivers/media/video/usbvision/usbvision-i2c.c
@@ -213,7 +213,7 @@ static struct i2c_algorithm i2c_usb_algo
 /*
  * registering functions to load algorithms at runtime
  */
-int usbvision_i2c_usb_add_bus(struct i2c_adapter *adap)
+static int usbvision_i2c_usb_add_bus(struct i2c_adapter *adap)
 {
 	PDEBUG(DBG_I2C, "I2C   debugging is enabled [i2c]");
 	PDEBUG(DBG_ALGO, "ALGO   debugging is enabled [i2c]");
@@ -559,9 +559,6 @@ static struct i2c_client i2c_client_temp
 	.name		= "usbvision internal",
 };
 
-EXPORT_SYMBOL(usbvision_i2c_usb_add_bus);
-EXPORT_SYMBOL(usbvision_i2c_usb_del_bus);
-
 /*
  * Overrides for Emacs so that we follow Linus's tabbing style.
  * ---------------------------------------------------------------------------
diff -puN drivers/media/video/usbvision/usbvision-video.c~usbvision-possible-cleanups drivers/media/video/usbvision/usbvision-video.c
--- a/drivers/media/video/usbvision/usbvision-video.c~usbvision-possible-cleanups
+++ a/drivers/media/video/usbvision/usbvision-video.c
@@ -1884,7 +1884,7 @@ static struct usb_driver usbvision_drive
  * This procedure preprocesses CustomDevice parameter if any
  *
  */
-void customdevice_process(void)
+static void customdevice_process(void)
 {
 	usbvision_device_data[0]=usbvision_device_data[1];
 	usbvision_table[0]=usbvision_table[1];
diff -puN drivers/media/video/usbvision/usbvision.h~usbvision-possible-cleanups drivers/media/video/usbvision/usbvision.h
--- a/drivers/media/video/usbvision/usbvision.h~usbvision-possible-cleanups
+++ a/drivers/media/video/usbvision/usbvision.h
@@ -489,7 +489,6 @@ struct usb_usbvision {
 /* i2c-algo-usb declaration                                        */
 /* --------------------------------------------------------------- */
 
-int usbvision_i2c_usb_add_bus(struct i2c_adapter *);
 int usbvision_i2c_usb_del_bus(struct i2c_adapter *);
 
 static inline void *i2c_get_algo_usb_data (struct i2c_algo_usb_data *dev)
@@ -510,7 +509,6 @@ int usbvision_init_i2c(struct usb_usbvis
 void call_i2c_clients(struct usb_usbvision *usbvision, unsigned int cmd,void *arg);
 
 /* defined in usbvision-core.c                                      */
-void *usbvision_rvmalloc(unsigned long size);
 void usbvision_rvfree(void *mem, unsigned long size);
 int usbvision_read_reg(struct usb_usbvision *usbvision, unsigned char reg);
 int usbvision_write_reg(struct usb_usbvision *usbvision, unsigned char reg,
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
make-kernel-printkcignore_loglevel_setup-static.patch
fs-sysv-proper-prototypes-for-2-functions.patch
git-acpi.patch
git-alsa.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
remove-the-broken-skmc-driver.patch
git-net.patch
net-irda-proper-prototypes.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
arch-i386-kernel-e820c-should-include-asm-setuph.patch
arch-i386-kernel-cpu-mcheck-mcec-should-include-asm-mceh.patch
lumpy-reclaim-cleanup.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

