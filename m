From: akpm@linux-foundation.org
Subject: +
 mm-fix-races-between-address_space-dereference-and-free-in-page_evicatable.patch added to -mm tree
Date: Fri, 16 Feb 2018 15:47:13 -0800
Message-ID: <5a876d81.HeYcJ208880sXDoS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33956 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbeBPXrO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 18:47:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, akpm@linux-foundation.org, hannes@cmpxchg.org, jack@suse.cz, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix races between address_space dereference and free in page_evicatable
has been added to the -mm tree.  Its filename is
     mm-fix-races-between-address_space-dereference-and-free-in-page_evicatable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-races-between-address_space-dereference-and-free-in-page_evicatable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-races-between-address_space-dereference-and-free-in-page_evicatable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm: fix races between address_space dereference and free in page_evicatable

When page_mapping() is called and the mapping is dereferenced in
page_evicatable() through shrink_active_list(), it is possible for the
inode to be truncated and the embedded address space to be freed at the
same time.  This may lead to the following race.

CPU1                                                CPU2

truncate(inode)                                     shrink_active_list()
  ...                                                 page_evictable(page)
  truncate_inode_page(mapping, page);
    delete_from_page_cache(page)
      spin_lock_irqsave(&mapping->tree_lock, flags);
        __delete_from_page_cache(page, NULL)
          page_cache_tree_delete(..)
            ...                                         mapping = page_mapping(page);
            page->mapping = NULL;
            ...
      spin_unlock_irqrestore(&mapping->tree_lock, flags);
      page_cache_free_page(mapping, page)
        put_page(page)
          if (put_page_testzero(page)) -> false
- inode now has no pages and can be freed including embedded address_space

                                                        mapping_unevictable(mapping)
							  test_bit(AS_UNEVICTABLE, &mapping->flags);
- we've dereferenced mapping which is potentially already free.

Similar race exists between swap cache freeing and page_evicatable() too.

The address_space in inode and swap cache will be freed after a RCU grace
period.  So the races are fixed via enclosing the page_mapping() and
address_space usage in rcu_read_lock/unlock().  Some comments are added in
code to make it clear what is protected by the RCU read lock.

Link: http://lkml.kernel.org/r/20180212081227.1940-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-fix-races-between-address_space-dereference-and-free-in-page_evicatable mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-races-between-address_space-dereference-and-free-in-page_evicatable
+++ a/mm/vmscan.c
@@ -3876,7 +3876,13 @@ int node_reclaim(struct pglist_data *pgd
  */
 int page_evictable(struct page *page)
 {
-	return !mapping_unevictable(page_mapping(page)) && !PageMlocked(page);
+	int ret;
+
+	/* Prevent address_space of inode and swap cache from being freed */
+	rcu_read_lock();
+	ret = !mapping_unevictable(page_mapping(page)) && !PageMlocked(page);
+	rcu_read_unlock();
+	return ret;
 }
 
 #ifdef CONFIG_SHMEM
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-fix-races-between-address_space-dereference-and-free-in-page_evicatable.patch
mm-swap-fix-race-between-swapoff-and-some-swap-operations.patch

