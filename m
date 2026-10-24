Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832286;
	b=Z4AUuZlsQ9POJTkqRDBx6jj2PIqvdZhXLoZcAzYJdpocZIduUjfBE1r48VAvtnBMipsK
	 NnVuFkERX1V48590ivJEKaEp2Wvq57quMrFCvnoW+/lT9WBcElpvszQN9AB4fITgwxGd3
	 +nd1glUqYMP2dFQuqSIddv7smagg+2FdYIvHrCB6GlrvTdaMt0+0fy4o0lNj4tBljqxX0
	 XkgeBpTIWuQm2tcJVnif2+cU9Ll3q4/3QcqwXS7hkD3JgaZvgGG4ree8pSMnWA+J32xd/
	 oGZGr1tkDndtW820ENTxtiakDEShEJa3OqN+8yUKQSxwYNJTE58sjxBQFw0x/IB3dqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832286;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=pYI9BtUyammAg9xMRlFjuAy+i+Ll43p5n2rmCEKjl5E=;
	b=n8xFfgYdhFPW+V4DDG840RYAqAJQE8sDzUD3GVfOwdCQC8GpmbSv5lPTmJoIwmDavprh
	 E3vi5WYCvFWskpeSpLvk9sM/ll8wDq9OTWg6fq1AJtQLRD7S9Kw1nWcrrZBpCh+nEHWQ0
	 u028JRg3fevgHMcu/dW058IrJA8Eoo7AUkAKj49l2DitXr+xG+EgOPJ1+NdfV6t+Dt9sI
	 i/pBGfSV1lGLXF/sWFIf+pYWsHA5NT8Fnrp5SFoDnD5vq6zfaZWH6PotkU+Zi1ILsn0ak
	 O3p4PsGE6BHRaIM3nWO3BjfQyxxtKVV7P7GyzOh8/BB07gfBV4E/GNYhEgGmhNmcrHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NqtRnLWr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C2D606A31F;
	Sat, 24 Oct 2026 08:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NqtRnLWr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365F41F01828;
	Sat, 24 Oct 2026 08:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832286;
	bh=pYI9BtUyammAg9xMRlFjuAy+i+Ll43p5n2rmCEKjl5E=;
	h=Date:To:From:Subject;
	b=NqtRnLWrG23Zp0Ezx33EgQDfblmguoL2osBhjPuiwMKrestH6Y3uTboPteaXDe/J5
	 xf+Sy6KioZSFSl7rtWblQCfS8nkCJCbOb5LWdCnRYqQ717Ox6jUpYMzFZsvJFTw+Gy
	 7xTF/1IzsFECnYPnXslBvNUsd5JDnUPRGcpEc/gQ=
Date: Sat, 24 Oct 2026 01:58:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yukuai@fnnas.com,yizhang089@gmail.com,yangerkun@huawei.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sashiko-bot@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,joannelkoong@gmail.com,jack@suse.cz,hughd@google.com,djwong@kernel.org,david@kernel.org,chengzhihao1@huawei.com,bfoster@redhat.com,baolin.wang@linux.alibaba.com,yi.zhang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-truncate-look-up-the-end-edge-straddler-by-index.patch removed from -mm tree
Message-Id: <20261024085806.365F41F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/truncate: look up the end-edge straddler by index
has been removed from the -mm tree.  Its filename was
     mm-truncate-look-up-the-end-edge-straddler-by-index.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Yi <yi.zhang@huawei.com>
Subject: mm/truncate: look up the end-edge straddler by index
Date: Mon, 28 Sep 2026 20:08:31 +0800

In truncate_inode_partial_folio(), after the first split at the start
edge, folio_split() unlocks and drops the refcount of the after-split
sub-folios.  The sub-folio straddling the end of the truncation range is
therefore unlocked and only transiently ref'd in the page cache while the
code still derives it from a page pointer inside the original folio.

Between the first split finishing and page_folio() resolving split_at2,
that tail page can be reclaimed, freed and reallocated as a new large
folio in the same mapping at a different file offset.  folio2 then points
at a folio that does not cover the end boundary, yet folio2->mapping ==
folio->mapping still holds, so the stale pointer passes the mapping check
and folio_split_or_unmap() splits a folio at a wrong position (or, with a
transient refcount, a use-after-free window opens between try_get and the
split).  __folio_split()'s own folio != page_folio(split_at) check cannot
catch this either since split_at2 has been reallocated as part of the new
folio, so page_folio(split_at2) resolves back to folio2.

Look the straddler up by its page index instead.  __filemap_get_folio()
returns the folio currently covering the boundary, ref'd and locked, with
the mapping validated under the lock, so the split target is always the
real folio at the end edge.

Link: https://lore.kernel.org/20260928120833.3440834-3-yi.zhang@huaweicloud.com
Link: https://lore.kernel.org/linux-mm/DLGXT0ERY79Z.3C5DYVJVX6S9Z@nvidia.com/
Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/message/20260916094500.C30061F00893%40smtp.kernel.org
Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Zi Yan <ziy@nvidia.com>
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
Cc: <stable@vger.kernel.org>
---

 mm/truncate.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/mm/truncate.c~mm-truncate-look-up-the-end-edge-straddler-by-index
+++ a/mm/truncate.c
@@ -259,30 +259,32 @@ bool truncate_inode_partial_folio(struct
 		 * for shmem truncate
 		 */
 		struct folio *folio2;
+		pgoff_t end_idx;
 
 		if (offset + length == size)
 			goto no_split;
 
-		split_at2 = folio_page(folio,
-				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
-		folio2 = page_folio(split_at2);
-
-		if (!folio_try_get(folio2))
+		/*
+		 * After the first split at the start edge, the folio at the
+		 * end edge may be freed and reused concurrently.
+		 * __filemap_get_folio() looks up the straddler at end_idx
+		 * and returns it locked and ref'd with the mapping
+		 * validated.
+		 */
+		end_idx = (pos + offset + length) >> PAGE_SHIFT;
+		folio2 = __filemap_get_folio(folio->mapping, end_idx,
+					     FGP_LOCK | FGP_NOWAIT, 0);
+		if (IS_ERR(folio2))
 			goto no_split;
 
+		/* make sure folio2 is large */
 		if (!folio_test_large(folio2))
 			goto out;
 
-		if (!folio_trylock(folio2))
-			goto out;
-
-		/* make sure folio2 is large and does not change its mapping */
-		if (folio_test_large(folio2) &&
-		    folio2->mapping == folio->mapping)
-			folio_split_or_unmap(folio2, split_at2, min_order);
-
-		folio_unlock(folio2);
+		split_at2 = folio_page(folio2, (end_idx - folio2->index));
+		folio_split_or_unmap(folio2, split_at2, min_order);
 out:
+		folio_unlock(folio2);
 		folio_put(folio2);
 no_split:
 		return true;
_

Patches currently in -mm which might be from yi.zhang@huawei.com are


