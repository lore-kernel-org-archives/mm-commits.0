From: akpm@linux-foundation.org
Subject: - git-alsa-tiwai-hda_codec-fix-locking.patch removed from -mm tree
Date: Tue, 15 Apr 2008 02:10:17 -0700
Message-ID: <200804150910.m3F9AHHK020605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756112AbYDOJLI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 05:11:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deweerdt@free.fr, miles.lane@gmail.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     git-alsa-tiwai: hda_codec: fix locking
has been removed from the -mm tree.  Its filename was
     git-alsa-tiwai-hda_codec-fix-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-alsa-tiwai: hda_codec: fix locking
From: Frederik Deweerdt <deweerdt@free.fr>

On Wed, Apr 02, 2008 at 08:19:29AM -0400, Miles Lane wrote:
> [   48.765906] [ BUG: bad unlock balance detected! ]
> [   48.765912] -------------------------------------
> [   48.765918] pulseaudio/4277 is trying to release lock
> (&codec->spdif_mutex) at:
> [   48.765930] [<c03031b7>] mutex_unlock+0x8/0xa
> [   48.765945] but there are no more locks to release!
> [   48.765950]
> [   48.765952] other info that might help us debug this:
> [   48.765959] 2 locks held by pulseaudio/4277:
> [   48.765965]  #0:  (&pcm->open_mutex){--..}, at: [<f89f134b>]
> snd_pcm_open+0xc1/0x1ba [snd_pcm]
> [   48.766003]  #1:  (&chip->open_mutex){--..}, at: [<f8b4f13d>]
> azx_pcm_open+0x36/0x184 [snd_hda_intel]
> [   48.766057]
> [   48.766059] stack backtrace:
> [   48.766066] Pid: 4277, comm: pulseaudio Not tainted 2.6.25-rc8-mm1 #12
> [   48.766086]  [<c013afc6>] print_unlock_inbalance_bug+0xce/0xd8
> [   48.766107]  [<c0109e1c>] ? save_stack_trace+0x1d/0x3b
> [   48.766130]  [<c012f54e>] ? __kernel_text_address+0x1b/0x27
> [   48.766146]  [<c0104533>] ? dump_trace+0xcd/0xd9
> [   48.766160]  [<c0109d9e>] ? save_stack_address+0x0/0x2c
> [   48.766176]  [<c013b80a>] ? find_usage_backwards+0xa4/0xc3
> [   48.766193]  [<c013cfb5>] lock_release_non_nested+0x84/0x120
> [   48.766209]  [<c03031b7>] ? mutex_unlock+0x8/0xa
> [   48.766222]  [<c013d1bb>] lock_release+0x16a/0x199
> [   48.766238]  [<c0303137>] __mutex_unlock_slowpath+0xa9/0x121
> [   48.766252]  [<c03031b7>] mutex_unlock+0x8/0xa
> [   48.766263]  [<f8b4ffd8>] snd_hda_multi_out_analog_open+0xd3/0xef
> [snd_hda_intel]

The following patch should fix it.

Cc: "Miles Lane" <miles.lane@gmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/hda_codec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/pci/hda/hda_codec.c~git-alsa-tiwai-hda_codec-fix-locking sound/pci/hda/hda_codec.c
--- a/sound/pci/hda/hda_codec.c~git-alsa-tiwai-hda_codec-fix-locking
+++ a/sound/pci/hda/hda_codec.c
@@ -2665,8 +2665,8 @@ int snd_hda_multi_out_analog_open(struct
 			if (mout->spdif_maxbps < hinfo->maxbps)
 				hinfo->maxbps = mout->spdif_maxbps;
 		}
+		mutex_unlock(&codec->spdif_mutex);
 	}
-	mutex_unlock(&codec->spdif_mutex);
 	return snd_pcm_hw_constraint_step(substream->runtime, 0,
 					  SNDRV_PCM_HW_PARAM_CHANNELS, 2);
 }
_

Patches currently in -mm which might be from deweerdt@free.fr are

git-alsa-tiwai.patch
reiser4-sb_sync_inodes.patch
getblk-handle-2tb-devices-fix.patch

