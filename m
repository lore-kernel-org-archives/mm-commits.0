From: akpm@linux-foundation.org
Subject: + block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages-checkpatch-fixes.patch added to -mm tree
Date: Wed, 25 Nov 2009 12:50:53 -0800
Message-ID: <200911252050.nAPKorkv032025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934993AbZKYUvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Nov 2009 15:51:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dwmw2@infradead.org, ecashin@coraid.com, isloginov@gmail.com, jens.axboe@oracle.com, mingo@elte.hu, phorton@bitbox.co.uk


The patch titled
     block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages-checkpatch-fixes.patch

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
Subject: block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo* bar" should be "foo *bar"
#348: FILE: block/blk-core.c:2372:
+	struct bio_vec* bvec;

ERROR: "foo* bar" should be "foo *bar"
#388: FILE: fs/bio.c:1400:
+	struct bio_vec* bvec;

WARNING: line over 80 characters
#419: FILE: include/linux/bio.h:396:
+# error	"You should to define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform."

WARNING: line over 80 characters
#440: FILE: include/linux/blkdev.h:756:
+# error	"You should to define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform."

total: 2 errors, 2 warnings, 278 lines checked

./patches/block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Ed L. Cashin" <ecashin@coraid.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ilya Loginov <isloginov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Horton <phorton@bitbox.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c       |    2 +-
 fs/bio.c               |    2 +-
 include/linux/bio.h    |    2 +-
 include/linux/blkdev.h |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN block/blk-core.c~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages-checkpatch-fixes block/blk-core.c
--- a/block/blk-core.c~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages-checkpatch-fixes
+++ a/block/blk-core.c
@@ -2369,7 +2369,7 @@ void blk_rq_bio_prep(struct request_queu
 void rq_flush_dcache_pages(struct request *rq)
 {
 	struct req_iterator iter;
-	struct bio_vec* bvec;
+	struct bio_vec *bvec;
 
 	rq_for_each_segment(bvec, rq, iter)
 		flush_dcache_page(bvec->bv_page);
diff -puN fs/bio.c~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages-checkpatch-fixes fs/bio.c
--- a/fs/bio.c~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages-checkpatch-fixes
+++ a/fs/bio.c
@@ -1397,7 +1397,7 @@ void bio_check_pages_dirty(struct bio *b
 void bio_flush_dcache_pages(struct bio *bi)
 {
 	int i;
-	struct bio_vec* bvec;
+	struct bio_vec *bvec;
 
 	bio_for_each_segment(bvec, bi, i)
 		flush_dcache_page(bvec->bv_page);
diff -puN include/linux/bio.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages-checkpatch-fixes include/linux/bio.h
--- a/include/linux/bio.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages-checkpatch-fixes
+++ a/include/linux/bio.h
@@ -393,7 +393,7 @@ extern void bio_set_pages_dirty(struct b
 extern void bio_check_pages_dirty(struct bio *bio);
 
 #ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
-# error	"You should to define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform."
+# error	"You should define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform"
 #endif
 #if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
 extern void bio_flush_dcache_pages(struct bio *bi);
diff -puN include/linux/blkdev.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages-checkpatch-fixes include/linux/blkdev.h
--- a/include/linux/blkdev.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages-checkpatch-fixes
+++ a/include/linux/blkdev.h
@@ -753,7 +753,7 @@ struct req_iterator {
 		(_iter.bio->bi_next == NULL && _iter.i == _iter.bio->bi_vcnt-1)
 
 #ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
-# error	"You should to define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform."
+# error	"You should define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform"
 #endif
 #if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
 extern void rq_flush_dcache_pages(struct request *rq);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-media-dvb-dvb-core-dvb_frontendc-needs-semaphoreh.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
recordmcount-stfu.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
acpi-remove-nid_inval.patch
drivers-acpi-acpi_padc-squish-warning.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
kbuild-generate-modulesbuiltin-fix-2-checkpatch-fixes.patch
drivers-leds-leds-ss4200c-fix-return-statement.patch
mtd-nand-fix-multi-chip-suspend-problem-fix.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages-checkpatch-fixes.patch
wusb-use-sizeof-struct-rather-than-pointer.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-memory_hotplug-make-offline_pages-static.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core-fix.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
char-cyclades-fix-compiler-warning.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-media-video-cx23885-needs-kfifo-updates.patch
zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

