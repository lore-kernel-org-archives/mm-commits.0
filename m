Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBBA1EDA1E
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119239; cv=none; b=WXaLPAj2D+qfTTZhEq8Yxmx39ygdxqoJ/XzIVY+beefdePGcSqmaf8SS9EK7krUs7xgG28It22vzc+h0Pk8QVsZo9y47wncvmPCnn0+vQN0/oNxevbT/zzQfy8oE0WpagcujAA1U6265GSLBoVS6/SNEVNFcAi+BpfiOMuwZiuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119239; c=relaxed/simple;
	bh=K5o/Nwoeb4PgtqtpDE+MFY9cCZqYi4JdHMcaywNoyM8=;
	h=Date:To:From:Subject:Message-Id; b=S7a085Fi61FeVrRXCXVDWnZceltb7OWk5+iznjLi82dyfcUBaWC0oSb/3s1uXDhHKjcquqROHv7o4Eb1/3Gt81OC/PXwryd1dMQUXEs27hrm7x/57d1GwrjYNFlrSLcCjmmWSrtY6ifUPPJr36Na6sXArq8uLuZY/T9llRzmsWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ecsxKxt7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ecsxKxt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC50FC4CEE4;
	Tue, 13 May 2025 06:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119238;
	bh=K5o/Nwoeb4PgtqtpDE+MFY9cCZqYi4JdHMcaywNoyM8=;
	h=Date:To:From:Subject:From;
	b=ecsxKxt7j5KRHBvIKEEDZwQq1FZa3nQ7HcyZa9hm9FucrcIT5hHk+QlVfUD8oEoq9
	 SF7rcMwSdRdLSJsiSb1eHwyANw/5SvM2o6AlyyGqiIIvqV+1BMaOXhJ+iQsAXXkY0W
	 JM/OEvffjdRL2NNhvxZwHy0FIDmaHtAHlNXJ1LXo=
Date: Mon, 12 May 2025 23:53:58 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,riel@surriel.com,nao.horiguchi@gmail.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,harry.yoo@oracle.com,david@redhat.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-rename-page__anon_vma-to-anon_vma-for-consistency.patch removed from -mm tree
Message-Id: <20250513065358.DC50FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: rename page__anon_vma to anon_vma for consistency
has been removed from the -mm tree.  Its filename was
     mm-rmap-rename-page__anon_vma-to-anon_vma-for-consistency.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/rmap: rename page__anon_vma to anon_vma for consistency
Date: Mon, 21 Apr 2025 16:57:28 +0800

Patch series "mm: minor cleanups in rmap", v3.

Minor cleanups in mm/rmap.c:

- Rename a local variable for consistency
- Fix a typo in a comment

No functional changes.


This patch (of 2):

Rename local variable page__anon_vma in page_address_in_vma() to anon_vma.
The previous naming convention of using double underscores (__) is
unnecessary and inconsistent with typical kernel style, which uses single
underscores to denote local variables.  Also updated comments to reflect
the new variable name.

Functionality unchanged.

Link: https://lkml.kernel.org/r/20250421085729.127845-1-ye.liu@linux.dev
Link: https://lkml.kernel.org/r/20250421085729.127845-2-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Liu Ye <liuye@kylinos.cn>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~mm-rmap-rename-page__anon_vma-to-anon_vma-for-consistency
+++ a/mm/rmap.c
@@ -789,13 +789,13 @@ unsigned long page_address_in_vma(const
 		const struct page *page, const struct vm_area_struct *vma)
 {
 	if (folio_test_anon(folio)) {
-		struct anon_vma *page__anon_vma = folio_anon_vma(folio);
+		struct anon_vma *anon_vma = folio_anon_vma(folio);
 		/*
 		 * Note: swapoff's unuse_vma() is more efficient with this
 		 * check, and needs it to match anon_vma when KSM is active.
 		 */
-		if (!vma->anon_vma || !page__anon_vma ||
-		    vma->anon_vma->root != page__anon_vma->root)
+		if (!vma->anon_vma || !anon_vma ||
+		    vma->anon_vma->root != anon_vma->root)
 			return -EFAULT;
 	} else if (!vma->vm_file) {
 		return -EFAULT;
@@ -803,7 +803,7 @@ unsigned long page_address_in_vma(const
 		return -EFAULT;
 	}
 
-	/* KSM folios don't reach here because of the !page__anon_vma check */
+	/* KSM folios don't reach here because of the !anon_vma check */
 	return vma_address(vma, page_pgoff(folio, page), 1);
 }
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are


