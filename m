From: akpm@linux-foundation.org
Subject: +
 hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch added to -mm tree
Date: Wed, 05 Jun 2013 16:11:15 -0700
Message-ID: <51afc593.fgd0+iNrTyGjfRJK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab3FEXLQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jun 2013 19:11:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, riel@redhat.com, penberg@kernel.org, mtosatti@redhat.com, mhocko@suse.cz, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hughd@google.com, hch@lst.de, hannes@cmpxchg.org, gthelen@google.com, gleb@redhat.com, dchinner@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, anton@enomsg.org, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, glommer@openvz.org

Subject: + hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch added to -mm tree
To: glommer@openvz.org,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,anton@enomsg.org,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,dchinner@redhat.com,gleb@redhat.com,gthelen@google.com,hannes@cmpxchg.org,hch@lst.de,hughd@google.com,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mhocko@suse.cz,mtosatti@redhat.com,penberg@kernel.org,riel@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 05 Jun 2013 16:11:15 -0700


The patch titled
     Subject: hugepage: convert huge zero page shrinker to new shrinker API
has been added to the -mm tree.  Its filename is
     hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: hugepage: convert huge zero page shrinker to new shrinker API

It consists of:

* returning long instead of int
* separating count from scan
* returning the number of freed entities in scan

Signed-off-by: Glauber Costa <glommer@openvz.org>
Reviewed-by: Greg Thelen <gthelen@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Rientjes <rientjes@google.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: J. Bruce Fields <bfields@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN mm/huge_memory.c~hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api mm/huge_memory.c
--- a/mm/huge_memory.c~hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api
+++ a/mm/huge_memory.c
@@ -211,24 +211,29 @@ static void put_huge_zero_page(void)
 	BUG_ON(atomic_dec_and_test(&huge_zero_refcount));
 }
 
-static int shrink_huge_zero_page(struct shrinker *shrink,
-		struct shrink_control *sc)
+static long shrink_huge_zero_page_count(struct shrinker *shrink,
+					struct shrink_control *sc)
 {
-	if (!sc->nr_to_scan)
-		/* we can free zero page only if last reference remains */
-		return atomic_read(&huge_zero_refcount) == 1 ? HPAGE_PMD_NR : 0;
+	/* we can free zero page only if last reference remains */
+	return atomic_read(&huge_zero_refcount) == 1 ? HPAGE_PMD_NR : 0;
+}
 
+static long shrink_huge_zero_page_scan(struct shrinker *shrink,
+				       struct shrink_control *sc)
+{
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
 		struct page *zero_page = xchg(&huge_zero_page, NULL);
 		BUG_ON(zero_page == NULL);
 		__free_page(zero_page);
+		return HPAGE_PMD_NR;
 	}
 
 	return 0;
 }
 
 static struct shrinker huge_zero_page_shrinker = {
-	.shrink = shrink_huge_zero_page,
+	.count_objects = shrink_huge_zero_page_count,
+	.scan_objects = shrink_huge_zero_page_scan,
 	.seeks = DEFAULT_SEEKS,
 };
 
_

Patches currently in -mm which might be from glommer@openvz.org are

fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list-fix.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
list_lru-per-node-api.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
vmscan-also-shrink-slab-in-memcg-pressure.patch
memcglist_lru-duplicate-lrus-upon-kmemcg-creation.patch
lru-add-an-element-to-a-memcg-list.patch
list_lru-per-memcg-walks.patch
memcg-per-memcg-kmem-shrinking.patch
memcg-scan-cache-objects-hierarchically.patch
vmscan-take-at-least-one-pass-with-shrinkers.patch
super-targeted-memcg-reclaim.patch
memcg-move-initialization-to-memcg-creation.patch
vmpressure-in-kernel-notifications.patch
memcg-reap-dead-memcgs-upon-global-memory-pressure.patch

