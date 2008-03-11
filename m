From: akpm@linux-foundation.org
Subject: - md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap-fix.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:22:13 -0700
Message-ID: <200803110322.m2B3MDaa019796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbYCKDWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:22:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: reduce CPU wastage on idle md array with a write-intent bitmap
has been removed from the -mm tree.  Its filename was
     md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: reduce CPU wastage on idle md array with a write-intent bitmap
From: NeilBrown <neilb@suse.de>

Recent patch titled
  Reduce CPU wastage on idle md array with a write-intent bitmap.

would sometimes leave the array with dirty bitmap bits that stay dirty.  A
subsequent write would sort things out so it isn't a big problem, but should
be fixed nonetheless.

We need to make sure that when the bitmap becomes not "allclean", the
daemon_sleep really does get set to a sensible value.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/md/bitmap.c~md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap-fix drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap-fix
+++ a/drivers/md/bitmap.c
@@ -1045,7 +1045,8 @@ void bitmap_daemon_work(struct bitmap *b
 	if (bitmap == NULL)
 		return;
 	if (time_before(jiffies, bitmap->daemon_lastrun + bitmap->daemon_sleep*HZ))
-		return;
+		goto done;
+
 	bitmap->daemon_lastrun = jiffies;
 	if (bitmap->allclean) {
 		bitmap->mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
@@ -1142,6 +1143,7 @@ void bitmap_daemon_work(struct bitmap *b
 		}
 	}
 
+ done:
 	if (bitmap->allclean == 0)
 		bitmap->mddev->thread->timeout = bitmap->daemon_sleep * HZ;
 }
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
git-nfsd.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch

