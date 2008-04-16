From: akpm@linux-foundation.org
Subject: - drivers-media-video-use-time_before-time_before_eq-etc.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:55:46 -0700
Message-ID: <200804162255.m3GMtkQd011149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757910AbYDPXBX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 19:01:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video: use time_before, time_before_eq, etc
has been removed from the -mm tree.  Its filename was
     drivers-media-video-use-time_before-time_before_eq-etc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video: use time_before, time_before_eq, etc
From: Julia Lawall <julia@diku.dk>


The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/c-qcam.c            |    7 +++++--
 drivers/media/video/ivtv/ivtv-fileops.c |    4 +++-
 drivers/media/video/ivtv/ivtv-mailbox.c |   11 +++++++----
 drivers/media/video/ivtv/ivtv-streams.c |    3 ++-
 4 files changed, 17 insertions(+), 8 deletions(-)

diff -puN drivers/media/video/c-qcam.c~drivers-media-video-use-time_before-time_before_eq-etc drivers/media/video/c-qcam.c
--- a/drivers/media/video/c-qcam.c~drivers-media-video-use-time_before-time_before_eq-etc
+++ a/drivers/media/video/c-qcam.c
@@ -36,6 +36,7 @@
 #include <linux/videodev.h>
 #include <media/v4l2-common.h>
 #include <linux/mutex.h>
+#include <linux/jiffies.h>
 
 #include <asm/uaccess.h>
 
@@ -95,7 +96,8 @@ static unsigned int qcam_await_ready1(st
 	unsigned long oldjiffies = jiffies;
 	unsigned int i;
 
-	for (oldjiffies = jiffies; (jiffies - oldjiffies) < msecs_to_jiffies(40); )
+	for (oldjiffies = jiffies;
+	     time_before(jiffies, oldjiffies + msecs_to_jiffies(40)); )
 		if (qcam_ready1(qcam) == value)
 			return 0;
 
@@ -120,7 +122,8 @@ static unsigned int qcam_await_ready2(st
 	unsigned long oldjiffies = jiffies;
 	unsigned int i;
 
-	for (oldjiffies = jiffies; (jiffies - oldjiffies) < msecs_to_jiffies(40); )
+	for (oldjiffies = jiffies;
+	     time_before(jiffies, oldjiffies + msecs_to_jiffies(40)); )
 		if (qcam_ready2(qcam) == value)
 			return 0;
 
diff -puN drivers/media/video/ivtv/ivtv-fileops.c~drivers-media-video-use-time_before-time_before_eq-etc drivers/media/video/ivtv/ivtv-fileops.c
--- a/drivers/media/video/ivtv/ivtv-fileops.c~drivers-media-video-use-time_before-time_before_eq-etc
+++ a/drivers/media/video/ivtv/ivtv-fileops.c
@@ -219,7 +219,9 @@ static struct ivtv_buffer *ivtv_get_buff
 			/* Process pending program info updates and pending VBI data */
 			ivtv_update_pgm_info(itv);
 
-			if (jiffies - itv->dualwatch_jiffies > msecs_to_jiffies(1000)) {
+			if (time_after(jiffies,
+				       itv->dualwatch_jiffies +
+				       msecs_to_jiffies(1000))) {
 				itv->dualwatch_jiffies = jiffies;
 				ivtv_dualwatch(itv);
 			}
diff -puN drivers/media/video/ivtv/ivtv-mailbox.c~drivers-media-video-use-time_before-time_before_eq-etc drivers/media/video/ivtv/ivtv-mailbox.c
--- a/drivers/media/video/ivtv/ivtv-mailbox.c~drivers-media-video-use-time_before-time_before_eq-etc
+++ a/drivers/media/video/ivtv/ivtv-mailbox.c
@@ -177,7 +177,8 @@ static int get_mailbox(struct ivtv *itv,
 
 		/* Sleep before a retry, if not atomic */
 		if (!(flags & API_NO_WAIT_MB)) {
-			if (jiffies - then > msecs_to_jiffies(10*retries))
+			if (time_after(jiffies,
+				       then + msecs_to_jiffies(10*retries)))
 			       break;
 			ivtv_msleep_timeout(10, 0);
 		}
@@ -244,7 +245,9 @@ static int ivtv_api_call(struct ivtv *it
 	   data, then just return 0 as there is no need to issue this command again.
 	   Just an optimization to prevent unnecessary use of mailboxes. */
 	if (itv->api_cache[cmd].last_jiffies &&
-	    jiffies - itv->api_cache[cmd].last_jiffies < msecs_to_jiffies(1800000) &&
+	    time_before(jiffies,
+			itv->api_cache[cmd].last_jiffies +
+			msecs_to_jiffies(1800000)) &&
 	    !memcmp(data, itv->api_cache[cmd].data, sizeof(itv->api_cache[cmd].data))) {
 		itv->api_cache[cmd].last_jiffies = jiffies;
 		return 0;
@@ -299,7 +302,7 @@ static int ivtv_api_call(struct ivtv *it
 		}
 	}
 	while (!(readl(&mbox->flags) & IVTV_MBOX_FIRMWARE_DONE)) {
-		if (jiffies - then > api_timeout) {
+		if (time_after(jiffies, then + api_timeout)) {
 			IVTV_DEBUG_WARN("Could not get result (%s)\n", api_info[cmd].name);
 			/* reset the mailbox, but it is likely too late already */
 			write_sync(0, &mbox->flags);
@@ -311,7 +314,7 @@ static int ivtv_api_call(struct ivtv *it
 		else
 			ivtv_msleep_timeout(1, 0);
 	}
-	if (jiffies - then > msecs_to_jiffies(100))
+	if (time_after(jiffies, then + msecs_to_jiffies(100)))
 		IVTV_DEBUG_WARN("%s took %u jiffies\n",
 				api_info[cmd].name,
 				jiffies_to_msecs(jiffies - then));
diff -puN drivers/media/video/ivtv/ivtv-streams.c~drivers-media-video-use-time_before-time_before_eq-etc drivers/media/video/ivtv/ivtv-streams.c
--- a/drivers/media/video/ivtv/ivtv-streams.c~drivers-media-video-use-time_before-time_before_eq-etc
+++ a/drivers/media/video/ivtv/ivtv-streams.c
@@ -768,7 +768,8 @@ int ivtv_stop_v4l2_encode_stream(struct 
 
 			/* wait 2s for EOS interrupt */
 			while (!test_bit(IVTV_F_I_EOS, &itv->i_flags) &&
-				jiffies < then + msecs_to_jiffies (2000)) {
+				time_before(jiffies,
+					    then + msecs_to_jiffies(2000))) {
 				schedule_timeout(msecs_to_jiffies(10));
 			}
 
_

Patches currently in -mm which might be from julia@diku.dk are

git-alsa-tiwai.patch
git-powerpc.patch
git-dvb.patch
git-gfs2-nmw.patch
git-infiniband.patch
drivers-char-keyboardc-use-time_before-time_before_eq-etc.patch
git-udf.patch
git-net.patch
drivers-atm-use-time_before-time_before_eq-etc.patch
drivers-net-appletalk-use-time_before-time_before_eq-etc.patch
git-ocfs2.patch
drivers-scsi-use-time_before-time_before_eq-etc.patch
fs-affs-filec-use-bug_on.patch
drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
serial-use-time_before-time_before_eq-etc.patch
drivers-char-rtcc-use-time_before-time_before_eq-etc.patch
fbdev-use-div_round_up-or-roundup.patch
drivers-md-use-time_before-time_before_eq-etc.patch
drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch
drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch

