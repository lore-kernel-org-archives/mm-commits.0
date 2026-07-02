Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A392773EC;
	Thu,  2 Jul 2026 02:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782957814; cv=none; b=eBc2osPKNeY907h5VxXM725roFEtQFYEzJlyQgE2ptcEIzzCIeiMnEHqr6rXc2AClXRTVj4rPwwiYKmA6OTaoyeraFboluIQju5xdTUncMB58txhMxdjEvptilZPUzHDsArEBdKizsxpNl61SerhxpUX4vR9mYr6e5ASJ0yonC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782957814; c=relaxed/simple;
	bh=a4FFtMuqcHJzA/byNA4piCIA9jCktCboENNBY+KUK6s=;
	h=Date:To:From:Subject:Message-Id; b=dlzh/Vtpazu7Xa5k43BfSi616CdVlDNFZdRO/MlpzTPNG33Iu7EwCP6sGOxGMtgjn4nqP2SXujhF/Op1x7jm8OaHwe9Y5ZAiR76p/L+fHDiHBPmTAR6mYb8xSbyKHG3ZxOp/ENRhRLJkCv2mt+ZzwXcqqtrSfphRDO98O89AtS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1ILQIrKd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1ILQIrKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9037A1F000E9;
	Thu,  2 Jul 2026 02:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782957813;
	bh=J2rZh4URUapBUYPKQZLBcJuf7xAf1NxVY0KNeMq8qGI=;
	h=Date:To:From:Subject;
	b=1ILQIrKdqar6EIDdYJSrQ545fVOSIkDQnKE8Uw6WNt2Le+IqVPHbz9XVltDjK46Q+
	 HzXr+OKR51ZMqANE/6026/6bDv7yWFiIH5BAWoohKGBStoPMQ40J8MPdmrqG3Sc+xh
	 0tUXvyy1eHkbKZnVARlDijIGcJcKgLTfHD/u+uTM=
Date: Wed, 01 Jul 2026 19:03:33 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,lance.yang@linux.dev,jiaqiyan@google.com,jackmanb@google.com,hannes@cmpxchg.org,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-compaction-handle-free_pages_prepare-properly-in-compaction_free.patch removed from -mm tree
Message-Id: <20260702020333.9037A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/compaction: handle free_pages_prepare() properly in compaction_free()
has been removed from the -mm tree.  Its filename was
     mm-compaction-handle-free_pages_prepare-properly-in-compaction_free.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/compaction: handle free_pages_prepare() properly in compaction_free()
Date: Mon, 22 Jun 2026 11:30:42 -0400

free_pages_prepare() can fail but compaction_free() does not handle the
failure case.  Failed pages should not be added back to cc->freepages for
future use, since they can be either PageHWPoison or free_page_is_bad()
and might cause data corruption.

Link: https://lore.kernel.org/20260622-handle_free_pages_prepare_in_compaction_free-v1-1-fcf3b14abcf7@nvidia.com
Fixes: 733aea0b3a7b ("mm/compaction: add support for >0 order folio memory compaction.")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/compaction.c~mm-compaction-handle-free_pages_prepare-properly-in-compaction_free
+++ a/mm/compaction.c
@@ -1875,15 +1875,14 @@ static void compaction_free(struct folio
 	int order = folio_order(dst);
 	struct page *page = &dst->page;
 
-	if (folio_put_testzero(dst)) {
-		free_pages_prepare(page, order);
+	if (folio_put_testzero(dst) && free_pages_prepare(page, order)) {
 		list_add(&dst->lru, &cc->freepages[order]);
 		cc->nr_freepages += 1 << order;
 	}
 	cc->nr_migratepages += 1 << order;
 	/*
-	 * someone else has referenced the page, we cannot take it back to our
-	 * free list.
+	 * someone else has referenced the page or free_pages_prepare() fails,
+	 * we cannot take it back to our free list.
 	 */
 }
 
_

Patches currently in -mm which might be from ziy@nvidia.com are


