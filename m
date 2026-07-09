Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4272B13DDAE
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 18:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783621442; cv=none; b=qRnPHyjH8Nekpn8FA4Jpv9Df36uBaTyg/msLEIgYNAlkDFkfwqTcw8HIHGYVOrmizWf2qbXChekpJqX3X44XvvS5sah/Lz0HvbeOMdPyjIBRY7H6YND3a59gJBXFa1bilJrhbcQzN4O4cEPcP352TvqWIuoX1TB+DJNANRnhF20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783621442; c=relaxed/simple;
	bh=Ho1Sg9JEuw7MAXyW03G2gP9dNchOSvQnwQWbYOQOCFQ=;
	h=Date:To:From:Subject:Message-Id; b=Reclb37fiUa1G6vRi2tN1DtyOFTsrCSJUUM1AF7ILMEaNdqY+Y0jxI4WZyUzh7L0H1wRY+gKWGOC9mZyelX86yieeBzn47OuEL0nJKyJhGOeCGNYthTaPWFOXva5SHT9+pFY6r/LH9K5OWGHL5iLbmDrPpdIUPFfDR7JmHkYdOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EQNo93Uy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EQNo93Uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706601F000E9;
	Thu,  9 Jul 2026 18:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783621440;
	bh=6UE2iOt1nbp1Tn7qR5I+HvWWQo8R8/bdujs+3TUTPtk=;
	h=Date:To:From:Subject;
	b=EQNo93Uybto7cg4vyoJ22WoDpwYi1MeALBtDXJxXfhI+yL9sB3qZBlxe+eKbZUhXB
	 wM5G6eFP/oz8wcVpxIxjZiGoUI5pJxXehSMRDogT7O0VVbEyOMekO4pQgPpqMz1PVk
	 wDYULOwJ8EMNUlwnjsr3B+8WWjeHp64zPQwVv5qM=
Date: Thu, 09 Jul 2026 11:24:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch removed from -mm tree
Message-Id: <20260709182400.706601F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: add page->private check back in __split_folio_to_order()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: add page->private check back in __split_folio_to_order()
Date: Fri, 03 Jul 2026 09:47:48 -0400

page->private should not be set in tail pages.  Commit 4265d67e405a
("mm/migrate_device: add THP splitting during migration") removed it
without a proper reason[1].  Add it back.

Link: https://lore.kernel.org/all/13f3fcda-7328-4aa5-afc6-75a294a82b2a@nvidia.com/ [1]
Link: https://lore.kernel.org/20260703-keep-subpage-private-zero-at-free-v2-3-2970fe777dd6@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
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
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
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

mm-page_owner-add-numa-node-filter-fix.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

