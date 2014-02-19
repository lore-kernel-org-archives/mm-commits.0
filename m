From: akpm@linux-foundation.org
Subject: + initramfs-debug-detected-compression-method-fix.patch added to
 -mm tree
Date: Tue, 18 Feb 2014 16:12:40 -0800
Message-ID: <5303f6f8.8i6bGL8aoANfR0l7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaBSAMl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 19:12:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan@danweeks.net, akpm@linux-foundation.org

Subject: + initramfs-debug-detected-compression-method-fix.patch added to -mm tree
To: akpm@linux-foundation.org,dan@danweeks.net
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 16:12:40 -0800


The patch titled
     Subject: initramfs-debug-detected-compression-method-fix
has been added to the -mm tree.  Its filename is
     initramfs-debug-detected-compression-method-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initramfs-debug-detected-compression-method-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initramfs-debug-detected-compression-method-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: initramfs-debug-detected-compression-method-fix

use pr_debug()

Cc: Daniel M. Weeks <dan@danweeks.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    2 +-
 lib/decompress.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN init/initramfs.c~initramfs-debug-detected-compression-method-fix init/initramfs.c
--- a/init/initramfs.c~initramfs-debug-detected-compression-method-fix
+++ a/init/initramfs.c
@@ -455,7 +455,7 @@ static char * __init unpack_to_rootfs(ch
 		}
 		this_header = 0;
 		decompress = decompress_method(buf, len, &compress_name);
-		printk(KERN_DEBUG "Detected %s compressed data\n", compress_name);
+		pr_debug("Detected %s compressed data\n", compress_name);
 		if (decompress) {
 			res = decompress(buf, len, NULL, flush_buffer, NULL,
 				   &my_inptr, error);
diff -puN lib/decompress.c~initramfs-debug-detected-compression-method-fix lib/decompress.c
--- a/lib/decompress.c~initramfs-debug-detected-compression-method-fix
+++ a/lib/decompress.c
@@ -16,7 +16,6 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/init.h>
-
 #include <linux/printk.h>
 
 #ifndef CONFIG_DECOMPRESS_GZIP
@@ -63,7 +62,7 @@ decompress_fn __init decompress_method(c
 	if (len < 2)
 		return NULL;	/* Need at least this much... */
 
-	printk(KERN_DEBUG "Compressed data magic: %#.2x %#.2x\n", inbuf[0], inbuf[1]);
+	pr_debug("Compressed data magic: %#.2x %#.2x\n", inbuf[0], inbuf[1]);
 
 	for (cf = compressed_formats; cf->name; cf++) {
 		if (!memcmp(inbuf, cf->magic, 2))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
linux-next-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

