From: akpm@linux-foundation.org
Subject: + fs-cachefiles-use-add_to_page_cache_lru.patch added to -mm tree
Date: Tue, 04 Feb 2014 15:14:40 -0800
Message-ID: <52f17460.2mkMhk00UW4+bs9i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933800AbaBDXOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 18:14:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz, tj@kernel.org, semenzato@google.com, rmallon@gmail.com, riel@redhat.com, peterz@infradead.org, ozgun@citusdata.com, minchan@kernel.org, mgorman@suse.de, metin@citusdata.com, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, jack@suse.cz, hughd@google.com, hch@infradead.org, gthelen@google.com, dhowells@redhat.com, david@fromorbit.com, bob.liu@oracle.com, aarcange@redhat.com, hannes@cmpxchg.org

Subject: + fs-cachefiles-use-add_to_page_cache_lru.patch added to -mm tree
To: hannes@cmpxchg.org,aarcange@redhat.com,bob.liu@oracle.com,david@fromorbit.com,dhowells@redhat.com,gthelen@google.com,hch@infradead.org,hughd@google.com,jack@suse.cz,klamm@yandex-team.ru,kosaki.motohiro@jp.fujitsu.com,metin@citusdata.com,mgorman@suse.de,minchan@kernel.org,ozgun@citusdata.com,peterz@infradead.org,riel@redhat.com,rmallon@gmail.com,semenzato@google.com,tj@kernel.org,vbabka@suse.cz,walken@google.com
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 15:14:40 -0800


The patch titled
     Subject: fs: cachefiles: use add_to_page_cache_lru()
has been added to the -mm tree.  Its filename is
     fs-cachefiles-use-add_to_page_cache_lru.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-cachefiles-use-add_to_page_cache_lru.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-cachefiles-use-add_to_page_cache_lru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: fs: cachefiles: use add_to_page_cache_lru()

This code used to have its own lru cache pagevec up until a0b8cab3
("mm: remove lru parameter from __pagevec_lru_add and remove parts of
pagevec API").  Now it's just add_to_page_cache() followed by
lru_cache_add(), might as well use add_to_page_cache_lru() directly.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Metin Doslu <metin@citusdata.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ozgun Erdogan <ozgun@citusdata.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cachefiles/rdwr.c |   33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff -puN fs/cachefiles/rdwr.c~fs-cachefiles-use-add_to_page_cache_lru fs/cachefiles/rdwr.c
--- a/fs/cachefiles/rdwr.c~fs-cachefiles-use-add_to_page_cache_lru
+++ a/fs/cachefiles/rdwr.c
@@ -265,24 +265,22 @@ static int cachefiles_read_backing_file_
 				goto nomem_monitor;
 		}
 
-		ret = add_to_page_cache(newpage, bmapping,
-					netpage->index, cachefiles_gfp);
+		ret = add_to_page_cache_lru(newpage, bmapping,
+					    netpage->index, cachefiles_gfp);
 		if (ret == 0)
 			goto installed_new_backing_page;
 		if (ret != -EEXIST)
 			goto nomem_page;
 	}
 
-	/* we've installed a new backing page, so now we need to add it
-	 * to the LRU list and start it reading */
+	/* we've installed a new backing page, so now we need to start
+	 * it reading */
 installed_new_backing_page:
 	_debug("- new %p", newpage);
 
 	backpage = newpage;
 	newpage = NULL;
 
-	lru_cache_add_file(backpage);
-
 read_backing_page:
 	ret = bmapping->a_ops->readpage(NULL, backpage);
 	if (ret < 0)
@@ -510,24 +508,23 @@ static int cachefiles_read_backing_file(
 					goto nomem;
 			}
 
-			ret = add_to_page_cache(newpage, bmapping,
-						netpage->index, cachefiles_gfp);
+			ret = add_to_page_cache_lru(newpage, bmapping,
+						    netpage->index,
+						    cachefiles_gfp);
 			if (ret == 0)
 				goto installed_new_backing_page;
 			if (ret != -EEXIST)
 				goto nomem;
 		}
 
-		/* we've installed a new backing page, so now we need to add it
-		 * to the LRU list and start it reading */
+		/* we've installed a new backing page, so now we need
+		 * to start it reading */
 	installed_new_backing_page:
 		_debug("- new %p", newpage);
 
 		backpage = newpage;
 		newpage = NULL;
 
-		lru_cache_add_file(backpage);
-
 	reread_backing_page:
 		ret = bmapping->a_ops->readpage(NULL, backpage);
 		if (ret < 0)
@@ -538,8 +535,8 @@ static int cachefiles_read_backing_file(
 	monitor_backing_page:
 		_debug("- monitor add");
 
-		ret = add_to_page_cache(netpage, op->mapping, netpage->index,
-					cachefiles_gfp);
+		ret = add_to_page_cache_lru(netpage, op->mapping,
+					    netpage->index, cachefiles_gfp);
 		if (ret < 0) {
 			if (ret == -EEXIST) {
 				page_cache_release(netpage);
@@ -549,8 +546,6 @@ static int cachefiles_read_backing_file(
 			goto nomem;
 		}
 
-		lru_cache_add_file(netpage);
-
 		/* install a monitor */
 		page_cache_get(netpage);
 		monitor->netfs_page = netpage;
@@ -613,8 +608,8 @@ static int cachefiles_read_backing_file(
 	backing_page_already_uptodate:
 		_debug("- uptodate");
 
-		ret = add_to_page_cache(netpage, op->mapping, netpage->index,
-					cachefiles_gfp);
+		ret = add_to_page_cache_lru(netpage, op->mapping,
+					    netpage->index, cachefiles_gfp);
 		if (ret < 0) {
 			if (ret == -EEXIST) {
 				page_cache_release(netpage);
@@ -631,8 +626,6 @@ static int cachefiles_read_backing_file(
 
 		fscache_mark_page_cached(op, netpage);
 
-		lru_cache_add_file(netpage);
