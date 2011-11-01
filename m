From: akpm@linux-foundation.org
Subject: [merged] vmscan-fix-shrinker-callback-bug-in-fs-superc.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:11:02 -0700
Message-ID: <201111012111.pA1LB2DN004854@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15800 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVLK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:11:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpatocka@redhat.com, david@fromorbit.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: fix shrinker callback bug in fs/super.c
has been removed from the -mm tree.  Its filename was
     vmscan-fix-shrinker-callback-bug-in-fs-superc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: vmscan: fix shrinker callback bug in fs/super.c

The callback must not return -1 when nr_to_scan is zero. Fix the bug in
fs/super.c and add this requirement to the callback specification.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c               |    2 +-
 include/linux/shrinker.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/super.c~vmscan-fix-shrinker-callback-bug-in-fs-superc fs/super.c
--- a/fs/super.c~vmscan-fix-shrinker-callback-bug-in-fs-superc
+++ a/fs/super.c
@@ -61,7 +61,7 @@ static int prune_super(struct shrinker *
 		return -1;
 
 	if (!grab_super_passive(sb))
-		return -1;
+		return !sc->nr_to_scan ? 0 : -1;
 
 	if (sb->s_op && sb->s_op->nr_cached_objects)
 		fs_objects = sb->s_op->nr_cached_objects(sb);
diff -puN include/linux/shrinker.h~vmscan-fix-shrinker-callback-bug-in-fs-superc include/linux/shrinker.h
--- a/include/linux/shrinker.h~vmscan-fix-shrinker-callback-bug-in-fs-superc
+++ a/include/linux/shrinker.h
@@ -20,6 +20,7 @@ struct shrink_control {
  * 'nr_to_scan' entries and attempt to free them up.  It should return
  * the number of objects which remain in the cache.  If it returns -1, it means
  * it cannot do any scanning at this time (eg. there is a risk of deadlock).
+ * The callback must not return -1 if nr_to_scan is zero.
  *
  * The 'gfpmask' refers to the allocation we are currently trying to
  * fulfil.
_

Patches currently in -mm which might be from mpatocka@redhat.com are

origin.patch
linux-next.patch

