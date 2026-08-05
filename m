Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452863A9D94;
	Wed,  5 Aug 2026 03:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785898989; cv=none; b=B0C2Gw+M0eDmbp/xY8FXlm7mKutq1UxoaywA1+dmbhv3fvzXdFDbH3J6reFcTxYYkOxmqYGXOYwojlUT1+LKsO0VAVdVQMk/qV1HR4x7hU1QX+b+Uubwn0LDap/pthZuvgCKOZb/3UlubzBwAMfQXxvvRSPl4t5xLpMM8dPdrVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785898989; c=relaxed/simple;
	bh=hcDRKeOeumH9z+An/UDRDagHNFAACotWUzENIQHM8Bc=;
	h=Date:To:From:Subject:Message-Id; b=OmN82GrRiV7s2E5wxmfVF55oRR+D2ZFM8gE9cFjrGRt2aP4U63UngDnX6z5gHphFidEu7dBURf7PUIDJ/+SwNqqUcRGhMLNV5RpZqh2EtFfI4VsnDArsrGglZYIPCLvq6RGg1tM3Nm9TrInW2jLQEoUzeMyyq5aBdDr+TG9oBX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hm50WDCL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hm50WDCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE771F000E9;
	Wed,  5 Aug 2026 03:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785898987;
	bh=0JcaZqMF6Rpg23ceJxhGjonNU9YmHWNMG4B6oNK0tCE=;
	h=Date:To:From:Subject;
	b=hm50WDCLRetOj1o5bsqfjnM5hvwC1yzdORT0MZqS66+GuaAPLbHHLScIN43l15SBJ
	 fmakorAVB+E/9C4g90WJtkf3/8G5inF7SzCuIFYYwOjrChYFSrwlFievwlAKKN5qr6
	 c2+Sw9eFa7PnWVzT1L14MUmyXKEonh8RNvLwPGw0=
Date: Tue, 04 Aug 2026 20:03:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,stable@vger.kernel.org,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,mfleming@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-initialise-workingset-state-before-folio-split.patch removed from -mm tree
Message-Id: <20260805030307.CCE771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: initialise workingset state before folio split
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-initialise-workingset-state-before-folio-split.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Matt Fleming <mfleming@cloudflare.com>
Subject: mm/huge_memory: initialise workingset state before folio split
Date: Sat, 25 Jul 2026 11:14:19 +0100

xas_try_split() adds __GFP_ACCOUNT for page-cache xa_nodes, but
__folio_split() leaves the xa_state's xa_lru unset.  That lets a live,
memcg-charged xa_node exist without being linked into the mapping's
shadow_nodes list_lru; when reclaim later walks the list_lru it trips
VM_WARN_ON(!css_is_dying()).

Use mapping_set_update() to install both the workingset update callback
and the shadow_nodes list_lru on the xa_state.

Link: https://lore.kernel.org/20260725101419.3938406-1-matt@readmodwrite.com
Fixes: 58729c04cf10 ("mm/huge_memory: add buddy allocator like (non-uniform) folio_split()")
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Reported-by: syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c5b060ce82921a2fd500
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-initialise-workingset-state-before-folio-split
+++ a/mm/huge_memory.c
@@ -4076,7 +4076,7 @@ static int __folio_split(struct folio *f
 		gfp_t gfp;
 
 		mapping = folio->mapping;
-		min_order = mapping_min_folio_order(folio->mapping);
+		min_order = mapping_min_folio_order(mapping);
 		if (new_order < min_order) {
 			ret = -EINVAL;
 			goto out;
@@ -4090,6 +4090,8 @@ static int __folio_split(struct folio *f
 			goto out;
 		}
 
+		mapping_set_update(&xas, mapping);
+
 		if (split_type == SPLIT_TYPE_UNIFORM) {
 			xas_set_order(&xas, folio->index, new_order);
 			xas_split_alloc(&xas, folio, old_order, gfp);
_

Patches currently in -mm which might be from mfleming@cloudflare.com are


