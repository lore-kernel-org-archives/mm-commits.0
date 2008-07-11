From: akpm@linux-foundation.org
Subject: + drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:37:31 -0700
Message-ID: <200807111843.m6BIhCMh030786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755975AbYGKSn4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:43:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, mchehab@infradead.org


The patch titled
     drx397xD demodulator driver: fix a const pointer assignment
has been added to the -mm tree.  Its filename is
     drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
acpi-fix-build-with-config_pm_sleep=n.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
alsa-fix-a-const-pointer-usage-warning-in-the-digigram-pcxhr-soundcard-driver.patch
alsa-fix-a-const-pointer-usage-warning-in-the-digigram-mixart-soundcard-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
ivtv-framebuffer-driver-fix-pointer-cast-warnings.patch
drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch
mtd-fix-const-assignment-in-the-command-line-partitioning-driver.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
git-unionfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
sdio-fix-break-control-to-now-return-success-or-an-error.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
fix-a-const-assignment-in-moxa_load_fw.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

