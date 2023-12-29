Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC4A13AE3
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r1EEQO3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19817C433C8;
	Fri, 29 Dec 2023 20:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880108;
	bh=52ka9rRV0dLMQXyCwhZnsoAsrOpTC8LnlZrZ4AYn6GA=;
	h=Date:To:From:Subject:From;
	b=r1EEQO3WqgA7nieyi01xyGw5o11qvvx4Cf+wSI58IFgxAVbnpAupQW2MN8OpEMK/b
	 f0o3iV7JpHeIaSqjcTMwrEoLYAXQnv2wNXe9RJabMTfoFofzXrPq4bffhlXfwIf9PO
	 C1VhCwA5BRerDJbYg0kJ4Ranae+39E1GJwNuKsrc=
Date: Fri, 29 Dec 2023 12:01:47 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kernel-events-uprobes-page_remove_rmap-folio_remove_rmap_pte.patch removed from -mm tree
Message-Id: <20231229200148.19817C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/events/uprobes: page_remove_rmap() -> folio_remove_rmap_pte()
has been removed from the -mm tree.  Its filename was
     kernel-events-uprobes-page_remove_rmap-folio_remove_rmap_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: kernel/events/uprobes: page_remove_rmap() -> folio_remove_rmap_pte()
Date: Wed, 20 Dec 2023 23:44:48 +0100

Let's convert __replace_page().

Link: https://lkml.kernel.org/r/20231220224504.646757-25-david@redhat.com
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

 kernel/events/uprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/uprobes.c~kernel-events-uprobes-page_remove_rmap-folio_remove_rmap_pte
+++ a/kernel/events/uprobes.c
@@ -198,7 +198,7 @@ static int __replace_page(struct vm_area
 		set_pte_at_notify(mm, addr, pvmw.pte,
 				  mk_pte(new_page, vma->vm_page_prot));
 
-	page_remove_rmap(old_page, vma, false);
+	folio_remove_rmap_pte(old_folio, old_page, vma);
 	if (!folio_mapped(old_folio))
 		folio_free_swap(old_folio);
 	page_vma_mapped_walk_done(&pvmw);
_

Patches currently in -mm which might be from david@redhat.com are


