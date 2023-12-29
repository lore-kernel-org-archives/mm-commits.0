Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3CF14003
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N+AOpmB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB434C433C9;
	Fri, 29 Dec 2023 20:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880101;
	bh=Y4Fjp7zaT7HTRxSOiDMiJJxa4izNdCM8yjf2/8HbbOo=;
	h=Date:To:From:Subject:From;
	b=N+AOpmB1ayoWTXHd437wIpaDY7BFtt52b7qWvgr/VBW5fem3cUB2vioNA12Z3xQev
	 11GuTBdU6E/v5N47vkdhQwyFgvUChDBUzw10pMaFo+6gIFcf714+YM9xbAF5zgm3df
	 Y0atdEeMpY3FLfe2t7fqTYypOhjjBmYE44SWWwfc=
Date: Fri, 29 Dec 2023 12:01:40 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-page_add_anon_rmap-folio_add_anon_rmap_pte.patch removed from -mm tree
Message-Id: <20231229200140.EB434C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: page_add_anon_rmap() -> folio_add_anon_rmap_pte()
has been removed from the -mm tree.  Its filename was
     mm-migrate-page_add_anon_rmap-folio_add_anon_rmap_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/migrate: page_add_anon_rmap() -> folio_add_anon_rmap_pte()
Date: Wed, 20 Dec 2023 23:44:41 +0100

Let's convert remove_migration_pte().

Link: https://lkml.kernel.org/r/20231220224504.646757-18-david@redhat.com
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

 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migrate-page_add_anon_rmap-folio_add_anon_rmap_pte
+++ a/mm/migrate.c
@@ -259,8 +259,8 @@ static bool remove_migration_pte(struct
 #endif
 		{
 			if (folio_test_anon(folio))
-				page_add_anon_rmap(new, vma, pvmw.address,
-						   rmap_flags);
+				folio_add_anon_rmap_pte(folio, new, vma,
+							pvmw.address, rmap_flags);
 			else
 				folio_add_file_rmap_pte(folio, new, vma);
 			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
_

Patches currently in -mm which might be from david@redhat.com are


