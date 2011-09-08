From: akpm@linux-foundation.org
Subject: + vmscan-fix-shrinker-callback-bug-in-fs-superc.patch added to -mm tree
Date: Thu, 08 Sep 2011 16:57:17 -0700
Message-ID: <201109082357.p88NvHsg016142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756419Ab1IHX5f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2011 19:57:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpatocka@redhat.com, david@fromorbit.com


The patch titled
     vmscan: fix shrinker callback bug in fs/super.c
has been added to the -mm tree.  Its filename is
     vmscan-fix-shrinker-callback-bug-in-fs-superc.patch

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
Subject: vmscan: fix shrinker callback bug in fs/super.c
From: Mikulas Patocka <mpatocka@redhat.com>

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

linux-next.patch
vmscan-fix-shrinker-callback-bug-in-fs-superc.patch

