From: akpm@linux-foundation.org
Subject: + media-remove-redundant-tests-on-unsigned.patch added to -mm tree
Date: Fri, 26 Jun 2009 14:01:32 -0700
Message-ID: <200906262101.n5QL1Wh1022378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753634AbZFZVCI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 17:02:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, hverkuil@xs4all.nl, mchehab@infradead.org


The patch titled
     media: remove redundant tests on unsigned
has been added to the -mm tree.  Its filename is
     media-remove-redundant-tests-on-unsigned.patch

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
Subject: media: remove redundant tests on unsigned
From: Roel Kluin <roel.kluin@gmail.com>

input, inp and i are unsigned. When negative they are wrapped and caught by the
other test.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/ttpci/av7110_v4l.c        |    2 +-
 drivers/media/video/cx18/cx18-ioctl.c       |    2 +-
 drivers/media/video/saa7134/saa7134-video.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/media/dvb/ttpci/av7110_v4l.c~media-remove-redundant-tests-on-unsigned drivers/media/dvb/ttpci/av7110_v4l.c
--- a/drivers/media/dvb/ttpci/av7110_v4l.c~media-remove-redundant-tests-on-unsigned
+++ a/drivers/media/dvb/ttpci/av7110_v4l.c
@@ -490,7 +490,7 @@ static int vidioc_s_input(struct file *f
 	if (!av7110->analog_tuner_flags)
 		return 0;
 
-	if (input < 0 || input >= 4)
+	if (input >= 4)
 		return -EINVAL;
 
 	av7110->current_input = input;
diff -puN drivers/media/video/cx18/cx18-ioctl.c~media-remove-redundant-tests-on-unsigned drivers/media/video/cx18/cx18-ioctl.c
--- a/drivers/media/video/cx18/cx18-ioctl.c~media-remove-redundant-tests-on-unsigned
+++ a/drivers/media/video/cx18/cx18-ioctl.c
@@ -605,7 +605,7 @@ int cx18_s_input(struct file *file, void
 	if (ret)
 		return ret;
 
-	if (inp < 0 || inp >= cx->nof_inputs)
+	if (inp >= cx->nof_inputs)
 		return -EINVAL;
 
 	if (inp == cx->active_input) {
diff -puN drivers/media/video/saa7134/saa7134-video.c~media-remove-redundant-tests-on-unsigned drivers/media/video/saa7134/saa7134-video.c
--- a/drivers/media/video/saa7134/saa7134-video.c~media-remove-redundant-tests-on-unsigned
+++ a/drivers/media/video/saa7134/saa7134-video.c
@@ -1790,7 +1790,7 @@ static int saa7134_s_input(struct file *
 	if (0 != err)
 		return err;
 
-	if (i < 0  ||  i >= SAA7134_INPUT_MAX)
+	if (i >= SAA7134_INPUT_MAX)
 		return -EINVAL;
 	if (NULL == card_in(dev, i).name)
 		return -EINVAL;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
media-remove-redundant-tests-on-unsigned.patch
ext4-remove-redundant-test-on-unsigned.patch
wireless-remove-redundant-tests-on-unsigned.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
adfs-remove-redundant-test-on-unsigned.patch

