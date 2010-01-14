From: akpm@linux-foundation.org
Subject: [merged] media-video-tuner-core-fix-memory-leak.patch removed from -mm tree
Date: Thu, 14 Jan 2010 13:20:48 -0800
Message-ID: <201001142120.o0ELKmu6031627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754774Ab0ANVV3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 16:21:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, hverkuil@xs4all.nl, mchehab@infradead.org, mkrufky@kernellabs.com, mm-commits@vger.kernel.org


The patch titled
     media: video/tuner-core, fix memory leak
has been removed from the -mm tree.  Its filename was
     media-video-tuner-core-fix-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
infiniband-use-rlimit-helpers.patch
char-synclink-remove-unnecessary-checks.patch
mm-use-rlimit-helpers.patch
fs-use-rlimit-helpers.patch
ipc-use-rlimit-helpers.patch

