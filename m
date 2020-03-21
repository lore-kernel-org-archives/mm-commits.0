From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Sat, 21 Mar 2020 12:39:49 -0700
Message-ID: <20200321193949.UG8CHexl7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727428AbgCUTjv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 21 Mar 2020 15:39:51 -0400
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

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 
 sound/core/oss/pcm_plugin.c                       |   61 ------------
 2 files changed, 65 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -524,11 +524,7 @@ static void dm_dcn_crtc_high_irq(void *i
 
 	acrtc_state = to_dm_crtc_state(acrtc->base.state);
 
-<<<<<<< HEAD
-	DRM_DEBUG_DRIVER("crtc:%d, vupdate-vrr:%d, planes:%d\n", acrtc->crtc_id,
-=======
 	DRM_DEBUG_VBL("crtc:%d, vupdate-vrr:%d, planes:%d\n", acrtc->crtc_id,
->>>>>>> linux-next/akpm-base
 			 amdgpu_dm_vrr_active(acrtc_state),
 			 acrtc_state->active_planes);
 
--- a/sound/core/oss/pcm_plugin.c~linux-next-git-rejects
+++ a/sound/core/oss/pcm_plugin.c
@@ -201,32 +201,6 @@ static snd_pcm_sframes_t calc_dst_frames
 {
 	struct snd_pcm_plugin *plugin, *plugin_next;
 
-<<<<<<< HEAD
-	if (snd_BUG_ON(!plug))
-		return -ENXIO;
-	if (drv_frames == 0)
-		return 0;
-	stream = snd_pcm_plug_stream(plug);
-	if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		plugin = snd_pcm_plug_last(plug);
-		while (plugin && drv_frames > 0) {
-			if (drv_frames > plugin->buf_frames)
-				drv_frames = plugin->buf_frames;
-			plugin_prev = plugin->prev;
-			if (plugin->src_frames)
-				drv_frames = plugin->src_frames(plugin, drv_frames);
-			plugin = plugin_prev;
-		}
-	} else if (stream == SNDRV_PCM_STREAM_CAPTURE) {
-		plugin = snd_pcm_plug_first(plug);
-		while (plugin && drv_frames > 0) {
-			plugin_next = plugin->next;
-			if (plugin->dst_frames)
-				drv_frames = plugin->dst_frames(plugin, drv_frames);
-			if (drv_frames > plugin->buf_frames)
-				drv_frames = plugin->buf_frames;
-			plugin = plugin_next;
-=======
 	plugin = snd_pcm_plug_first(plug);
 	while (plugin && frames > 0) {
 		plugin_next = plugin->next;
@@ -256,7 +230,6 @@ static snd_pcm_sframes_t calc_src_frames
 			frames = plugin->src_frames(plugin, frames);
 			if (frames < 0)
 				return frames;
->>>>>>> linux-next/akpm-base
 		}
 		plugin = plugin_prev;
 	}
@@ -282,46 +255,12 @@ snd_pcm_sframes_t snd_pcm_plug_slave_siz
 {
 	if (snd_BUG_ON(!plug))
 		return -ENXIO;
-<<<<<<< HEAD
-	if (clt_frames == 0)
-		return 0;
-	frames = clt_frames;
-	stream = snd_pcm_plug_stream(plug);
-	if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		plugin = snd_pcm_plug_first(plug);
-		while (plugin && frames > 0) {
-			plugin_next = plugin->next;
-			if (plugin->dst_frames) {
-				frames = plugin->dst_frames(plugin, frames);
-				if (frames < 0)
-					return frames;
-			}
-			if (frames > plugin->buf_frames)
-				frames = plugin->buf_frames;
-			plugin = plugin_next;
-		}
-	} else if (stream == SNDRV_PCM_STREAM_CAPTURE) {
-		plugin = snd_pcm_plug_last(plug);
-		while (plugin) {
-			if (frames > plugin->buf_frames)
-				frames = plugin->buf_frames;
-			plugin_prev = plugin->prev;
-			if (plugin->src_frames) {
-				frames = plugin->src_frames(plugin, frames);
-				if (frames < 0)
-					return frames;
-			}
-			plugin = plugin_prev;
-		}
-	} else
-=======
 	switch (snd_pcm_plug_stream(plug)) {
 	case SNDRV_PCM_STREAM_PLAYBACK:
 		return calc_dst_frames(plug, clt_frames);
 	case SNDRV_PCM_STREAM_CAPTURE:
 		return calc_src_frames(plug, clt_frames);
 	default:
->>>>>>> linux-next/akpm-base
 		snd_BUG();
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-fix-null-pointer-dereference-in-__mem_cgroup_usage_unregister_event-fix.patch
mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix.patch
mm.patch
mm-gup-track-foll_pin-pages-fix-2-fix.patch
mm-swap-make-page_evictable-inline-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch
