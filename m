From: akpm@linux-foundation.org
Subject: + media-video-tuner-core-fix-memory-leak.patch added to -mm tree
Date: Wed, 13 Jan 2010 13:35:38 -0800
Message-ID: <201001132135.o0DLZc3E029883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724Ab0AMVgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 16:36:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, hverkuil@xs4all.nl, mchehab@infradead.org, mkrufky@kernellabs.com


The patch titled
     media: video/tuner-core, fix memory leak
has been added to the -mm tree.  Its filename is
     media-video-tuner-core-fix-memory-leak.patch

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
Subject: media: video/tuner-core, fix memory leak
From: Jiri Slaby <jslaby@suse.cz>

Stanse found a memory leak in tuner_probe.  t is not freed/assigned on all
paths.  Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Michael Krufky <mkrufky@kernellabs.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/tuner-core.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/video/tuner-core.c~media-video-tuner-core-fix-memory-leak drivers/media/video/tuner-core.c
--- a/drivers/media/video/tuner-core.c~media-video-tuner-core-fix-memory-leak
+++ a/drivers/media/video/tuner-core.c
@@ -1078,6 +1078,7 @@ static int tuner_probe(struct i2c_client
 
 				goto register_client;
 			}
+			kfree(t);
 			return -ENODEV;
 		case 0x42:
 		case 0x43:
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
media-dvb-siano-fix-memory-leak.patch
media-video-tuner-core-fix-memory-leak.patch
infiniband-use-rlimit-helpers.patch
mm-use-rlimit-helpers.patch
fs-use-rlimit-helpers.patch
ipc-use-rlimit-helpers.patch

