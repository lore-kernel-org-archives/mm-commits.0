Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFF7379C33;
	Thu, 27 Aug 2026 20:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787861309; cv=none; b=VjgYQRxhqDsbQlksLsLSkGLjC/UaOmXoQ3OIeafC2wItrCY1/O8rXbAe+8Ce4WQofejPT1ZS3ZCGx9EJTaxOv1lVU20BwIwpFK9Jv8PZhdL0KSmYt5R76qDFJ5OCnfxZIAG2XenQn4F1swPm12Dtunot/EiTnVLK57gdFjXKDu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787861309; c=relaxed/simple;
	bh=49CrmBTXJ/WTzXvxf1DuKPMLE7TJH+cZM6C61o46aJY=;
	h=Date:To:From:Subject:Message-Id; b=ss7Bizg0+o7bQzP1Fl5c/nEFw3x0Wk9oyD1Oo3Ld3/wpHz2pMfrWCx1+SG0RACb4tLEg64jnzctpkaorhDlUml9jkPiB6t/IdjXdCLgp67SNRkitblCHm5q+XCi/koOR2c/JAezx5coMn9ljnlEt9H0NZ35VVe2AWkI5ZcorBPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IwdR5RGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IwdR5RGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0469F1F000E9;
	Thu, 27 Aug 2026 20:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787861304;
	bh=/YUEziEWluRjG2aOf5jIPZe3zDXgWQg3+fpnSo/trgc=;
	h=Date:To:From:Subject;
	b=IwdR5RGxtYRNCCwcOvD7HLgHX+atQC5VvkzwtRiEpTIge6rhsyte6MjBgyvU8FChu
	 L8wJrjbAq4P8gliBDK96Nqj+DQVxgvPACWz7RFJFor1dSmG3iU28ymadrx+LTAaq9h
	 OID2hhmzl0y0SobB9GrMWVXSEsL1BgZ0eXyP+8AE=
Date: Thu, 27 Aug 2026 13:08:23 -0700
To: mm-commits@vger.kernel.org,tujinjiang@huawei.com,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-keep-max_huge_pages-when-dissolving-surplus-folios.patch removed from -mm tree
Message-Id: <20260827200824.0469F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: keep max_huge_pages when dissolving surplus folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-keep-max_huge_pages-when-dissolving-surplus-folios.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: mm/hugetlb: keep max_huge_pages when dissolving surplus folios
Date: Fri, 14 Aug 2026 16:30:27 +0800

dissolve_free_hugetlb_folio() can remove a free folio as surplus when its
node has surplus pages.  In that case remove_hugetlb_folio() decrements
both nr_huge_pages and surplus_huge_pages, leaving the persistent pool
size unchanged.

Updating max_huge_pages as if a persistent folio had been removed can
therefore corrupt the persistent pool target and underflow it when
max_huge_pages is zero.  Keep max_huge_pages unchanged for surplus folios,
including the vmemmap restoration rollback path.

Link: https://lore.kernel.org/20260814083027.1419487-1-xialonglong2025@163.com
Fixes: cb402bbdabca ("mm/hugetlb: fix surplus pages in dissolve_free_huge_page()")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Longlong Xia <xialonglong@kylinos.cn>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-keep-max_huge_pages-when-dissolving-surplus-folios
+++ a/mm/hugetlb.c
@@ -1992,7 +1992,8 @@ retry:
 		if (h->surplus_huge_pages_node[folio_nid(folio)])
 			adjust_surplus = true;
 		remove_hugetlb_folio(h, folio, adjust_surplus);
-		h->max_huge_pages--;
+		if (!adjust_surplus)
+			h->max_huge_pages--;
 		spin_unlock_irq(&hugetlb_lock);
 
 		/*
@@ -2012,7 +2013,8 @@ retry:
 			if (rc) {
 				spin_lock_irq(&hugetlb_lock);
 				add_hugetlb_folio(h, folio, adjust_surplus);
-				h->max_huge_pages++;
+				if (!adjust_surplus)
+					h->max_huge_pages++;
 				goto out;
 			}
 		} else {
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are


