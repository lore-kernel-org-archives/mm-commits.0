From: akpm@linux-foundation.org
Subject: [withdrawn]
 dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 22 Mar 2016 13:59:22 -0700
Message-ID: <56f1b22a.lGDqbH9/W/QFQJzB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbcCVU7X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 16:59:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mcgrof@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch

This patch was dropped because it was withdrawn

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


