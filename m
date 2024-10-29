Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDB92003BC
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 03:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730174209; cv=none; b=HEyFsBUN6RbrWWSMqhdBkIqHCApKKHqmO+K2Wn7XbRyOaZEigVrxuomDGFdi/3NFqHFbB1KiTFUEM4wyqj2/hpF+apkPTzER6wUQC2cfmIJtWgTc8SH+5CpZ4mOcXKKuSd/x1bpSv/TDYlAmT/tGoarTfIGMOclMN2F4onPn7A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730174209; c=relaxed/simple;
	bh=dUBWtH7ro6ikay/iwkdEWN2MgOSDpxlsqhfZd5OKrm0=;
	h=Date:To:From:Subject:Message-Id; b=LI5HufNSjoYbEuRJmgqEESb9ZeVRY9/jWxiNHR6xDqSAdCP21dEeonWu5/+gl5O0LrY5a2nmdffgDxwvLhkYD2VfVd9rfo2xICXbluRmmELpbcop/GNZ2WzR30gzCWQqaGYE+8y9AQt80bgN/mX3QUlCYyBaA77YR+z16nyBqSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Bi0T6n7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Bi0T6n7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C503DC4CECD;
	Tue, 29 Oct 2024 03:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730174208;
	bh=dUBWtH7ro6ikay/iwkdEWN2MgOSDpxlsqhfZd5OKrm0=;
	h=Date:To:From:Subject:From;
	b=0Bi0T6n7wbBmuIVMVzfex22Ac/4okS3w0URrwZyLg648avaLD1i924dXqkDG00miV
	 ImHF4My4duQrgeG9TA7f+uV3rUgbP2O7ldMXD7A3TwHLIMxrVHVLivmzWnpmX6jnzh
	 uLRtmzZwoB6eRKN41Zn4QozF+kpamQghdM4Eiie8=
Date: Mon, 28 Oct 2024 20:56:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,usamaarif642@gmail.com,shy828301@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,richard.weiyang@gmail.com,nphamcs@gmail.com,kirill.shutemov@linux.intel.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-fix-deferred-split-queue-not-partially_mapped.patch added to mm-hotfixes-unstable branch
Message-Id: <20241029035648.C503DC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/thp: fix deferred split queue not partially_mapped
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-thp-fix-deferred-split-queue-not-partially_mapped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-fix-deferred-split-queue-not-partially_mapped.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: fix deferred split queue not partially_mapped
Date: Sun, 27 Oct 2024 12:59:34 -0700 (PDT)

Recent changes are putting more pressure on THP deferred split queues:
under load revealing long-standing races, causing list_del corruptions,
"Bad page state"s and worse (I keep BUGs in both of those, so usually
don't get to see how badly they end up without).  The relevant recent
changes being 6.8's mTHP, 6.10's mTHP swapout, and 6.12's mTHP swapin,
improved swap allocation, and underused THP splitting.

The new unlocked list_del_init() in deferred_split_scan() is buggy.  I
gave bad advice, it looks plausible since that's a local on-stack list,
but the fact is that it can race with a third party freeing or migrating
the preceding folio (properly unqueueing it with refcount 0 while holding
split_queue_lock), thereby corrupting the list linkage.

The obvious answer would be to take split_queue_lock there: but it has a
long history of contention, so I'm reluctant to add to that.  Instead,
make sure that there is always one safe (raised refcount) folio before, by
delaying its folio_put().  (And of course I was wrong to suggest updating
split_queue_len without the lock: leave that until the splice.)

And remove two over-eager partially_mapped checks, restoring those tests
to how they were before: if uncharge_folio() or free_tail_page_prepare()
finds _deferred_list non-empty, it's in trouble whether or not that folio
is partially_mapped (and the flag was already cleared in the latter case).

Link: https://lkml.kernel.org/r/81e34a8b-113a-0701-740e-2135c97eb1d7@google.com
Fixes: dafff3f4c850 ("mm: split underused THPs")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   21 +++++++++++++++++----
 mm/memcontrol.c  |    3 +--
 mm/page_alloc.c  |    5 ++---
 3 files changed, 20 insertions(+), 9 deletions(-)

--- a/mm/huge_memory.c~mm-thp-fix-deferred-split-queue-not-partially_mapped
+++ a/mm/huge_memory.c
@@ -3718,8 +3718,8 @@ static unsigned long deferred_split_scan
 	struct deferred_split *ds_queue = &pgdata->deferred_split_queue;
 	unsigned long flags;
 	LIST_HEAD(list);
-	struct folio *folio, *next;
-	int split = 0;
+	struct folio *folio, *next, *prev = NULL;
+	int split = 0, removed = 0;
 
 #ifdef CONFIG_MEMCG
 	if (sc->memcg)
@@ -3775,15 +3775,28 @@ next:
 		 */
 		if (!did_split && !folio_test_partially_mapped(folio)) {
 			list_del_init(&folio->_deferred_list);
-			ds_queue->split_queue_len--;
+			removed++;
+		} else {
+			/*
+			 * That unlocked list_del_init() above would be unsafe,
+			 * unless its folio is separated from any earlier folios
+			 * left on the list (which may be concurrently unqueued)
+			 * by one safe folio with refcount still raised.
+			 */
+			swap(folio, prev);
 		}
-		folio_put(folio);
+		if (folio)
+			folio_put(folio);
 	}
 
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	list_splice_tail(&list, &ds_queue->split_queue);
+	ds_queue->split_queue_len -= removed;
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 
+	if (prev)
+		folio_put(prev);
+
 	/*
 	 * Stop shrinker if we didn't split any page, but the queue is empty.
 	 * This can happen if pages were freed under us.
--- a/mm/memcontrol.c~mm-thp-fix-deferred-split-queue-not-partially_mapped
+++ a/mm/memcontrol.c
@@ -4631,8 +4631,7 @@ static void uncharge_folio(struct folio
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 	VM_BUG_ON_FOLIO(folio_order(folio) > 1 &&
 			!folio_test_hugetlb(folio) &&
-			!list_empty(&folio->_deferred_list) &&
-			folio_test_partially_mapped(folio), folio);
+			!list_empty(&folio->_deferred_list), folio);
 
 	/*
 	 * Nobody should be changing or seriously looking at
--- a/mm/page_alloc.c~mm-thp-fix-deferred-split-queue-not-partially_mapped
+++ a/mm/page_alloc.c
@@ -966,9 +966,8 @@ static int free_tail_page_prepare(struct
 		break;
 	case 2:
 		/* the second tail page: deferred_list overlaps ->mapping */
-		if (unlikely(!list_empty(&folio->_deferred_list) &&
-		    folio_test_partially_mapped(folio))) {
-			bad_page(page, "partially mapped folio on deferred list");
+		if (unlikely(!list_empty(&folio->_deferred_list))) {
+			bad_page(page, "on deferred list");
 			goto out;
 		}
 		break;
_

Patches currently in -mm which might be from hughd@google.com are

mm-thp-fix-deferred-split-queue-not-partially_mapped.patch
mm-thp-fix-deferred-split-unqueue-naming-and-locking.patch
mm-delete-the-unused-put_pages_list.patch

