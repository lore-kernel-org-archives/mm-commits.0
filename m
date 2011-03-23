From: akpm@linux-foundation.org
Subject: + fs-adfs-adfsh-fix-unsigned-comparison.patch added to -mm tree
Date: Wed, 23 Mar 2011 13:52:24 -0700
Message-ID: <201103232056.p2NKu0Hr029689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933329Ab1CWU4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:56:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, geert@linux-m68k.org, rmk+kernel@arm.linux.org.uk, stuart.swales.croftnuisk@gmail.com


The patch titled
     fs/adfs/adfs.h: fix unsigned comparison
has been added to the -mm tree.  Its filename is
     fs-adfs-adfsh-fix-unsigned-comparison.patch

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
+	if (filetype == (__u16)-1)
 		return 0;
 
 	*buf++ = ',';
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-adfs-adfsh-fix-unsigned-comparison.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-usb-serial-usb_wwanc-unbork.patch
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
memcg-change-page_cgroup_zoneinfo-signature-fix.patch
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
scatterlist-new-helper-functions-update-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

