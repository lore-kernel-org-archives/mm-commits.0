Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1966928DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489819; cv=none; b=OELVRBXccNhSg3WT/sQ3w/ZfzfGCTg/tgLk4i/1hP0Rorl/5y1RT0nVkoV7ytu/kfikxNHo2O4R3IU4IWDgJdEBYq9xyoMVi3QG9O1HWUc3v++5mRVYJk/D+9tTokM6Dx/RdVJ7UXPeNSWihNLlab6QcH33z3OtHwsU7e1BEjEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489819; c=relaxed/simple;
	bh=q/Z53spc3bIhbimy1+V+roWT7JI7iUv0DTe5YQBmNos=;
	h=Date:To:From:Subject:Message-Id; b=aWNYWpqCFXTVngwPS9OnPjQpPE0PyWajQCfcn536hOl9MOUelkuL5aaKB1ZQpEo4rT+GefkeoxP+2juGP2TNYqBOg1XwP74MJriMeoCD4Ckb5X72OwRwI+Y5x7OFTQ+FwPrTx5b48hJmrWHlHA+84QrXs7/IQBfbBvvJnnif9kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SVDrEOcM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SVDrEOcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5823C4CEE7;
	Sun, 21 Sep 2025 21:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489819;
	bh=q/Z53spc3bIhbimy1+V+roWT7JI7iUv0DTe5YQBmNos=;
	h=Date:To:From:Subject:From;
	b=SVDrEOcMvH4IU9LwUmtdNA03mW70DLv2kTFyF14E0apsFKgqAxOnfyI4+0om9KVRx
	 0igoSVO4tBKWDrA5HYHgL0sEWtdCuZ87wEP9L5jLuYu1+SZV+leCNY3OykWBjfYwOI
	 tTunAdJIHqOQO9k5PRFV5d5ZsjlaL7zDcQhxxcAY=
Date: Sun, 21 Sep 2025 14:23:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,richard.weiyang@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sanity-check-maximum-folio-size-in-folio_set_order.patch removed from -mm tree
Message-Id: <20250921212338.E5823C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: sanity-check maximum folio size in folio_set_order()
has been removed from the -mm tree.  Its filename was
     mm-sanity-check-maximum-folio-size-in-folio_set_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: sanity-check maximum folio size in folio_set_order()
Date: Mon, 1 Sep 2025 17:03:31 +0200

Let's sanity-check in folio_set_order() whether we would be trying to
create a folio with an order that would make it exceed MAX_FOLIO_ORDER.

This will enable the check whenever a folio/compound page is initialized
through prepare_compound_head() / prepare_compound_page() with
CONFIG_DEBUG_VM set.

Link: https://lkml.kernel.org/r/20250901150359.867252-11-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/internal.h~mm-sanity-check-maximum-folio-size-in-folio_set_order
+++ a/mm/internal.h
@@ -755,6 +755,7 @@ static inline void folio_set_order(struc
 {
 	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
 		return;
+	VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
 
 	folio->_flags_1 = (folio->_flags_1 & ~0xffUL) | order;
 #ifdef NR_PAGES_IN_LARGE_FOLIO
_

Patches currently in -mm which might be from david@redhat.com are


