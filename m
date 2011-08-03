From: akpm@linux-foundation.org
Subject: [merged] drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch removed from -mm tree
Date: Wed, 03 Aug 2011 12:00:07 -0700
Message-ID: <201108031857.p73Ivagi006747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755324Ab1HCS6R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 14:58:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjan@infradead.org, greg@kroah.com, w.d.hubbs@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/staging/speakup/devsynth.c: fix "buffer size is not provably correct" error
has been removed from the -mm tree.  Its filename was
     drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/staging/speakup/devsynth.c: fix "buffer size is not provably correct" error
From: Andrew Morton <akpm@linux-foundation.org>

x86_64 allmodconfig:

In file included from arch/x86/include/asm/uaccess.h:572,
                 from include/linux/uaccess.h:5,
                 from drivers/staging/speakup/devsynth.c:4:
In function 'copy_from_user',
    inlined from 'speakup_file_write' at drivers/staging/speakup/devsynth.c:28:
arch/x86/include/asm/uaccess_64.h:64: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct

I'm not sure what was unprovable about it, but size_t is the correct type
anyway.

Also replace needless min_t() with min()

Cc: William Hubbs <w.d.hubbs@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/speakup/devsynth.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/staging/speakup/devsynth.c~drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error drivers/staging/speakup/devsynth.c
--- a/drivers/staging/speakup/devsynth.c~drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error
+++ a/drivers/staging/speakup/devsynth.c
@@ -18,13 +18,14 @@ static ssize_t speakup_file_write(struct
 {
 	size_t count = nbytes;
 	const char *ptr = buffer;
-	int bytes;
+	size_t bytes;
 	unsigned long flags;
 	u_char buf[256];
+
 	if (synth == NULL)
 		return -ENODEV;
 	while (count > 0) {
-		bytes = min_t(size_t, count, sizeof(buf));
+		bytes = min(count, sizeof(buf));
 		if (copy_from_user(buf, ptr, bytes))
 			return -EFAULT;
 		count -= bytes;
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

