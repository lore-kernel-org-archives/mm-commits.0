Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF5614A62A
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006496; cv=none; b=sDOjf57kBLY2v1LkRV7J4Hou9x3KvawJAy6gfQVta4qJoPAhqnkPMIgVd/wIVdvZT+ZdHQz2ozPUnMkYC/vth3bAmevtZsBQWiumkDtxnKC4GPFlTtYLh11XZ0WuMCy/2hle4R3/CIANVA2FE+MI3oM99dnk+ohiA+po8Evflng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006496; c=relaxed/simple;
	bh=LAEYtG/laRRHkjRAUg5XNJ222TUIS0ja2VqeaQOlU8o=;
	h=Date:To:From:Subject:Message-Id; b=Se64ZTOG0aNbgA2/JMY7ouVDTbx+LGr1WSt4WqSTGWInVp4zaVMuqyKEceOHYm2lmvdsr3w0J+ftY2G5wqMDlOLzxaf5PTCgBUIHd4lcx/1F9rDW1vI2nvtWwW1du3T3eG58Z6H3d04hYMTOKnSSbzQyzHy7E/pOT9RfYiWZNaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qNO9CB0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qNO9CB0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C8CC4CED6;
	Thu, 16 Jan 2025 05:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006495;
	bh=LAEYtG/laRRHkjRAUg5XNJ222TUIS0ja2VqeaQOlU8o=;
	h=Date:To:From:Subject:From;
	b=qNO9CB0WEDmPUKsfaA4qrh/YuWW1kvIfvWbHwqNdF/BgTOf0o6zq6z0ZcHNzP7QGX
	 9wxYmbKyYjMHtYMNqylET2b3//hcjOG9sdNwvZIwairRmPH+htPr9gbfGnQgVKUvh6
	 2O1/dOJ298J8f6WtEIFuFpmC2jfG+MV2Qw8Xe2wM=
Date: Wed, 15 Jan 2025 21:48:15 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xarray-distinguish-large-entries-correctly-in-xas_split_alloc.patch removed from -mm tree
Message-Id: <20250116054815.D4C8CC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Xarray: distinguish large entries correctly in xas_split_alloc()
has been removed from the -mm tree.  Its filename was
     xarray-distinguish-large-entries-correctly-in-xas_split_alloc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: Xarray: distinguish large entries correctly in xas_split_alloc()
Date: Fri, 13 Dec 2024 20:25:21 +0800

We don't support large entries which expand two more level xa_node in
split.  For case "xas->xa_shift + 2 * XA_CHUNK_SHIFT == order", we also
need two level of xa_node to expand.  Distinguish entry as large entry in
case "xas->xa_shift + 2 * XA_CHUNK_SHIFT == order".

As max order of folio in pagecache (MAX_PAGECACHE_ORDER) is <=
(XA_CHUNK_SHIFT * 2 - 1), this change is more likely a cleanup...

Link: https://lkml.kernel.org/r/20241213122523.12764-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Mattew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/xarray.c~xarray-distinguish-large-entries-correctly-in-xas_split_alloc
+++ a/lib/xarray.c
@@ -1027,7 +1027,7 @@ void xas_split_alloc(struct xa_state *xa
 	unsigned int mask = xas->xa_sibs;
 
 	/* XXX: no support for splitting really large entries yet */
-	if (WARN_ON(xas->xa_shift + 2 * XA_CHUNK_SHIFT < order))
+	if (WARN_ON(xas->xa_shift + 2 * XA_CHUNK_SHIFT <= order))
 		goto nomem;
 	if (xas->xa_shift + XA_CHUNK_SHIFT > order)
 		return;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


