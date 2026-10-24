Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832290;
	b=B6wrJy7JIaM0IPpmKlWG+oqM1nZcf9+cig9zNsJ5lOR163n85ks7cpWg8VlT1SAJC+wH
	 MyhIf1VDAk/rwXitytDncrurRMNsMvw17zhjtOx2AnPmGq7WeoDaIWgRpCRXz+lZpfyVr
	 ge+X72h0RiaYVVa625EsQdLTA7fuvm4l0m9yIJmAljFb09ENhKkxGP3TqrFjDyNnfypKH
	 JMjNYr54OmicsHy4yaT4860rwnF5lC/f7otvXA6AqJyHldny0hGvS7xL83r1tzGqIWM1f
	 WuXOsbcPtp3wGFUrPptb51TgstIbffy/JVNGwU5WEbP8GfOJPzOWgbSRGjpcaV8HIYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832290;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=z7S6T5ypqVTGYypkxzxasK37FNkhnKX+r9SKB5cw1EQ=;
	b=4TFI2vyoJzIXeVXfDKun4MJDV/c0s9lhIyL4yMy4wJ70fCDlwsn5OCbEe5wrJ9h6vS/h
	 ZTKvvE47V/wpExqojp6EmO62qzEddIY/gjyT1//Lx9rYWlRUT2fsOYTbOx8Q/9Uia0ATP
	 DWFP2Pk3dbJhD+2PPV3opv8qTW7+ZOiB51rRc80WFz3o1Ndh0Mi1C6bK71vVNHWYIJ/LF
	 20OkOmsoGQbFwStrlgIWn8p0Wjl18rkksDYjFgfY9vdy1F9wZQiJS7I2gN2/iT71dXHRz
	 CkSp3CGdbWyuk3xOGveFTOZNazHnLSVN7UdG/WF9nTTtSUFJ7V7WFl0z++dsP9+yOGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="pITiM/nf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE489606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pITiM/nf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF741F01825;
	Sat, 24 Oct 2026 08:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832289;
	bh=z7S6T5ypqVTGYypkxzxasK37FNkhnKX+r9SKB5cw1EQ=;
	h=Date:To:From:Subject;
	b=pITiM/nfOMmw/QzQ/4omWptaB3Vvamo+iHnxYVKl7oqJCtzPouokWOgDTbESvYdja
	 gh8QrP4vJTBTkM5T4aKxmwtZscanbVXO+EXS0A6UNL0UchjUNPpI35uIV7lyGUMgo1
	 aVQxNbFG7O6Nq50w++ejTcy+d4RcRSiLQEWlEXXc=
Date: Sat, 24 Oct 2026 01:58:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yukuai@fnnas.com,yizhang089@gmail.com,yangerkun@huawei.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,joannelkoong@gmail.com,jack@suse.cz,hughd@google.com,djwong@kernel.org,david@kernel.org,chengzhihao1@huawei.com,bfoster@redhat.com,baolin.wang@linux.alibaba.com,yi.zhang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-truncate-clarify-return-value-of-truncate_inode_partial_folio.patch removed from -mm tree
Message-Id: <20261024085809.BBF741F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/truncate: clarify return value of truncate_inode_partial_folio()
has been removed from the -mm tree.  Its filename was
     mm-truncate-clarify-return-value-of-truncate_inode_partial_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Yi <yi.zhang@huawei.com>
Subject: mm/truncate: clarify return value of truncate_inode_partial_folio()
Date: Mon, 28 Sep 2026 20:08:33 +0800

With the earlier rework the callers no longer rely on the return value of
truncate_inode_partial_folio() to decide whether to adjust the truncation
range.  The pstart/pend out-parameters carry that information instead. 
The callers now only use the return value as a flag indicating whether the
loop should be reset to pick up newly split sub-folios on the shmem path.

Return true if at least one split succeeded, and false otherwise.  This
clarifies the existing confusing return value semantics.

Link: https://lore.kernel.org/20260928120833.3440834-5-yi.zhang@huaweicloud.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: <yizhang089@gmail.com>
Cc: Yang Erkun <yangerkun@huawei.com>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <yukuai@fnnas.com>
---

 mm/truncate.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/truncate.c~mm-truncate-clarify-return-value-of-truncate_inode_partial_folio
+++ a/mm/truncate.c
@@ -216,8 +216,7 @@ static int folio_split_or_unmap(struct f
  * aligned inwards to min_order, i.e. the range of folios wholly within
  * [lstart, lend] and so safe to discard.
  *
- * Returns false if splitting failed so the caller can avoid
- * discarding the entire folio which is stubbornly unsplit.
+ * Return %true if at least one split succeeded, %false otherwise.
  */
 bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 				  loff_t lend, pgoff_t *pstart, pgoff_t *pend)
@@ -247,7 +246,7 @@ bool truncate_inode_partial_folio(struct
 	folio_wait_writeback(folio);
 	if (length == size) {
 		truncate_inode_folio(folio->mapping, folio);
-		return true;
+		return false;
 	}
 
 	/*
@@ -264,7 +263,7 @@ bool truncate_inode_partial_folio(struct
 	min_order = mapping_min_folio_order(folio->mapping);
 	min_nrbytes = mapping_min_folio_nrbytes(folio->mapping);
 	if (folio_order(folio) == min_order)
-		return true;
+		return false;
 
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
 	if (!folio_split_or_unmap(folio, split_at, min_order)) {
@@ -327,10 +326,9 @@ out:
 			*pend = end;
 		return true;
 	}
-	if (folio_test_dirty(folio))
-		return false;
-	truncate_inode_folio(folio->mapping, folio);
-	return true;
+	if (!folio_test_dirty(folio))
+		truncate_inode_folio(folio->mapping, folio);
+	return false;
 }
 
 /*
_

Patches currently in -mm which might be from yi.zhang@huawei.com are


