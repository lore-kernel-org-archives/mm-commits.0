From: akpm@linux-foundation.org
Subject: [merged] drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value.patch removed from -mm tree
Date: Wed, 03 Aug 2011 12:00:05 -0700
Message-ID: <201108031857.p73IvYmC006744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755371Ab1HCS6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 14:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ale.goujon@gmail.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     drivers/cdrom/cdrom.c: relax check on dvd manufacturer value
has been removed from the -mm tree.  Its filename was
     drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/cdrom/cdrom.c: relax check on dvd manufacturer value
From: Andrew Morton <akpm@linux-foundation.org>

The report has an ISO which has a very long manufacturer ID.  It seems
that Linux is wrong, not the ISO maker.

Relax the check for the length of this field: emit a warning and truncate
the incoming data to 2048 bytes rather than rejecting the entire thing.

dvd_manufact.value isn't null-terminated.  I'm not even sure if it's a
string.  The kernel doesn't apepar to use it anyway.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=39062

Reported-by: <ale.goujon@gmail.com>
Tested-by: <ale.goujon@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/cdrom.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/cdrom/cdrom.c~drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value
+++ a/drivers/cdrom/cdrom.c
@@ -1929,11 +1929,17 @@ static int dvd_read_manufact(struct cdro
 		goto out;
 
 	s->manufact.len = buf[0] << 8 | buf[1];
-	if (s->manufact.len < 0 || s->manufact.len > 2048) {
+	if (s->manufact.len < 0) {
 		cdinfo(CD_WARNING, "Received invalid manufacture info length"
 				   " (%d)\n", s->manufact.len);
 		ret = -EIO;
 	} else {
+		if (s->manufact.len > 2048) {
+			cdinfo(CD_WARNING, "Received invalid manufacture info "
+					"length (%d): truncating to 2048\n",
+					s->manufact.len);
+			s->manufact.len = 2048;
+		}
 		memcpy(s->manufact.value, &buf[4], s->manufact.len);
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-mrst-pmuc-needs-moduleh.patch
cris-fix-a-build-error-in-kernel-forkc.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

