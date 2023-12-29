Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2443013FE3
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pWzvVkdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F7FC433C8;
	Fri, 29 Dec 2023 20:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880094;
	bh=NG0ydUGk5EQJCI0jgYkovugkX+D4CssiX+8e8YnByCQ=;
	h=Date:To:From:Subject:From;
	b=pWzvVkdAT3rpm31iaNEfwR9iK/RWVAyMGb9o4uFssytzU1bTAyZJjX6dfbmzAY10P
	 oOoB1IWmuZOjBFvxG/yGoZ9aS10XWF00+WXSS/LN6OPI1SKLawOXdrOTB8O3sb7ENM
	 7m0yFdKxxe39hHvTKv3/aKgu6if1CCaTv5LPNucU=
Date: Fri, 29 Dec 2023 12:01:33 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-page_add_file_rmap-folio_add_file_rmap_pte.patch removed from -mm tree
Message-Id: <20231229200133.E0F7FC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: page_add_file_rmap() -> folio_add_file_rmap_pte()
has been removed from the -mm tree.  Its filename was
     mm-migrate-page_add_file_rmap-folio_add_file_rmap_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/migrate: page_add_file_rmap() -> folio_add_file_rmap_pte()
Date: Wed, 20 Dec 2023 23:44:34 +0100

Let's convert remove_migration_pte().

Link: https://lkml.kernel.org/r/20231220224504.646757-11-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-page_add_file_rmap-folio_add_file_rmap_pte
+++ a/mm/migrate.c
@@ -262,7 +262,7 @@ static bool remove_migration_pte(struct
 				page_add_anon_rmap(new, vma, pvmw.address,
 						   rmap_flags);
 			else
-				page_add_file_rmap(new, vma, false);
+				folio_add_file_rmap_pte(folio, new, vma);
 			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
 		}
 		if (vma->vm_flags & VM_LOCKED)
_

Patches currently in -mm which might be from david@redhat.com are


