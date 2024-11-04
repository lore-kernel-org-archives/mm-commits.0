Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA1A2C9A
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730695769; cv=none; b=ijJBrvz+HI8fS57YdbMVQPiyuVw/lX3IOvRqiVGFXfYJgoujHoe3E5LDl3dI1NmOhf4S1fw+ssyk5N5M4MZI4d6bflDG/h8wlLvBoRPQJc1SsYibUI6cVRK6SlM1x0H0f9zuv+3Dk1jZgtEDDlD+flWYG6czwI22mm+BgcYyByg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730695769; c=relaxed/simple;
	bh=N9hBT9fTKGKRsf3fVs1HHloDMg/Tcxcf7s9onhR+5A0=;
	h=Date:To:From:Subject:Message-Id; b=IQXoZsvqj+qIICm2D9+rEjo+Sr+Ws/NVxwdEZNEPOMHr0iq6kYdkvvvy4YjBGsDRLtwO4Me8EO1H5BRZWS5R2Jh/wVk8k8Nn4aIuTLFAWbIoegdAxKIeIgIgW074nDBdGr59enjIjYIUMb4usEYaGdnebHePQEoM5dpS5eRIUR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V8aLcgzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V8aLcgzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51076C4CECE;
	Mon,  4 Nov 2024 04:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730695768;
	bh=N9hBT9fTKGKRsf3fVs1HHloDMg/Tcxcf7s9onhR+5A0=;
	h=Date:To:From:Subject:From;
	b=V8aLcgzIMIENFl87fBl0Uth4gBr7plnvvTtTFXkzh2264RiPikhOnyc1cPTysQua0
	 OUOrbWqNQMgCeBfj19YHINfneFYXmYO83JWbSfAVPTjcAlZKnh9lU6FsTzub+l6kAa
	 xLh9OtxGHrOAkPvKlYMVCqxpcaZZGdzf6xRpyuvI=
Date: Sun, 03 Nov 2024 20:49:27 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,alexs@kernel.org,cuigaosheng1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] ksm-convert-cmp_and_merge_page-to-use-a-folio-fix.patch removed from -mm tree
Message-Id: <20241104044928.51076C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: add missing IS_ERR_OR_NULL check for stable_tree_search()
has been removed from the -mm tree.  Its filename was
     ksm-convert-cmp_and_merge_page-to-use-a-folio-fix.patch

This patch was dropped because it was folded into ksm-convert-cmp_and_merge_page-to-use-a-folio.patch

------------------------------------------------------
From: Gaosheng Cui <cuigaosheng1@huawei.com>
Subject: mm/ksm: add missing IS_ERR_OR_NULL check for stable_tree_search()
Date: Thu, 24 Oct 2024 11:23:00 +0800

The stable_tree_search() maybe return -EBUSY if the stable node's page is
being migrated or nullptr, we need to check kfolio with IS_ERR_OR_NULL()
before dereference it.

To mitigate this, add IS_ERR_OR_NULL check for stable_tree_search().

Link: https://lkml.kernel.org/r/20241024032300.2501949-1-cuigaosheng1@huawei.com
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/ksm.c~ksm-convert-cmp_and_merge_page-to-use-a-folio-fix
+++ a/mm/ksm.c
@@ -1787,7 +1787,7 @@ static __always_inline struct folio *cha
  * with identical content to the page that we are scanning right now.
  *
  * This function returns the stable tree node of identical content if found,
- * NULL otherwise.
+ * -EBUSY if the stable node's page is being migrated, NULL otherwise.
  */
 static struct folio *stable_tree_search(struct page *page)
 {
@@ -2261,7 +2261,8 @@ static void cmp_and_merge_page(struct pa
 
 	/* Start by searching for the folio in the stable tree */
 	kfolio = stable_tree_search(page);
-	if (&kfolio->page == page && rmap_item->head == stable_node) {
+	if (!IS_ERR_OR_NULL(kfolio) && &kfolio->page == page &&
+	    rmap_item->head == stable_node) {
 		folio_put(kfolio);
 		return;
 	}
_

Patches currently in -mm which might be from cuigaosheng1@huawei.com are

ksm-convert-cmp_and_merge_page-to-use-a-folio.patch

