From: akpm@linux-foundation.org
Subject: - drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:33 -0700
Message-ID: <200807141935.m6EJZXqp023929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756740AbYGNTfx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drx397xD demodulator driver: fix a const pointer assignment
has been removed from the -mm tree.  Its filename was
     drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drx397xD demodulator driver: fix a const pointer assignment
From: David Howells <dhowells@redhat.com>

Fix an assignment of a const pointer to a non-const pointer in the drx397xD
demodulator driver.

This was introduced in patch eb9bd0e567365d4f607d32d8c41e201da65aa971.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/drx397xD.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/media/dvb/frontends/drx397xD.c~drx397xd-demodulator-driver-fix-a-const-pointer-assignment drivers/media/dvb/frontends/drx397xD.c
--- a/drivers/media/dvb/frontends/drx397xD.c~drx397xd-demodulator-driver-fix-a-const-pointer-assignment
+++ a/drivers/media/dvb/frontends/drx397xD.c
@@ -73,7 +73,7 @@ static struct {
 	const struct firmware *file;
 	rwlock_t lock;
 	int refcnt;
-	u8 *data[ARRAY_SIZE(blob_name)];
+	const u8 *data[ARRAY_SIZE(blob_name)];
 } fw[] = {
 #define _FW_ENTRY(a, b)		{			\
 			.name	= a,			\
@@ -109,7 +109,7 @@ static void drx_release_fw(struct drx397
 
 static int drx_load_fw(struct drx397xD_state *s, fw_ix_t ix)
 {
-	u8 *data;
+	const u8 *data;
 	size_t size, len;
 	int i = 0, j, rc = -EINVAL;
 
@@ -193,7 +193,7 @@ static int drx_load_fw(struct drx397xD_s
 static int write_fw(struct drx397xD_state *s, blob_ix_t ix)
 {
 	struct i2c_msg msg = {.addr = s->config.demod_address,.flags = 0 };
-	u8 *data;
+	const u8 *data;
 	int len, rc = 0, i = 0;
 
 	if (ix < 0 || ix >= ARRAY_SIZE(blob_name)) {
@@ -214,7 +214,7 @@ static int write_fw(struct drx397xD_stat
 		case 0:	/* bytecode */
 			len = data[i++];
 			msg.len = len;
-			msg.buf = &data[i];
+			msg.buf = (__u8 *) &data[i];
 			if (i2c_transfer(s->i2c, &msg, 1) != 1) {
 				rc = -EIO;
 				goto exit_rc;
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
netfilter-fix-xt_times-time_mts-use-of-do_div.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
sched-fix-inc_rt_tasks-to-not-declare-variable-rq-if-its-not-needed.patch
git-unionfs.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
pm-fix-try_to_freeze_taskss-use-of-do_div.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
sdio-fix-break-control-to-now-return-success-or-an-error.patch
mn10300-fix-mn10300s-serial-port-driver-to-get-at-its-tty_struct.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops.patch
tsacct-fix-bacct_add_tsks-use-of-do_div.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

