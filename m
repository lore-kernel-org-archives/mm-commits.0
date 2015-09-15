From: akpm@linux-foundation.org
Subject: + slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch added to -mm tree
Date: Tue, 15 Sep 2015 15:12:54 -0700
Message-ID: <55f897e6.BwbFpVAL3sSNb6LM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbbIOWMz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 18:12:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, hughd@google.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, paulmck@linux.vnet.ibm.com, rientjes@google.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: slab, slub: use page->rcu_head instead of page->lru plus cast
has been added to the -mm tree.  Its filename is
     slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: slab, slub: use page->rcu_head instead of page->lru plus cast

We have properly typed page->rcu_head, no need to cast page->lru.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   17 +++--------------
 mm/slub.c |    5 +----
 2 files changed, 4 insertions(+), 18 deletions(-)

diff -puN mm/slab.c~slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast mm/slab.c
--- a/mm/slab.c~slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast
+++ a/mm/slab.c
@@ -1888,21 +1888,10 @@ static void slab_destroy(struct kmem_cac
 
 	freelist = page->freelist;
 	slab_destroy_debugcheck(cachep, page);
-	if (unlikely(cachep->flags & SLAB_DESTROY_BY_RCU)) {
-		struct rcu_head *head;
-
-		/*
-		 * RCU free overloads the RCU head over the LRU.
-		 * slab_page has been overloeaded over the LRU,
-		 * however it is not used from now on so that
-		 * we can use it safely.
-		 */
-		head = (void *)&page->rcu_head;
-		call_rcu(head, kmem_rcu_free);
-
-	} else {
+	if (unlikely(cachep->flags & SLAB_DESTROY_BY_RCU))
+		call_rcu(&page->rcu_head, kmem_rcu_free);
+	else
 		kmem_freepages(cachep, page);
-	}
 
 	/*
 	 * From now on, we don't use freelist
diff -puN mm/slub.c~slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast mm/slub.c
--- a/mm/slub.c~slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast
+++ a/mm/slub.c
@@ -1507,10 +1507,7 @@ static void free_slab(struct kmem_cache
 			VM_BUG_ON(s->reserved != sizeof(*head));
 			head = page_address(page) + offset;
 		} else {
-			/*
-			 * RCU free overloads the RCU head over the LRU
-			 */
-			head = (void *)&page->lru;
+			head = &page->rcu_head;
 		}
 
 		call_rcu(head, rcu_free_slab);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch

