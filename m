Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E24175A8D
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791331263; cv=none; b=uuuljEcgwEijIFWfNr9oUP7UfD1NBcU580wOCbz0cdYnzi2FspGA7GNkN0YtJUYMnGOBtzs5DfIMiFEFCHO61VbCVvSFX5sF8kXpVNK1XDN7IYFCvOoV6wBgIUJoZiT+MTzMICm7u9Btc+la5HF3rwM8kUB2mPS0tyRyxhhqSwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791331263; c=relaxed/simple;
	bh=uGi9qn4QBseD5TdFib9YDBjtk9zCHKUqSErZQGC37oI=;
	h=Date:To:From:Subject:Message-Id; b=H5dbchvBs9WkLNnG628n5jINCXrEg4wil5yQNRxBC36lig08uaX1MH42LV0/OZ3wJYlVlCfj02uwz6r1JvyeXoZVk1Gn6xVjk3X/T00onfxrUddBcbK2slqaWpkCOiGGwCuoUG9lSU0DoAqXveilsP7DAFateaBKm1iSianZAx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ij+foczh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ij+foczh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AF01F0089C;
	Wed,  7 Oct 2026 00:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791331262;
	bh=KNuTK+pguaVLOVLdbi5MCfay9H4ES4iSptJBrcKBZ/A=;
	h=Date:To:From:Subject;
	b=ij+foczhMFS3RbIppkIA1KodM38Q1IpQDoeEjVzIjg2sPjjH9LnB/ZXVsXyMzEyKX
	 Sr2Pn8DgtWmUsYELYLJRYxe/KS99hVYW23WLyg16ljm+sW80dOmApjostehoIkzbC/
	 SxVL4ZI/sCNGPXK04XpaZUjAAuZuZBB1taw2i6FA=
Date: Tue, 06 Oct 2026 17:01:01 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-a-template-based-fast-path-for-zone-device-page-init-fix.patch removed from -mm tree
Message-Id: <20261007000101.E5AF01F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-a-template-based-fast-path-for-zone-device-page-init-fix
has been removed from the -mm tree.  Its filename was
     mm-add-a-template-based-fast-path-for-zone-device-page-init-fix.patch

This patch was dropped because it was folded into mm-add-a-template-based-fast-path-for-zone-device-page-init.patch

------------------------------------------------------
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: mm-add-a-template-based-fast-path-for-zone-device-page-init-fix
Date: Thu, 3 Sep 2026 10:58:06 +0800

whitespace fix, per Mike

Link: https://lore.kernel.org/20260903025806.70825-1-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
---

 mm/mm_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mm_init.c~mm-add-a-template-based-fast-path-for-zone-device-page-init-fix
+++ a/mm/mm_init.c
@@ -1139,8 +1139,7 @@ void __ref memmap_init_zone_device(struc
 	for (; pfn < end_pfn; pfn += pfns_per_compound) {
 		page = pfn_to_page(pfn);
 
-		zone_device_page_init_from_template(page, pfn,
-						    &template);
+		zone_device_page_init_from_template(page, pfn, &template);
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

mm-fix-stale-zone_device-refcount-comment.patch
mm-add-a-set_page_section_from_pfn-helper.patch
mm-add-a-template-based-fast-path-for-zone-device-page-init.patch
mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch
string-introduce-memcpy_nontemporal.patch
mm-use-memcpy_nontemporal-in-zone-device-template-copies.patch
x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch
mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds.patch

