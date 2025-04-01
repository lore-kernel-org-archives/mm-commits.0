Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D805E1E9B22
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545870; cv=none; b=YLxJorm8gmU9nUACcvayWyRDAkrxF1Q76dvbwTeZ+oxaI1DROFbeEnHzhxp2fIJTT1PfK/30K7TWl3eKznEePEFFNvHxIDzzymOPt/aeEIyEoXtnw4QVfMlLHnsxnRVYuJE7idHiX1R/N4mRjpYLpbYQQFGbth1hq0rNPy2GG/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545870; c=relaxed/simple;
	bh=CQuV4yLbSSECExfaIYFH9j1P4md3K/Yb1FPdfzLJkpg=;
	h=Date:To:From:Subject:Message-Id; b=hm1xvMRSha56OhIGCQY/QsrIYaerQNPrqzCHL84tQMBO8gm3vsZnobiDhvygYw/Cl7K97uK7DJqUS5zu7E2gyEpieJ3ekaQcEFsguDOeZHzgIbjQUQzJB7JSejhY9DlUFO+BvRcSc4ja5W9+5187hCVR5OQepiqQsntI/t+63Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KHE805Ol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KHE805Ol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA30C4CEE8;
	Tue,  1 Apr 2025 22:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545870;
	bh=CQuV4yLbSSECExfaIYFH9j1P4md3K/Yb1FPdfzLJkpg=;
	h=Date:To:From:Subject:From;
	b=KHE805OlL6HyzHtmpcUS+ovwKWoNX+HODbq4zkGNmUSJaHlz3VxUy7YPkii1CtYtj
	 omXfmYgaKfHd1ZNSR5BAFVjPv1+gsMlCNInFu/s+Yr83uVBt8iUE/ArwKreoTSPs1W
	 c3DlTdqnfF5cANRDuToYdZMz6p9OFyfdy05BYxyU=
Date: Tue, 01 Apr 2025 15:17:49 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,harry.yoo@oracle.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-do-not-set-vrm-vma-null-immediately-prior-to-checking-it.patch removed from -mm tree
Message-Id: <20250401221750.4CA30C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: do not set vrm->vma NULL immediately prior to checking it
has been removed from the -mm tree.  Its filename was
     mm-mremap-do-not-set-vrm-vma-null-immediately-prior-to-checking-it.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mremap: do not set vrm->vma NULL immediately prior to checking it
Date: Sun, 30 Mar 2025 17:20:48 +0100

This seems rather unwise.  If we cannot merge, extend, then we need to
recall the original VMA to see if we need to uncharge.

If we do need to, do so.

Link: https://lkml.kernel.org/r/b2fb6b9c-376d-4e9b-905e-26d847fd3865@lucifer.local
Fixes: d5c8aec0542e ("mm/mremap: initial refactor of move_vma()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-=by: "Lai, Yi" <yi1.lai@linux.intel.com>
Closes: https://lore.kernel.org/linux-mm/Z+lcvEIHMLiKVR1i@ly-workstation/
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-do-not-set-vrm-vma-null-immediately-prior-to-checking-it
+++ a/mm/mremap.c
@@ -1561,11 +1561,12 @@ static unsigned long expand_vma_in_place
 	 * adjacent to the expanded vma and otherwise
 	 * compatible.
 	 */
-	vma = vrm->vma = vma_merge_extend(&vmi, vma, vrm->delta);
+	vma = vma_merge_extend(&vmi, vma, vrm->delta);
 	if (!vma) {
 		vrm_uncharge(vrm);
 		return -ENOMEM;
 	}
+	vrm->vma = vma;
 
 	vrm_stat_account(vrm, vrm->delta);
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


