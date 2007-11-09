From: akpm@linux-foundation.org
Subject: + media-video-et61x251-make-5-functions-static.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:18:34 -0800
Message-ID: <200711090418.lA94IZSB028937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51081 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754652AbXKIES7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:18:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, mchehab@infradead.org


The patch titled
     media/video/et61x251/: make 5 functions static
has been added to the -mm tree.  Its filename is
     media-video-et61x251-make-5-functions-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: media/video/et61x251/: make 5 functions static
From: Adrian Bunk <bunk@kernel.org>

Make the following needlessly global functions in et61x251_core.c static:

- et61x251_read_reg()
- et61x251_i2c_try_read()
- et61x251_i2c_try_write()
- et61x251_i2c_read()
- et61x251_i2c_write()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/et61x251/et61x251_core.c   |   20 +++++++--------
 drivers/media/video/et61x251/et61x251_sensor.h |    8 ------
 2 files changed, 10 insertions(+), 18 deletions(-)

diff -puN drivers/media/video/et61x251/et61x251_core.c~media-video-et61x251-make-5-functions-static drivers/media/video/et61x251/et61x251_core.c
--- a/drivers/media/video/et61x251/et61x251_core.c~media-video-et61x251-make-5-functions-static
+++ a/drivers/media/video/et61x251/et61x251_core.c
@@ -227,7 +227,7 @@ int et61x251_write_reg(struct et61x251_d
 }
 
 
-int et61x251_read_reg(struct et61x251_device* cam, u16 index)
+static int et61x251_read_reg(struct et61x251_device* cam, u16 index)
 {
 	struct usb_device* udev = cam->usbdev;
 	u8* buff = cam->control_buffer;
@@ -268,9 +268,9 @@ et61x251_i2c_wait(struct et61x251_device
 }
 
 
-int
-et61x251_i2c_try_read(struct et61x251_device* cam,
-		      const struct et61x251_sensor* sensor, u8 address)
+static int et61x251_i2c_try_read(struct et61x251_device* cam,
+				 const struct et61x251_sensor* sensor,
+				 u8 address)
 {
 	struct usb_device* udev = cam->usbdev;
 	u8* data = cam->control_buffer;
@@ -301,10 +301,9 @@ et61x251_i2c_try_read(struct et61x251_de
 }
 
 
-int
-et61x251_i2c_try_write(struct et61x251_device* cam,
-		       const struct et61x251_sensor* sensor, u8 address,
-		       u8 value)
+static int et61x251_i2c_try_write(struct et61x251_device* cam,
+				  const struct et61x251_sensor* sensor,
+				  u8 address, u8 value)
 {
 	struct usb_device* udev = cam->usbdev;
 	u8* data = cam->control_buffer;
@@ -387,13 +386,14 @@ et61x251_i2c_raw_write(struct et61x251_d
 }
 
 
-int et61x251_i2c_read(struct et61x251_device* cam, u8 address)
+static int et61x251_i2c_read(struct et61x251_device* cam, u8 address)
 {
 	return et61x251_i2c_try_read(cam, &cam->sensor, address);
 }
 
 
-int et61x251_i2c_write(struct et61x251_device* cam, u8 address, u8 value)
+static int et61x251_i2c_write(struct et61x251_device* cam,
+			      u8 address, u8 value)
 {
 	return et61x251_i2c_try_write(cam, &cam->sensor, address, value);
 }
diff -puN drivers/media/video/et61x251/et61x251_sensor.h~media-video-et61x251-make-5-functions-static drivers/media/video/et61x251/et61x251_sensor.h
--- a/drivers/media/video/et61x251/et61x251_sensor.h~media-video-et61x251-make-5-functions-static
+++ a/drivers/media/video/et61x251/et61x251_sensor.h
@@ -52,14 +52,6 @@ et61x251_attach_sensor(struct et61x251_d
 /*****************************************************************************/
 
 extern int et61x251_write_reg(struct et61x251_device*, u8 value, u16 index);
-extern int et61x251_read_reg(struct et61x251_device*, u16 index);
-extern int et61x251_i2c_write(struct et61x251_device*, u8 address, u8 value);
-extern int et61x251_i2c_read(struct et61x251_device*, u8 address);
-extern int et61x251_i2c_try_write(struct et61x251_device*,
-				  const struct et61x251_sensor*, u8 address,
-				  u8 value);
-extern int et61x251_i2c_try_read(struct et61x251_device*,
-				 const struct et61x251_sensor*, u8 address);
 extern int et61x251_i2c_raw_write(struct et61x251_device*, u8 n, u8 data1,
 				  u8 data2, u8 data3, u8 data4, u8 data5,
 				  u8 data6, u8 data7, u8 data8, u8 address);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
lguest_userc-fix-memory-leak.patch
video-sis-fix-negative-array-index.patch
dvb-bt8xx-dstc-make-code-static.patch
dvb-usb-gp8pskc-if-0-gp8psk_bcm4500_reload.patch
dvb-usb-vp702xc-cleanups.patch
dvb-usb-make-some-debug-vars-static.patch
media-common-ir-functionsc-make-a-function-static.patch
cx88-mpegc-make-4-functions-static.patch
media-video-et61x251-make-5-functions-static.patch
git-hwmon.patch
fs-dlm-proper-prototypes.patch
make-jffs2_get_acl-static.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-netdev-all.patch
drivers-net-chelsio-if-0-unused-functions.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
proper-prototype-for-kernel-schedcmigration_init.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
usb-mon-mon_binc-cleanups.patch
xtensa-iss_net_setup-must-be-__init.patch
xtensa-kernel-setupc-remove-dead-code.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kernel-power-move-function-prototypes-to-header.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
power_supply_ledssysfsc-should-include-power_supplyh.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
