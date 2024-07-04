Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF3F143C61;
	Thu,  4 Jul 2024 23:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720136660; cv=none; b=WPey5eNr2eONtOZH3QKAW0vt8OtHHiKWh3JTTdE8SDTc+xg0hh2WPJHyIjemSknO51PRCn25DlrX+gObAbh8KMQ35jeQqnG69G6VzK03vD7GeRCmj8KWltmvHOFExfLdDulz4dTTjHsNDOpwSAem82ZkYlgC7FbqvhsUZOqbufI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720136660; c=relaxed/simple;
	bh=wRFAflfYMZD3jzik3d0kU7By/KsUblPQ4ZaAqPtaCN0=;
	h=Date:To:From:Subject:Message-Id; b=Q3BG4SEqFek/aXCBUR/Jx3JbBqZGtMRdiH9Eswcv98Upgbmvbl6crg9+6vzVtjiM43t4vXEeRQrw2OsBJpyzyJcaVWrGeS8tfpYWHrAfnQK2vWdRMpYpn9Q/5s7VuttzY3VTR+vesY3Bi4PdG4mNTkdw7/y8rpAorsu3PhouvZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cksmIeYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cksmIeYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC03FC3277B;
	Thu,  4 Jul 2024 23:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720136659;
	bh=wRFAflfYMZD3jzik3d0kU7By/KsUblPQ4ZaAqPtaCN0=;
	h=Date:To:From:Subject:From;
	b=cksmIeYDySzcRvD4EwI4ExXaAW74BbnKDfzGDALem0wYt+7uxfwlY6AH4zH5tj9za
	 VZMbhDh1MNzCji0/cfcjN8Ds8l+iRmL2ET0uIMA0ljcdIWBKpl1iPt42XpPYO9UWaR
	 4hU6Uz+MuSppQBe8vcZ/27shj2YCHa0EPX6/2e/o=
Date: Thu, 04 Jul 2024 16:44:19 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,stable@vger.kernel.org,muchun.song@linux.dev,david@redhat.com,aris@redhat.com,aris@ruivo.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hugetlb-force-allocating-surplus-hugepages-on-mempolicy-allowed-nodes-v2.patch removed from -mm tree
Message-Id: <20240704234419.AC03FC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: force allocating surplus hugepages on mempolicy allowed nodes
has been removed from the -mm tree.  Its filename was
     hugetlb-force-allocating-surplus-hugepages-on-mempolicy-allowed-nodes-v2.patch

This patch was dropped because it was folded into hugetlb-force-allocating-surplus-hugepages-on-mempolicy-allowed-nodes.patch

------------------------------------------------------
From: Aristeu Rozanski <aris@ruivo.org>
Subject: hugetlb: force allocating surplus hugepages on mempolicy allowed nodes
Date: Mon, 1 Jul 2024 17:23:43 -0400

v2: - attempt to make the description more clear
    - prevent uninitialized usage of folio in case current process isn't
      part of any nodes with memory

Link: https://lkml.kernel.org/r/20240701212343.GG844599@cathedrallabs.org
Signed-off-by: Aristeu Rozanski <aris@ruivo.org>
Cc: Vishal Moola <vishal.moola@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~hugetlb-force-allocating-surplus-hugepages-on-mempolicy-allowed-nodes-v2
+++ a/mm/hugetlb.c
@@ -2631,6 +2631,7 @@ static int gather_surplus_pages(struct h
 retry:
 	spin_unlock_irq(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
+		folio = NULL;
 		for_each_node_mask(node, cpuset_current_mems_allowed) {
 			if (!mbind_nodemask || node_isset(node, *mbind_nodemask)) {
 				folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
_

Patches currently in -mm which might be from aris@ruivo.org are

hugetlb-force-allocating-surplus-hugepages-on-mempolicy-allowed-nodes.patch

