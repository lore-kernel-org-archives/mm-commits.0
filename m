Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090703BD638
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896592; cv=none; b=E9dmWhpqKDl9m/BpuKyurduKSLXDrO3TrHQ0lbUwgNt20bD/apqVwdPAr3pUiQurkfs2P97fBOE9rKEZOvqzK2ZgnJ/Y1Yc8rPztfis+LwpBBPBi0ydu9Ry95JdIiOdaesUK0YaoiPhN5sx7DAQ0aZxce/4vosvpRFFLG1zn73o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896592; c=relaxed/simple;
	bh=s/JP58bmoTyEDX79G3vEX1qDo1L0YF1VJA+0LdCni60=;
	h=Date:To:From:Subject:Message-Id; b=jtezVtrcd9lgSVjqjw1tkhUBtPyKTjsG/gWIkm0pSuGLJyn6IJ4AYk6kw3s2E228oHi298HMXXmpUqUgjMC14zdcB5nP4gXiZ/mXHn+szn7BbKx9eAowCHnNNulk3gsOGx36h/PA55ydgW+Wkc+bThufhSStfZ5hWqIbEPJUF7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NKk8iXj5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NKk8iXj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA17B1F000E9;
	Wed,  5 Aug 2026 02:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896590;
	bh=ocsONunwlr9T/a1rEMfDZtPc35cxHATDz5cHJ6Z6b/8=;
	h=Date:To:From:Subject;
	b=NKk8iXj5XJeiuZmkeCQXNE1kyYE5TUqYLJZDW2Rs4fhmNj97Nix6U45n6k4X5ZkBT
	 zarlHJ0RxgN9h5ft1AAxq4FfEUWxx1oWhbVW8hwHNSydhoikDKfq2ElXixCq7UU0Ra
	 FjW6M2r2PC3zds1ZQqI6iyDNvfyYtRLrciDeqBYM=
Date: Tue, 04 Aug 2026 19:23:10 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tj@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,dennis@kernel.org,david@kernel.org,brendan.jackman@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch removed from -mm tree
Message-Id: <20260805022310.CA17B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: add page->private check back in __split_folio_to_order()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: add page->private check back in __split_folio_to_order()
Date: Thu, 09 Jul 2026 14:06:03 -0400

page->private should not be set in tail pages.  Commit 4265d67e405a
("mm/migrate_device: add THP splitting during migration") removed a
DEBUG_VM check without a proper reason[1].  Add it back.

Link: https://lore.kernel.org/all/13f3fcda-7328-4aa5-afc6-75a294a82b2a@nvidia.com/ [1]
Link: https://lore.kernel.org/20260709-keep-subpage-private-zero-at-free-v3-3-7e4fe155f5b9@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order
+++ a/mm/huge_memory.c
@@ -3591,6 +3591,13 @@ static void __split_folio_to_order(struc
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
+		/*
+		 * page->private should not be set in tail pages. Warn once
+		 * if private is unexpectedly set. Do it before swap.val assignment
+		 * since private overlaps with swap.val.
+		 */
+		VM_WARN_ON_ONCE_PAGE(new_folio->private, new_head);
+
 		if (folio_test_swapcache(folio))
 			new_folio->swap.val = folio->swap.val + i;
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-use-folios-memcg-inside-__folio_split.patch
xarray-honor-xa_flags_account-in-xas_split_alloc.patch

