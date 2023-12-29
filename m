Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B58A14266
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MQPCQFNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064A1C433C8;
	Fri, 29 Dec 2023 20:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880100;
	bh=J2YNu4Ar03WcT5sIRpx5FQlugQomti0eoavkQMUhyaA=;
	h=Date:To:From:Subject:From;
	b=MQPCQFNM5vyfwp4KNbUZBUInsCqhwzT3LD6WGD1Q0nC3kuCl24fFerS4a0bWyTzI4
	 ZCKJvWxEN1JUJRcuyGCe8zyN3zXWCECydOAfy+vub28qHmI6KKqf548HGzd/mi6CZc
	 M68GfykWpqRt97QXOs4Fojj6OAKuzPgjLFrOZwEY=
Date: Fri, 29 Dec 2023 12:01:39 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-page_add_anon_rmap-folio_add_anon_rmap_pmd.patch removed from -mm tree
Message-Id: <20231229200140.064A1C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: page_add_anon_rmap() -> folio_add_anon_rmap_pmd()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-page_add_anon_rmap-folio_add_anon_rmap_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: page_add_anon_rmap() -> folio_add_anon_rmap_pmd()
Date: Wed, 20 Dec 2023 23:44:40 +0100

Let's convert remove_migration_pmd().  No need to set RMAP_COMPOUND, that
we will remove soon.

Link: https://lkml.kernel.org/r/20231220224504.646757-17-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-page_add_anon_rmap-folio_add_anon_rmap_pmd
+++ a/mm/huge_memory.c
@@ -3611,12 +3611,12 @@ void remove_migration_pmd(struct page_vm
 		pmde = pmd_mkdirty(pmde);
 
 	if (folio_test_anon(folio)) {
-		rmap_t rmap_flags = RMAP_COMPOUND;
+		rmap_t rmap_flags = RMAP_NONE;
 
 		if (!is_readable_migration_entry(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;
 
-		page_add_anon_rmap(new, vma, haddr, rmap_flags);
+		folio_add_anon_rmap_pmd(folio, new, vma, haddr, rmap_flags);
 	} else {
 		folio_add_file_rmap_pmd(folio, new, vma);
 	}
_

Patches currently in -mm which might be from david@redhat.com are


