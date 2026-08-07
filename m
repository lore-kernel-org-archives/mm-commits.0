Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5517A3B6C0C
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068116; cv=none; b=Eo3RdJiiUzNN4H2mh7CBGOl6gVVmB6zNFCacNW0mi8PoL8C/eROxyvCt31RBUqjX1kyRhv2pf3m6FuEEQbjacbwe3uuICia4pyUqVG6tw5oHoDnSUSxAdKZix680JuMs3Pzj4Ooj3bqO2UlTNRR/qdFn7KrHS5sky57nBj4L2v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068116; c=relaxed/simple;
	bh=p+1HAI5D8fitfGaw/l0Ge0Dgywv5FkRd8BDImbeg5qQ=;
	h=Date:To:From:Subject:Message-Id; b=Mhj6BU7WjmONXMDTX5YFcE8Tzx4ji1QShjcX72BTtAMsdvulPd4ylgnPpzYK9PhQjp6HSIhSDjbwz+Baj7qmNBjVzFHFzmIG6v24bKe6mgdUA51e6+opT5dLzfaq+yzmptWL0PepqdNTGzTC2i1sKj4ZBh94FWjCFYY20YxjTEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RTgNBouI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RTgNBouI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0491F000E9;
	Fri,  7 Aug 2026 02:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068115;
	bh=nnpwcYvoKyk2DBNajJTVFB6L7Vpz9Jgqt2DS46c5LJQ=;
	h=Date:To:From:Subject;
	b=RTgNBouIVSIHHRr47u/XZLG8JaoSwGwBRSIx8ntS5UsMa5Bi91yXUOMTMwV5r0fpp
	 mGcryRUZUn7761QbYL1li7FTt/YZdIVRiZDVNVmOD+pHnN0JGWIT05F20CNeNZ+Yz0
	 jk+7I09hrUhZQrp847xv6B8SmJZO56qaW8e93pqU=
Date: Thu, 06 Aug 2026 19:01:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-fold-split_folio_to_list_to_order-into-split_folio_to_order.patch removed from -mm tree
Message-Id: <20260807020154.EA0491F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: fold split_folio_to_list_to_order() into split_folio_to_order()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fold-split_folio_to_list_to_order-into-split_folio_to_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/huge_memory: fold split_folio_to_list_to_order() into split_folio_to_order()
Date: Thu, 16 Jul 2026 11:03:45 +0100

split_folio_to_list_to_order() had no direct callers; its only user was
split_folio_to_order(), which always passed a NULL list.  Fold it into
split_folio_to_order() and call split_huge_page_to_list_to_order()
directly.

No functional change.

Link: https://lore.kernel.org/20260716100345.473473-3-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-fold-split_folio_to_list_to_order-into-split_folio_to_order
+++ a/include/linux/huge_mm.h
@@ -823,15 +823,9 @@ static inline bool is_pmd_order(unsigned
 	return order == HPAGE_PMD_ORDER;
 }
 
-static inline int split_folio_to_list_to_order(struct folio *folio,
-		struct list_head *list, int new_order)
-{
-	return split_huge_page_to_list_to_order(&folio->page, list, new_order);
-}
-
 static inline int split_folio_to_order(struct folio *folio, int new_order)
 {
-	return split_folio_to_list_to_order(folio, NULL, new_order);
+	return split_huge_page_to_list_to_order(&folio->page, NULL, new_order);
 }
 
 /**
_

Patches currently in -mm which might be from kas@kernel.org are


