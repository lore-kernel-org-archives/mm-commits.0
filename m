From: akpm@linux-foundation.org
Subject: + md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap-fix.patch added to -mm tree
Date: Thu, 06 Mar 2008 22:18:10 -0800
Message-ID: <200803070618.m276IAIP008559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754865AbYCGGSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 01:18:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: reduce CPU wastage on idle md array with a write-intent bitmap. fi
has been added to the -mm tree.  Its filename is
     md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap-fix.patch

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
Subject: md: reduce CPU wastage on idle md array with a write-intent bitmap. fi
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

md-fix-formatting-error-in-proc-mdstat.patch
md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap-fix.patch
git-nfsd.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch

