From: akpm@linux-foundation.org
Subject: + vfs-avoid-large-kmallocs-for-the-fdtable.patch added to -mm tree
Date: Wed, 13 Apr 2011 14:17:26 -0700
Message-ID: <201104132117.p3DLHQee000789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932094Ab1DMVS0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Apr 2011 17:18:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, azurit@pobox.sk, eric.dumazet@gmail.com, jslaby@suse.cz, mel@csn.ul.ie, stable@kernel.org, xiaosuo@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     vfs: avoid large kmalloc()s for the fdtable
has been added to the -mm tree.  Its filename is
     vfs-avoid-large-kmallocs-for-the-fdtable.patch

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
Subject: vfs: avoid large kmalloc()s for the fdtable
From: Andrew Morton <akpm@linux-foundation.org>

Azurit reports large increases in system time after 2.6.36 when running
Apache.  It was bisected down to a892e2d7dcdfa6c76e6 ("vfs: use kmalloc()
to allocate fdmem if possible").

That patch caused the vfs to use kmalloc() for very large allocations and
this is causing excessive work (and presumably excessive reclaim) within
the page allocator.

Fix it by falling back to vmalloc() earlier - when the allocation attempt
would have been considered "costly" by reclaim.

Reported-by: azurIt <azurit@pobox.sk>
Cc: Changli Gao <xiaosuo@gmail.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN fs/file.c~a fs/file.c
--- a/fs/file.c~a
+++ a/fs/file.c
@@ -39,14 +39,17 @@ int sysctl_nr_open_max = 1024 * 1024; /*
  */
 static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
 
-static inline void *alloc_fdmem(unsigned int size)
+static void *alloc_fdmem(unsigned int size)
 {
-	void *data;
-
-	data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
-	if (data != NULL)
-		return data;
-
+	/*
+	 * Very large allocations can stress page reclaim, so fall back to
+	 * vmalloc() if the allocation size will be considered "large" by the VM.
+	 */
+	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER) {
+		void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
+		if (data != NULL)
+			return data;
+	}
 	return vmalloc(size);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-thp-use-conventional-format-for-boolean-attributes-fix.patch
vfs-avoid-large-kmallocs-for-the-fdtable.patch
drivers-scsi-mpt2sas-mpt2sas_ctlc-fix-unbounded-copy_to_user.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
osst-wrong-index-used-in-inner-loop-checkpatch-fixes.patch
drbd-fix-warning.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
lib-genpoolc-document-return-values-fix-gen_pool_add_virt-return-value.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-tty-vt-vt_ioctlc-repair-insane-expression.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
dev-kmsg-properly-support-writev-to-avoid-interleaved-printk-lines-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

