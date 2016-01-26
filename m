From: akpm@linux-foundation.org
Subject: + dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 15:05:01 -0800
Message-ID: <56a7fb9d.qOL5mOEp5bAA4Otr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbcAZXFC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 18:05:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mcgrof@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch

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
Subject: dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes

WARNING: line over 80 characters
#353: FILE: drivers/gpu/drm/omapdrm/omap_dmm_tiler.c:704:
+					   REFILL_BUFFER_SIZE * omap_dmm->num_engines,

ERROR: code indent should use tabs where possible
#557: FILE: drivers/gpu/host1x/job.c:581:
+^I^I            job->gather_copy_mapped, job->gather_copy);$

ERROR: code indent should use tabs where possible
#925: FILE: drivers/video/fbdev/s3c-fb.c:1134:
+^I^I            fbi->screen_base, fbi->fix.smem_start);$

total: 2 errors, 1 warnings, 867 lines checked

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/dma-rename-dma__writecombine-to-dma__wc.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Luis R. Rodriguez" <mcgrof@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/host1x/job.c     |    2 +-
 drivers/video/fbdev/s3c-fb.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/host1x/job.c~dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes drivers/gpu/host1x/job.c
--- a/drivers/gpu/host1x/job.c~dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes
+++ a/drivers/gpu/host1x/job.c
@@ -578,7 +578,7 @@ void host1x_job_unpin(struct host1x_job
 
 	if (job->gather_copy_size)
 		dma_free_wc(job->channel->dev, job->gather_copy_size,
-		            job->gather_copy_mapped, job->gather_copy);
+			    job->gather_copy_mapped, job->gather_copy);
 }
 EXPORT_SYMBOL(host1x_job_unpin);
 
diff -puN drivers/video/fbdev/s3c-fb.c~dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes drivers/video/fbdev/s3c-fb.c
--- a/drivers/video/fbdev/s3c-fb.c~dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes
+++ a/drivers/video/fbdev/s3c-fb.c
@@ -1131,7 +1131,7 @@ static void s3c_fb_free_memory(struct s3
 
 	if (fbi->screen_base)
 		dma_free_wc(sfb->dev, PAGE_ALIGN(fbi->fix.smem_len),
-		            fbi->screen_base, fbi->fix.smem_start);
+			    fbi->screen_base, fbi->fix.smem_start);
 }
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-warn-about-vmdata-over-rlimit_data-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

