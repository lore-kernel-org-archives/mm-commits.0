From: akpm@linux-foundation.org
Subject: + md-dont-attempt-read-balancing-for-raid10-far-layouts.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:23:38 -0800
Message-ID: <200803030823.m238NckO006536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbYCCIY3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:24:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keld@dkuug.dk, neilb@suse.de


The patch titled
     md: don't attempt read-balancing for raid10 'far' layouts
has been added to the -mm tree.  Its filename is
     md-dont-attempt-read-balancing-for-raid10-far-layouts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: don't attempt read-balancing for raid10 'far' layouts
From: Keld Simonsen <keld@dkuug.dk>

This patch changes the disk to be read for layout "far > 1" to always be the
disk with the lowest block address.

Thus the chunks to be read will always be (for a fully functioning array) from
the first band of stripes, and the raid will then work as a raid0 consisting
of the first band of stripes.

Some advantages:

The fastest part which is the outer sectors of the disks involved will be
used.  The outer blocks of a disk may be as much as 100 % faster than the
inner blocks.

Average seek time will be smaller, as seeks will always be confined to the
first part of the disks.

Mixed disks with different performance characteristics will work better, as
they will work as raid0, the sequential read rate will be number of disks
involved times the IO rate of the slowest disk.

If a disk is malfunctioning, the first disk which is working, and has the
lowest block address for the logical block will be used.

Signed-off-by: Keld Simonsen <keld@dkuug.dk>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid10.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN drivers/md/raid10.c~md-dont-attempt-read-balancing-for-raid10-far-layouts drivers/md/raid10.c
--- a/drivers/md/raid10.c~md-dont-attempt-read-balancing-for-raid10-far-layouts
+++ a/drivers/md/raid10.c
@@ -537,7 +537,8 @@ static int read_balance(conf_t *conf, r1
 	current_distance = abs(r10_bio->devs[slot].addr -
 			       conf->mirrors[disk].head_position);
 
-	/* Find the disk whose head is closest */
+	/* Find the disk whose head is closest,
+	 * or - for far > 1 - find the closest to partition beginning */
 
 	for (nslot = slot; nslot < conf->copies; nslot++) {
 		int ndisk = r10_bio->devs[nslot].devnum;
@@ -557,8 +558,13 @@ static int read_balance(conf_t *conf, r1
 			slot = nslot;
 			break;
 		}
-		new_distance = abs(r10_bio->devs[nslot].addr -
-				   conf->mirrors[ndisk].head_position);
+
+		/* for far > 1 always use the lowest address */
+		if (conf->far_copies > 1)
+			new_distance = r10_bio->devs[nslot].addr;
+		else
+			new_distance = abs(r10_bio->devs[nslot].addr -
+					   conf->mirrors[ndisk].head_position);
 		if (new_distance < current_distance) {
 			current_distance = new_distance;
 			disk = ndisk;
_

Patches currently in -mm which might be from keld@dkuug.dk are

md-dont-attempt-read-balancing-for-raid10-far-layouts.patch

