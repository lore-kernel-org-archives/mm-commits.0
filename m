From: akpm@linux-foundation.org
Subject: + sound-core-pcm_libc-fix-race-condition-in-wait_for_avail.patch added to -mm tree
Date: Tue, 06 Sep 2011 16:00:51 -0700
Message-ID: <201109062300.p86N0pWm009851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754868Ab1IFXBB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 19:01:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@infradead.org, arjan@linux.intel.com, tiwai@suse.de


The patch titled
     sound/core/pcm_lib.c: fix race condition in wait_for_avail()
has been added to the -mm tree.  Its filename is
     sound-core-pcm_libc-fix-race-condition-in-wait_for_avail.patch

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
Subject: sound/core/pcm_lib.c: fix race condition in wait_for_avail()
From: Arjan van de Ven <arjan@infradead.org>

wait_for_avail() in pcm_lib.c has a race in it (observed in practice by an
Intel validation group).

The function is supposed to return once space in the buffer has become
available, or if some timeout happens.  The entity that creates space (irq
handler of sound driver and some such) will do a wake up on a waitqueue
that this function registers for.

However there are two races in the existing code

1) If space became available between the caller noticing there was no
   space and this function actually sleeping, the wakeup is missed and the
   timeout condition will happen instead

2) If a wakeup happened but not sufficient space became available, the
   code will loop again and wait for more space.  However, if the second
   wake comes in prior to hitting the schedule_timeout_interruptible(), it
   will be missed, and potentially you'll wait out until the timeout
   happens.

The fix consists of using more careful setting of the current state (so
that if a wakeup happens in the main loop window, the schedule_timeout()
falls through) and by checking for available space prior to going into the
schedule_timeout() loop, but after being on the waitqueue and having the
state set to interruptible.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/core/pcm_lib.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff -puN sound/core/pcm_lib.c~sound-core-pcm_libc-fix-race-condition-in-wait_for_avail sound/core/pcm_lib.c
--- a/sound/core/pcm_lib.c~sound-core-pcm_libc-fix-race-condition-in-wait_for_avail
+++ a/sound/core/pcm_lib.c
@@ -1761,6 +1761,10 @@ static int wait_for_avail(struct snd_pcm
 	snd_pcm_uframes_t avail = 0;
 	long wait_time, tout;
 
+	init_waitqueue_entry(&wait, current);
+	add_wait_queue(&runtime->tsleep, &wait);
+	set_current_state(TASK_INTERRUPTIBLE);
+
 	if (runtime->no_period_wakeup)
 		wait_time = MAX_SCHEDULE_TIMEOUT;
 	else {
@@ -1771,16 +1775,34 @@ static int wait_for_avail(struct snd_pcm
 		}
 		wait_time = msecs_to_jiffies(wait_time * 1000);
 	}
-	init_waitqueue_entry(&wait, current);
-	add_wait_queue(&runtime->tsleep, &wait);
+
+	/*
+	 * We need to check if space became available already (and thus the
+	 * wakeup happened already) prior to going into the sleep loop to
+	 * close the race of space already having become available.
+	 * This check must happen after been added to the waitqueue and
+	 * having current state be INTERRUPTIBLE.
+	 */
+
+	if (is_playback)
+		avail = snd_pcm_playback_avail(runtime);
+	else
+		avail = snd_pcm_capture_avail(runtime);
+	if (avail >= runtime->twake)
+		goto _endloop;
+
+
 	for (;;) {
 		if (signal_pending(current)) {
 			err = -ERESTARTSYS;
 			break;
 		}
 		snd_pcm_stream_unlock_irq(substream);
-		tout = schedule_timeout_interruptible(wait_time);
+
+		tout = schedule_timeout(wait_time);
+
 		snd_pcm_stream_lock_irq(substream);
+		set_current_state(TASK_INTERRUPTIBLE);
 		switch (runtime->status->state) {
 		case SNDRV_PCM_STATE_SUSPENDED:
 			err = -ESTRPIPE;
@@ -1814,6 +1836,7 @@ static int wait_for_avail(struct snd_pcm
 			break;
 	}
  _endloop:
+	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&runtime->tsleep, &wait);
 	*availp = avail;
 	return err;
_

Patches currently in -mm which might be from arjan@infradead.org are

sound-core-pcm_libc-fix-race-condition-in-wait_for_avail.patch
sound-core-pcm_libc-fix-race-condition-in-wait_for_avail-fix.patch

