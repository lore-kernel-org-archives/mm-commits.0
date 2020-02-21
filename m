From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Thu, 20 Feb 2020 16:14:05 -0800
Message-ID: <20200221001405.giA8VyhAC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729416AbgBUAOI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Feb 2020 19:14:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c                     |    6 ------
 sound/soc/sof/intel/hda-dsp.c |   13 -------------
 2 files changed, 19 deletions(-)

--- a/fs/pipe.c~linux-next-git-rejects
+++ a/fs/pipe.c
@@ -1315,11 +1315,6 @@ int pipe_resize_ring(struct pipe_inode_i
 		pipe->max_usage = nr_slots;
 	pipe->tail = tail;
 	pipe->head = head;
-<<<<<<< HEAD
-
-	/* This might have made more room for writers */
-	wake_up_interruptible(&pipe->wr_wait);
-=======
 	wake_up_interruptible_all(&pipe->rd_wait);
 	wake_up_interruptible_all(&pipe->wr_wait);
 	return 0;
@@ -1373,7 +1368,6 @@ static long pipe_set_size(struct pipe_in
 
 	pipe->max_usage = nr_slots;
 	pipe->nr_accounted = nr_slots;
->>>>>>> linux-next/akpm-base
 	return pipe->max_usage * PAGE_SIZE;
 
 out_revert_acct:
--- a/sound/soc/sof/intel/hda-dsp.c~linux-next-git-rejects
+++ a/sound/soc/sof/intel/hda-dsp.c
@@ -669,12 +669,6 @@ int hda_dsp_resume(struct snd_sof_dev *s
 			return ret;
 		}
 
-<<<<<<< HEAD
-	if (sdev->s0_suspend) {
-		hda_codec_i915_display_power(sdev, true);
-
-=======
->>>>>>> linux-next/akpm-base
 		/* restore L1SEN bit */
 		if (hda->l1_support_changed)
 			snd_sof_dsp_update_bits(sdev, HDA_DSP_HDA_BAR,
@@ -751,12 +745,6 @@ int hda_dsp_suspend(struct snd_sof_dev *
 	};
 	int ret;
 
-<<<<<<< HEAD
-	if (sdev->s0_suspend) {
-		/* we can't keep a wakeref to display driver at suspend */
-		hda_codec_i915_display_power(sdev, false);
-
-=======
 	/* cancel any attempt for DSP D0I3 */
 	cancel_delayed_work_sync(&hda->d0i3_work);
 
@@ -773,7 +761,6 @@ int hda_dsp_suspend(struct snd_sof_dev *
 			return ret;
 		}
 
->>>>>>> linux-next/akpm-base
 		/* enable L1SEN to make sure the system can enter S0Ix */
 		hda->l1_support_changed =
 			snd_sof_dsp_update_bits(sdev, HDA_DSP_HDA_BAR,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix.patch
mm.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
linux-next-rejects.patch
linux-next-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
