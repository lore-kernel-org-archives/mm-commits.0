From: akpm@linux-foundation.org
Subject: [merged] fs-adfs-adfsh-fix-unsigned-comparison.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:23:25 -0700
Message-ID: <201103250723.p2P7NJnv025718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933032Ab1CYHXh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:23:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, geert@linux-m68k.org, rmk+kernel@arm.linux.org.uk, stuart.swales.croftnuisk@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs/adfs/adfs.h: fix unsigned comparison
has been removed from the -mm tree.  Its filename was
     fs-adfs-adfsh-fix-unsigned-comparison.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/adfs/adfs.h: fix unsigned comparison
From: Andrew Morton <akpm@linux-foundation.org>

fs/adfs/adfs.h: In function 'append_filetype_suffix':
fs/adfs/adfs.h:115: warning: comparison is always false due to limited range of data type

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stuart Swales <stuart.swales.croftnuisk@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/adfs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/adfs/adfs.h~fs-adfs-adfsh-fix-unsigned-comparison fs/adfs/adfs.h
--- a/fs/adfs/adfs.h~fs-adfs-adfsh-fix-unsigned-comparison
+++ a/fs/adfs/adfs.h
@@ -112,7 +112,7 @@ struct object_info {
 /* RISC OS 12-bit filetype converts to ,xyz hex filename suffix */
 static inline int append_filetype_suffix(char *buf, __u16 filetype)
 {
-	if (filetype == -1)
+	if (filetype == 0xffff)	/* no explicit 12-bit file type was set */
 		return 0;
 
 	*buf++ = ',';
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix.patch
mm-add-vm-counters-for-transparent-hugepages-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

