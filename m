Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5151D6A6;
	Wed, 20 Dec 2023 21:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G5zlR/+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912B4C433CA;
	Wed, 20 Dec 2023 21:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703108835;
	bh=ZkHZmTSBSis0aY33L6Auk8UW7uAWgBgWxhWskaqgfF8=;
	h=Date:To:From:Subject:From;
	b=G5zlR/+IYBIGgp4SCuVtSctAaONIKnh4O6yTe7RA7ulcZqms2rp+lYSe7/43X+ltB
	 IurFjFbb9U8fYgDnyhnJl9QQJaZ+NyOflHAD9tP0WEJ32RwfnRmzFUepBIou/n3rVF
	 y8zhIRhURwahnhlSp/d8YI7U8JRaNj6WtXkp7YQE=
Date: Wed, 20 Dec 2023 13:47:15 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,shakeelb@google.com,n-horiguchi@ah.jp.nec.com,kirill.shutemov@linux.intel.com,hannes@cmpxchg.org,david@redhat.com,quic_charante@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate-high-order-folios-in-swap-cache-correctly.patch removed from -mm tree
Message-Id: <20231220214715.912B4C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate high-order folios in swap cache correctly
has been removed from the -mm tree.  Its filename was
     mm-migrate-high-order-folios-in-swap-cache-correctly.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm: migrate high-order folios in swap cache correctly
Date: Thu, 14 Dec 2023 04:58:41 +0000

Large folios occupy N consecutive entries in the swap cache instead of
using multi-index entries like the page cache.  However, if a large folio
is re-added to the LRU list, it can be migrated.  The migration code was
not aware of the difference between the swap cache and the page cache and
assumed that a single xas_store() would be sufficient.

This leaves potentially many stale pointers to the now-migrated folio in
the swap cache, which can lead to almost arbitrary data corruption in the
future.  This can also manifest as infinite loops with the RCU read lock
held.

[willy@infradead.org: modifications to the changelog & tweaked the fix]
Fixes: 3417013e0d18 ("mm/migrate: Add folio_migrate_mapping()")
Link: https://lkml.kernel.org/r/20231214045841.961776-1-willy@infradead.org
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Charan Teja Kalla <quic_charante@quicinc.com>
Closes: https://lkml.kernel.org/r/1700569840-17327-1-git-send-email-quic_charante@quicinc.com
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-high-order-folios-in-swap-cache-correctly
+++ a/mm/migrate.c
@@ -405,6 +405,7 @@ int folio_migrate_mapping(struct address
 	int dirty;
 	int expected_count = folio_expected_refs(mapping, folio) + extra_count;
 	long nr = folio_nr_pages(folio);
+	long entries, i;
 
 	if (!mapping) {
 		/* Anonymous page without mapping */
@@ -442,8 +443,10 @@ int folio_migrate_mapping(struct address
 			folio_set_swapcache(newfolio);
 			newfolio->private = folio_get_private(folio);
 		}
+		entries = nr;
 	} else {
 		VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
+		entries = 1;
 	}
 
 	/* Move dirty while page refs frozen and newpage not yet exposed */
@@ -453,7 +456,11 @@ int folio_migrate_mapping(struct address
 		folio_set_dirty(newfolio);
 	}
 
-	xas_store(&xas, newfolio);
+	/* Swap cache still stores N entries instead of a high-order entry */
+	for (i = 0; i < entries; i++) {
+		xas_store(&xas, newfolio);
+		xas_next(&xas);
+	}
 
 	/*
 	 * Drop cache reference from old page by unfreezing
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

mm-sparsemem-fix-race-in-accessing-memory_section-usage.patch
mm-sparsemem-fix-race-in-accessing-memory_section-usage-v2.patch

