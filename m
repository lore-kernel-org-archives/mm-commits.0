From: akpm@linux-foundation.org
Subject: + dvb-bt8xx-dstc-make-code-static.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:17:42 -0800
Message-ID: <200711090417.lA94HhhU028893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50238 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756202AbXKIESI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:18:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, mchehab@infradead.org


The patch titled
     dvb/bt8xx/dst.c: make code static
has been added to the -mm tree.  Its filename is
     dvb-bt8xx-dstc-make-code-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dvb/bt8xx/dst.c: make code static
From: Adrian Bunk <bunk@kernel.org>

This patch makes the following needlessly global code static:
- dst_gpio_outb()
- dst_gpio_inb()
- rdc_8820_reset()
- dst_pio_enable()
- dst_command()
- struct tuner_list[]

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/bt8xx/dst.c        |   19 ++++++++-----------
 drivers/media/dvb/bt8xx/dst_common.h |    5 -----
 2 files changed, 8 insertions(+), 16 deletions(-)

diff -puN drivers/media/dvb/bt8xx/dst.c~dvb-bt8xx-dstc-make-code-static drivers/media/dvb/bt8xx/dst.c
--- a/drivers/media/dvb/bt8xx/dst.c~dvb-bt8xx-dstc-make-code-static
+++ a/drivers/media/dvb/bt8xx/dst.c
@@ -71,6 +71,7 @@ MODULE_PARM_DESC(dst_algo, "tuning algo:
 	}								\
 } while(0)
 
+static int dst_command(struct dst_state *state, u8 *data, u8 len);
 
 static void dst_packsize(struct dst_state *state, int psize)
 {
@@ -80,7 +81,8 @@ static void dst_packsize(struct dst_stat
 	bt878_device_control(state->bt, DST_IG_TS, &bits);
 }
 
-int dst_gpio_outb(struct dst_state *state, u32 mask, u32 enbb, u32 outhigh, int delay)
+static int dst_gpio_outb(struct dst_state *state, u32 mask, u32 enbb,
+			 u32 outhigh, int delay)
 {
 	union dst_gpio_packet enb;
 	union dst_gpio_packet bits;
@@ -109,9 +111,8 @@ int dst_gpio_outb(struct dst_state *stat
 
 	return 0;
 }
-EXPORT_SYMBOL(dst_gpio_outb);
 
-int dst_gpio_inb(struct dst_state *state, u8 *result)
+static int dst_gpio_inb(struct dst_state *state, u8 *result)
 {
 	union dst_gpio_packet rd_packet;
 	int err;
@@ -125,7 +126,6 @@ int dst_gpio_inb(struct dst_state *state
 
 	return 0;
 }
-EXPORT_SYMBOL(dst_gpio_inb);
 
 int rdc_reset_state(struct dst_state *state)
 {
@@ -145,7 +145,7 @@ int rdc_reset_state(struct dst_state *st
 }
 EXPORT_SYMBOL(rdc_reset_state);
 
-int rdc_8820_reset(struct dst_state *state)
+static int rdc_8820_reset(struct dst_state *state)
 {
 	dprintk(verbose, DST_DEBUG, 1, "Resetting DST");
 	if (dst_gpio_outb(state, RDC_8820_RESET, RDC_8820_RESET, 0, NO_DELAY) < 0) {
@@ -160,9 +160,8 @@ int rdc_8820_reset(struct dst_state *sta
 
 	return 0;
 }
-EXPORT_SYMBOL(rdc_8820_reset);
 
-int dst_pio_enable(struct dst_state *state)
+static int dst_pio_enable(struct dst_state *state)
 {
 	if (dst_gpio_outb(state, ~0, RDC_8820_PIO_0_ENABLE, 0, NO_DELAY) < 0) {
 		dprintk(verbose, DST_ERROR, 1, "dst_gpio_outb ERROR !");
@@ -172,7 +171,6 @@ int dst_pio_enable(struct dst_state *sta
 
 	return 0;
 }
-EXPORT_SYMBOL(dst_pio_enable);
 
 int dst_pio_disable(struct dst_state *state)
 {
@@ -611,7 +609,7 @@ static int dst_type_print(struct dst_sta
 	return 0;
 }
 
-struct tuner_types tuner_list[] = {
+static struct tuner_types tuner_list[] = {
 	{
 		.tuner_type = TUNER_TYPE_L64724,
 		.tuner_name = "L 64724",
@@ -1224,7 +1222,7 @@ static int dst_probe(struct dst_state *s
 	return 0;
 }
 
-int dst_command(struct dst_state *state, u8 *data, u8 len)
+static int dst_command(struct dst_state *state, u8 *data, u8 len)
 {
 	u8 reply;
 
@@ -1287,7 +1285,6 @@ error:
 	return -EIO;
 
 }
-EXPORT_SYMBOL(dst_command);
 
 static int dst_get_signal(struct dst_state *state)
 {
diff -puN drivers/media/dvb/bt8xx/dst_common.h~dvb-bt8xx-dstc-make-code-static drivers/media/dvb/bt8xx/dst_common.h
--- a/drivers/media/dvb/bt8xx/dst_common.h~dvb-bt8xx-dstc-make-code-static
+++ a/drivers/media/dvb/bt8xx/dst_common.h
@@ -165,10 +165,8 @@ struct dst_config
 };
 
 int rdc_reset_state(struct dst_state *state);
-int rdc_8820_reset(struct dst_state *state);
 
 int dst_wait_dst_ready(struct dst_state *state, u8 delay_mode);
-int dst_pio_enable(struct dst_state *state);
 int dst_pio_disable(struct dst_state *state);
 int dst_error_recovery(struct dst_state* state);
 int dst_error_bailout(struct dst_state *state);
@@ -177,9 +175,6 @@ int dst_comm_init(struct dst_state* stat
 int write_dst(struct dst_state *state, u8 * data, u8 len);
 int read_dst(struct dst_state *state, u8 * ret, u8 len);
 u8 dst_check_sum(u8 * buf, u32 len);
-int dst_gpio_outb(struct dst_state* state, u32 mask, u32 enbb, u32 outhigh, int delay);
-
-int dst_command(struct dst_state* state, u8 * data, u8 len);
 struct dst_state* dst_attach(struct dst_state* state, struct dvb_adapter *dvb_adapter);
 struct dvb_device *dst_ca_attach(struct dst_state *state, struct dvb_adapter *dvb_adapter);
 
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
