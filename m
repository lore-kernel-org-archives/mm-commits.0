From: akpm@linux-foundation.org
Subject: + rtc-driver-for-pt7c4338-chip-fix.patch added to -mm tree
Date: Tue, 08 Mar 2011 16:31:22 -0800
Message-ID: <201103090031.p290VMKx003847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756604Ab1CIAcA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Mar 2011 19:32:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Priyanka.Jain@freescale.com, a.zummo@towertech.it, benh@kernel.crashing.org, galak@gate.crashing.org


The patch titled
     rtc-driver-for-pt7c4338-chip-fix
has been added to the -mm tree.  Its filename is
     rtc-driver-for-pt7c4338-chip-fix.patch

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
Subject: rtc-driver-for-pt7c4338-chip-fix
From: Andrew Morton <akpm@linux-foundation.org>

include slab.h, remove unused local

drivers/rtc/rtc-pt7c4338.c: In function 'pt7c4338_probe':
drivers/rtc/rtc-pt7c4338.c:159: error: implicit declaration of function 'kzalloc'
drivers/rtc/rtc-pt7c4338.c:159: warning: assignment makes pointer from integer without a cast
drivers/rtc/rtc-pt7c4338.c:176: error: implicit declaration of function 'kfree'
drivers/rtc/rtc-pt7c4338.c:156: warning: unused variable 'adapter'

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Priyanka Jain <Priyanka.Jain@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pt7c4338.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pt7c4338.c~rtc-driver-for-pt7c4338-chip-fix drivers/rtc/rtc-pt7c4338.c
--- a/drivers/rtc/rtc-pt7c4338.c~rtc-driver-for-pt7c4338-chip-fix
+++ a/drivers/rtc/rtc-pt7c4338.c
@@ -35,6 +35,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/rtc.h>
@@ -153,7 +154,6 @@ static int pt7c4338_probe(struct i2c_cli
 		const struct i2c_device_id *id)
 {
 	struct pt7c4338 *pt7c4338;
-	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	int ret;
 
 	pt7c4338 = kzalloc(sizeof(struct pt7c4338), GFP_KERNEL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-usb-serial-usb_wwanc-unbork.patch
mm-vmap-area-cache.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix.patch
mm-add-__gfp_other_node-flag-checkpatch-fixes.patch
mm-use-__gfp_other_node-for-transparent-huge-pages-checkpatch-fixes.patch
mm-add-vm-counters-for-transparent-hugepages-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-fix.patch
memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp-checkpatch-fixes.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

