From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 19 Feb 2020 11:16:04 -0800
Message-ID: <20200219191604.u_0a3iW2C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbgBSTQG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 14:16:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
