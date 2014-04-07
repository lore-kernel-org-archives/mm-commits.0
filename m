From: akpm@linux-foundation.org
Subject: [folded-merged]
 initramfs-debug-detected-compression-method-fix.patch removed from -mm tree
Date: Mon, 07 Apr 2014 15:17:40 -0700
Message-ID: <53432404.D04OV7q+dmEuZt+b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaDGWRl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:17:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan@danweeks.net, akpm@linux-foundation.org

Subject: [folded-merged] initramfs-debug-detected-compression-method-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,dan@danweeks.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:17:40 -0700


The patch titled
     Subject: initramfs-debug-detected-compression-method-fix
has been removed from the -mm tree.  Its filename was
     initramfs-debug-detected-compression-method-fix.patch

This patch was dropped because it was folded into initramfs-debug-detected-compression-method.patch

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

origin.patch
mmnuma-reorganize-change_pmd_range.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-per-thread-vma-caching.patch
mm-use-macros-from-compilerh-instead-of-__attribute__.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-readaheadc-inline-ra_submit.patch
zram-use-zcomp-compressing-backends.patch
zram-return-error-valued-pointer-from-zcomp_create.patch
zram-propagate-error-to-user.patch
zram-support-req_discard.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch
initramfs-debug-detected-compression-method.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch

