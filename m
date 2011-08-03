From: akpm@linux-foundation.org
Subject: [merged] drivers-acpi-apei-ghesc-fix-32-bit-build.patch removed from -mm tree
Date: Wed, 03 Aug 2011 11:59:42 -0700
Message-ID: <201108031857.p73IvCD8006714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755197Ab1HCS5o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 14:57:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, lenb@kernel.org, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/acpi/apei/ghes.c: fix 32-bit build
has been removed from the -mm tree.  Its filename was
     drivers-acpi-apei-ghesc-fix-32-bit-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/acpi/apei/ghes.c: fix 32-bit build
From: Andrew Morton <akpm@linux-foundation.org>

linux-next i386 allmodconfig:

drivers/built-in.o: In function `ghes_estatus_cache_add':
ghes.c:(.text+0xa6d27): undefined reference to `__udivdi3'

Remaining bugs are:

drivers/acpi/apei/ghes.c: In function 'ghes_estatus_cached':
drivers/acpi/apei/ghes.c:542: warning: integer overflow in expression
drivers/acpi/apei/ghes.c: In function 'ghes_estatus_cache_add':
drivers/acpi/apei/ghes.c:619: warning: integer overflow in expression

Cc: Len Brown <lenb@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/apei/ghes.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/apei/ghes.c~drivers-acpi-apei-ghesc-fix-32-bit-build drivers/acpi/apei/ghes.c
--- a/drivers/acpi/apei/ghes.c~drivers-acpi-apei-ghesc-fix-32-bit-build
+++ a/drivers/acpi/apei/ghes.c
@@ -622,7 +622,8 @@ static void ghes_estatus_cache_add(
 			break;
 		}
 		count = atomic_read(&cache->count);
-		period = duration / (count + 1);
+		period = duration;
+		do_div(period, count + 1);
 		if (period > max_period) {
 			max_period = period;
 			slot = i;
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

