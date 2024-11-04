Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06402185B72
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730696329; cv=none; b=SU2mXWKpacjhnGQDCt1sKjPorTStNFQ+xKguYTpwpIq/810LB7ZeVCcpivx1yOwUr4/e5WjrOC2IG9vxyEq8a1u1k9eUM5DXkdN0Oj7MzyJe3UhmlOYlgdkX9cRdaui81olkxfDH2zgbU6iF1wQGgeY+4U4p2QwukSU1R+TOBOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730696329; c=relaxed/simple;
	bh=MEE9z1+O1sH3bDcyQyQ5qHkz/RT+EyKkDsFPXBKItq4=;
	h=Date:To:From:Subject:Message-Id; b=MXfiNOCDCri6b6+VMHifVp0LM/83zoQOuw8XMk0DGZu6O9VQEhy4I+m1cm/gn0UtDJHp6NpuDWty8M3jXK3W/2WQYBKqRQYyIf2aatHifRxmEQ8laqvmR2OZH4eGXwRZlczQRa5OKACfsw0cqDeIqSRZbiviE2LCHYip+jm9y4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KXiljNyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KXiljNyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5ABAC4CECE;
	Mon,  4 Nov 2024 04:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730696328;
	bh=MEE9z1+O1sH3bDcyQyQ5qHkz/RT+EyKkDsFPXBKItq4=;
	h=Date:To:From:Subject:From;
	b=KXiljNyFNrNgffaDRpQD6hPKAjMkk0kWGv25+j8LAW2bQH+Dn7c0fo4vRAV2c/RnJ
	 zfQiirwGLMJS/LUakcaYa/hKNpd15Spgx4R+F77VIjMllklsjunoktLbofsAQp/tDa
	 4J4JGNPMHo+5b+QM9vv7WIqEoVjh1Im3MvwgphFk=
Date: Sun, 03 Nov 2024 20:58:48 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-v1-no-need-for-memcg-locking-for-mglru-fix-2.patch removed from -mm tree
Message-Id: <20241104045848.C5ABAC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-v1-no-need-for-memcg-locking-for-mglru-fix-2
has been removed from the -mm tree.  Its filename was
     memcg-v1-no-need-for-memcg-locking-for-mglru-fix-2.patch

This patch was dropped because it was folded into memcg-v1-no-need-for-memcg-locking-for-mglru.patch

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg-v1-no-need-for-memcg-locking-for-mglru-fix-2
Date: Fri, 25 Oct 2024 23:34:34 -0700

folio_rcu() fixup, per Yu Zhao

Link: https://lkml.kernel.org/r/iwmabnye3nl4merealrawt3bdvfii2pwavwrddrqpraoveet7h@ezrsdhjwwej7
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~memcg-v1-no-need-for-memcg-locking-for-mglru-fix-2
+++ a/mm/vmscan.c
@@ -3353,7 +3353,7 @@ static struct folio *get_pfn_folio(unsig
 	if (folio_nid(folio) != pgdat->node_id)
 		return NULL;
 
-	if (folio_memcg_rcu(folio) != memcg)
+	if (folio_memcg(folio) != memcg)
 		return NULL;
 
 	/* file VMAs can contain anon pages from COW */
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-optimize-truncation-of-shadow-entries.patch
mm-optimize-invalidation-of-shadow-entries.patch
mm-truncate-reset-xa_has_values-flag-on-each-iteration.patch
memcg-add-tracing-for-memcg-stat-updates.patch
memcg-v1-fully-deprecate-move_charge_at_immigrate.patch
memcg-v1-remove-charge-move-code.patch
memcg-v1-no-need-for-memcg-locking-for-dirty-tracking.patch
memcg-v1-no-need-for-memcg-locking-for-writeback-tracking.patch
memcg-v1-no-need-for-memcg-locking-for-mglru.patch
memcg-v1-remove-memcg-move-locking-code.patch
memcg-workingset-remove-folio_memcg_rcu-usage.patch

