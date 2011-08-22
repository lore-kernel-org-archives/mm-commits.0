From: akpm@linux-foundation.org
Subject: + vmscan-use-atomic-long-for-shrinker-batching-fix.patch added to -mm tree
Date: Mon, 22 Aug 2011 14:40:27 -0700
Message-ID: <201108222140.p7MLeR9C008015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668Ab1HVVlB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Aug 2011 17:41:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, david@fromorbit.com, khlebnikov@openvz.org


The patch titled
     vmscan-use-atomic-long-for-shrinker-batching-fix
has been added to the -mm tree.  Its filename is
     vmscan-use-atomic-long-for-shrinker-batching-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan-use-atomic-long-for-shrinker-batching-fix
From: Andrew Morton <akpm@linux-foundation.org>

massage atomic.h inclusions

Cc: Dave Chinner <david@fromorbit.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 include/linux/mm.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/fs.h~vmscan-use-atomic-long-for-shrinker-batching-fix include/linux/fs.h
--- a/include/linux/fs.h~vmscan-use-atomic-long-for-shrinker-batching-fix
+++ a/include/linux/fs.h
@@ -394,8 +394,8 @@ struct inodes_stat_t {
 #include <linux/semaphore.h>
 #include <linux/fiemap.h>
 #include <linux/rculist_bl.h>
-#include <linux/shrinker.h>
 #include <linux/atomic.h>
+#include <linux/shrinker.h>
 
 #include <asm/byteorder.h>
 
diff -puN include/linux/mm.h~vmscan-use-atomic-long-for-shrinker-batching-fix include/linux/mm.h
--- a/include/linux/mm.h~vmscan-use-atomic-long-for-shrinker-batching-fix
+++ a/include/linux/mm.h
@@ -10,6 +10,7 @@
 #include <linux/mmzone.h>
 #include <linux/rbtree.h>
 #include <linux/prio_tree.h>
+#include <linux/atomic.h>
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
 #include <linux/range.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
alpha-unbreak-osf_setsysinfossi_nvpairs-checkpatch-fixes.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
mm.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch
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

