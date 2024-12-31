Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA02224FA;
	Tue, 31 Dec 2024 01:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610128; cv=none; b=dEGCqwbSXLiymuiKBZK32abCcTNcxom886IOk54MR72hFbvWmo2FKV/hWd1MFFMwJWQ8QHnXgH9GuBHhLefKB2QAAZ0dsjZ5Rq1aAX2M75sIP+1Er7sNYlgGjl9gSIRCqKPlfEMrDWtydEaj5/XNaZj9B2BoiDpLNfKLewW6/bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610128; c=relaxed/simple;
	bh=u+zDPh+CyZaJ6ba26CKP/9c74jaZsbdDEw6lwpoJ6oQ=;
	h=Date:To:From:Subject:Message-Id; b=g3S6fk3NRDI0gx+8iwuzoNBIHyVwO6ItBoEN4jpAABlXlX9GtZ98698IN/ft4DSS5qrOB4RQGJJFX+ONPwxZDT6Vs51fYmpvHipa4s6p0uECB05tzZXVmNlqBAPf7NdZ3aYfhlDBJuV/HSofUzPYt8ojkOqs/zHMfrnYYugRO8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MWHkhwmm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MWHkhwmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB7FC4CED2;
	Tue, 31 Dec 2024 01:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610127;
	bh=u+zDPh+CyZaJ6ba26CKP/9c74jaZsbdDEw6lwpoJ6oQ=;
	h=Date:To:From:Subject:From;
	b=MWHkhwmm5lovqfY4t//SCS9HruPt37hRVem5rmeOh6HT94HTSiQPGc7Adjq321vYt
	 h3dk/bJ1q1pTDjy5jJAMbUxe8pVYe2HYd8/OW+MeYdXa7xcccR7j5el7d7ybHzl9dm
	 07lqH9I8GlF6inTAD00ZGKFnzEbtAZMnVT2CpFzs=
Date: Mon, 30 Dec 2024 17:55:27 -0800
To: mm-commits@vger.kernel.org,yangerkun@huawei.com,stable@vger.kernel.org,chuck.lever@oracle.com,brauner@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maple_tree-reload-mas-before-the-second-call-for-mas_empty_area-fix.patch removed from -mm tree
Message-Id: <20241231015527.AAB7FC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix mas_alloc_cyclic() second search
has been removed from the -mm tree.  Its filename was
     maple_tree-reload-mas-before-the-second-call-for-mas_empty_area-fix.patch

This patch was dropped because it was folded into maple_tree-reload-mas-before-the-second-call-for-mas_empty_area.patch

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: maple_tree: fix mas_alloc_cyclic() second search
Date: Mon, 16 Dec 2024 14:01:12 -0500

The first search may leave the maple state in an error state.  Reset the
maple state before the second search so that the search has a chance of
executing correctly after an exhausted first search.

Link: https://lore.kernel.org/all/20241216060600.287B4C4CED0@smtp.kernel.org/
Link: https://lkml.kernel.org/r/20241216190113.1226145-2-Liam.Howlett@oracle.com
Fixes: 9b6713cc7522 ("maple_tree: Add mtree_alloc_cyclic()")
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Yang Erkun <yangerkun@huawei.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com> says:
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-reload-mas-before-the-second-call-for-mas_empty_area-fix
+++ a/lib/maple_tree.c
@@ -4346,7 +4346,6 @@ int mas_alloc_cyclic(struct ma_state *ma
 {
 	unsigned long min = range_lo;
 	int ret = 0;
-	struct ma_state m = *mas;
 
 	range_lo = max(min, *next);
 	ret = mas_empty_area(mas, range_lo, range_hi, 1);
@@ -4355,7 +4354,7 @@ int mas_alloc_cyclic(struct ma_state *ma
 		ret = 1;
 	}
 	if (ret < 0 && range_lo > min) {
-		*mas = m;
+		mas_reset(mas);
 		ret = mas_empty_area(mas, min, range_hi, 1);
 		if (ret == 0)
 			ret = 1;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-reload-mas-before-the-second-call-for-mas_empty_area.patch
test_maple_tree-test-exhausted-upper-limit-of-mtree_alloc_cyclic.patch

