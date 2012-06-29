From: akpm@linux-foundation.org
Subject: + vmscan-remove-obsolete-shrink_control-comment.patch added to -mm tree
Date: Fri, 29 Jun 2012 13:50:09 -0700
Message-ID: <20120629205009.CA79FA024B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:55849 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab2F2UuM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jun 2012 16:50:12 -0400
Received: by ggeh3 with SMTP id h3so416131gge.1
        for <mm-commits@vger.kernel.org>; Fri, 29 Jun 2012 13:50:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, khlebnikov@openvz.org, mpatocka@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: vmscan: remove obsolete shrink_control comment
has been added to the -mm tree.  Its filename is
     vmscan-remove-obsolete-shrink_control-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: vmscan: remove obsolete shrink_control comment

Patches currently in -mm which might be from minchan@kernel.org are

linux-next.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
mm-thp-abort-compaction-if-migration-page-cannot-be-charged-to-memcg.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
mm-compaction-cleanup-on-compaction_deferred.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch
vmscan-remove-obsolete-shrink_control-comment.patch

