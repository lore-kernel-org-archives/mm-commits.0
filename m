From: akpm@linux-foundation.org
Subject: [merged] vmscan-remove-obsolete-shrink_control-comment.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:14:19 -0700
Message-ID: <20120801201420.174675C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:61449 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:14:22 -0400
Received: by wibhr14 with SMTP id hr14so198985wib.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:14:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, khlebnikov@openvz.org, mpatocka@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: remove obsolete shrink_control comment
has been removed from the -mm tree.  Its filename was
     vmscan-remove-obsolete-shrink_control-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: vmscan: remove obsolete shrink_control comment

09f363c7 ("vmscan: fix shrinker callback bug in fs/super.c") fixed a
shrinker callback which was returning -1 when nr_to_scan is zero, which
caused excessive slab scanning.  But 635697c6 ("vmscan: fix initial
shrinker size handling") fixed the problem, again so we can freely return
-1 although nr_to_scan is zero.  So let's revert 09f363c7 because the
comment added in 09f363c7 made an unnecessary rule.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c               |    2 +-
 include/linux/shrinker.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/super.c~vmscan-remove-obsolete-shrink_control-comment fs/super.c
--- a/fs/super.c~vmscan-remove-obsolete-shrink_control-comment
+++ a/fs/super.c
@@ -62,7 +62,7 @@ static int prune_super(struct shrinker *
 		return -1;
 
 	if (!grab_super_passive(sb))
-		return !sc->nr_to_scan ? 0 : -1;
+		return -1;
 
 	if (sb->s_op && sb->s_op->nr_cached_objects)
 		fs_objects = sb->s_op->nr_cached_objects(sb);
diff -puN include/linux/shrinker.h~vmscan-remove-obsolete-shrink_control-comment include/linux/shrinker.h
--- a/include/linux/shrinker.h~vmscan-remove-obsolete-shrink_control-comment
+++ a/include/linux/shrinker.h
@@ -20,7 +20,6 @@ struct shrink_control {
  * 'nr_to_scan' entries and attempt to free them up.  It should return
  * the number of objects which remain in the cache.  If it returns -1, it means
  * it cannot do any scanning at this time (eg. there is a risk of deadlock).
- * The callback must not return -1 if nr_to_scan is zero.
  *
  * The 'gfpmask' refers to the allocation we are currently trying to
  * fulfil.
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-__gfp_no_kswapd.patch
remove-__gfp_no_kswapd-fixes-fix.patch

