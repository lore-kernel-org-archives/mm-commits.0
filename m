Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A818635;
	Sat, 13 Sep 2025 20:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757794162; cv=none; b=P5UkiJ2Pv0ilBYW8k2eZyCeMBqTNukFQ6NDnzOL7ufthFKYoPG/AoEL86LJ9lIat/LJq8+ZQr0YU/vuSMzq1b+AJ4iTiENNMDe06H/KaAqXM3YaUjMziNU3HZrsrVyfuqfcsThmJo+4wyx4IImArBSiy1qWoDgLVS8GEq4pmbus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757794162; c=relaxed/simple;
	bh=lYbzApe4nVRI3RP7ZDHFu+pB/5At6W71kgFlLi8fCIg=;
	h=Date:To:From:Subject:Message-Id; b=DTAOG1W76iywOwZuJCQivnAL14Uezs9f/1zywJB41UHtkPQhh8NA4Y+gvsrbTvQXOTbubbjJ2uWL61h6LLSxciyVR+SRnboZbFIgtQ0yp0TrkudRJWo0Wj6Vjvmwi96pW636crVCgrZZaflbzTyO9/uLfm80ofniOiztIUVqdM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BajHE4D7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BajHE4D7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C899FC4CEEB;
	Sat, 13 Sep 2025 20:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757794160;
	bh=lYbzApe4nVRI3RP7ZDHFu+pB/5At6W71kgFlLi8fCIg=;
	h=Date:To:From:Subject:From;
	b=BajHE4D7N5CwkMaGeZNVK9mmYt7SFVsN2Aon2eGoDNr26SWhaO1FCTER2dRjDyFNX
	 3u5q69iVyk7Lr26yxn3RY2QGpGWyNkLh8A3zq6FL6WQ4k1uukUABbaVep54VyxvTDI
	 E1L2GYcGdpctJuD4ecfio8eKQpCjV5FprrtH4PvU=
Date: Sat, 13 Sep 2025 13:09:20 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,yangge1116@126.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,stable@vger.kernel.org,shivankg@amd.com,riel@surriel.com,peterx@redhat.com,lizhe.67@bytedance.com,koct9i@gmail.com,keirf@google.com,kas@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,axelrasmussen@google.com,aneesh.kumar@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-gup-check-ref_count-instead-of-lru-before-migration.patch removed from -mm tree
Message-Id: <20250913200920.C899FC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: check ref_count instead of lru before migration
has been removed from the -mm tree.  Its filename was
     mm-gup-check-ref_count-instead-of-lru-before-migration.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/gup: check ref_count instead of lru before migration
Date: Mon, 8 Sep 2025 15:15:03 -0700 (PDT)

Patch series "mm: better GUP pin lru_add_drain_all()", v2.

Series of lru_add_drain_all()-related patches, arising from recent mm/gup
migration report from Will Deacon.


This patch (of 5):

Will Deacon reports:-

When taking a longterm GUP pin via pin_user_pages(),
__gup_longterm_locked() tries to migrate target folios that should not be
longterm pinned, for example because they reside in a CMA region or
movable zone.  This is done by first pinning all of the target folios
anyway, collecting all of the longterm-unpinnable target folios into a
list, dropping the pins that were just taken and finally handing the list
off to migrate_pages() for the actual migration.

It is critically important that no unexpected references are held on the
folios being migrated, otherwise the migration will fail and
pin_user_pages() will return -ENOMEM to its caller.  Unfortunately, it is
relatively easy to observe migration failures when running pKVM (which
uses pin_user_pages() on crosvm's virtual address space to resolve stage-2
page faults from the guest) on a 6.15-based Pixel 6 device and this
results in the VM terminating prematurely.

In the failure case, 'crosvm' has called mlock(MLOCK_ONFAULT) on its
mapping of guest memory prior to the pinning.  Subsequently, when
pin_user_pages() walks the page-table, the relevant 'pte' is not present
and so the faulting logic allocates a new folio, mlocks it with
mlock_folio() and maps it in the page-table.

Since commit 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page() batch
by pagevec"), mlock/munlock operations on a folio (formerly page), are
deferred.  For example, mlock_folio() takes an additional reference on the
target folio before placing it into a per-cpu 'folio_batch' for later
processing by mlock_folio_batch(), which drops the refcount once the
operation is complete.  Processing of the batches is coupled with the LRU
batch logic and can be forcefully drained with lru_add_drain_all() but as
long as a folio remains unprocessed on the batch, its refcount will be
elevated.

This deferred batching therefore interacts poorly with the pKVM pinning
scenario as we can find ourselves in a situation where the migration code
fails to migrate a folio due to the elevated refcount from the pending
mlock operation.

Hugh Dickins adds:-

!folio_test_lru() has never been a very reliable way to tell if an
lru_add_drain_all() is worth calling, to remove LRU cache references to
make the folio migratable: the LRU flag may be set even while the folio is
held with an extra reference in a per-CPU LRU cache.

5.18 commit 2fbb0c10d1e8 may have made it more unreliable.  Then 6.11
commit 33dfe9204f29 ("mm/gup: clear the LRU flag of a page before adding
to LRU batch") tried to make it reliable, by moving LRU flag clearing; but
missed the mlock/munlock batches, so still unreliable as reported.

And it turns out to be difficult to extend 33dfe9204f29's LRU flag
clearing to the mlock/munlock batches: if they do benefit from batching,
mlock/munlock cannot be so effective when easily suppressed while !LRU.

Instead, switch to an expected ref_count check, which was more reliable
all along: some more false positives (unhelpful drains) than before, and
never a guarantee that the folio will prove migratable, but better.

Note on PG_private_2: ceph and nfs are still using the deprecated
PG_private_2 flag, with the aid of netfs and filemap support functions. 
Although it is consistently matched by an increment of folio ref_count,
folio_expected_ref_count() intentionally does not recognize it, and ceph
folio migration currently depends on that for PG_private_2 folios to be
rejected.  New references to the deprecated flag are discouraged, so do
not add it into the collect_longterm_unpinnable_folios() calculation: but
longterm pinning of transiently PG_private_2 ceph and nfs folios (an
uncommon case) may invoke a redundant lru_add_drain_all().  And this makes
easy the backport to earlier releases: up to and including 6.12, btrfs
also used PG_private_2, but without a ref_count increment.

Note for stable backports: requires 6.16 commit 86ebd50224c0 ("mm:
add folio_expected_ref_count() for reference count calculation").

Link: https://lkml.kernel.org/r/41395944-b0e3-c3ac-d648-8ddd70451d28@google.com
Link: https://lkml.kernel.org/r/bd1f314a-fca1-8f19-cac0-b936c9614557@google.com
Fixes: 9a4e9f3b2d73 ("mm: update get_user_pages_longterm to migrate pages allocated from CMA region")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Will Deacon <will@kernel.org>
Closes: https://lore.kernel.org/linux-mm/20250815101858.24352-1-will@kernel.org/
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Keir Fraser <keirf@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: yangge <yangge1116@126.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-check-ref_count-instead-of-lru-before-migration
+++ a/mm/gup.c
@@ -2307,7 +2307,8 @@ static unsigned long collect_longterm_un
 			continue;
 		}
 
-		if (!folio_test_lru(folio) && drain_allow) {
+		if (drain_allow && folio_ref_count(folio) !=
+				   folio_expected_ref_count(folio) + 1) {
 			lru_add_drain_all();
 			drain_allow = false;
 		}
_

Patches currently in -mm which might be from hughd@google.com are

mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

