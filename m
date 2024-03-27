Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB641879
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 19:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567659; cv=none; b=on8jOMJ6bQeFToJJAPsVun0LPqucsScl70JVQezwB4/HbvyfBssJ6OMdN4XeNezgPyERy+/jfdbAfiPFoO8wpvroddgt3ikNV/0X+KWpRKTaiI55zD6Ng2OsjLQQJy3xaLamApitendJQiu3z5oisGVIAphjhcP42Wu2eguZIQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567659; c=relaxed/simple;
	bh=k63jgIu+k3QYqbriiepL04AF6aYks5P36dc797Xfdzo=;
	h=Date:To:From:Subject:Message-Id; b=KSctMhG+9emW40QOEu/RFAL2afqnQjU9Im0NGHk7B1oL79pmd4RmbqYfSNV9vZGLH0IgJT8GWElo+rDLW3y5tlVfzbppMUSMLC6HQsfrWHgzNMjpKir+JulnLLDcEX+dzynS47EROYMiK5aRjxC3xCUbAFqwdwKkjzEwakTMth8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EutanoD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EutanoD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC20C433C7;
	Wed, 27 Mar 2024 19:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711567659;
	bh=k63jgIu+k3QYqbriiepL04AF6aYks5P36dc797Xfdzo=;
	h=Date:To:From:Subject:From;
	b=EutanoD+Wf39/tWWFhTbaqgGJQ8SbbNFco6JeQGI8V7D8NTPgQJa1BVDI2Dj+hwtN
	 jXTNlsC18Zw3xxGsQiikTtR+eJtfstBq1vl2BzjsIzDfZSGPsrqR1ejoTgYp6SgvkD
	 4sgKOKkvx48/iBOGiAwFR2ja4/c6e//HpkDWx26I=
Date: Wed, 27 Mar 2024 12:27:38 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-fix.patch removed from -mm tree
Message-Id: <20240327192739.1AC20C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-fix
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-fix.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-fix
Date: Wed Mar 27 10:36:28 AM PDT 2024

remove unused local

Cc: Baoquan He <bhe@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-fix
+++ a/mm/page_alloc.c
@@ -5285,7 +5285,7 @@ static void setup_min_slab_ratio(void);
 
 static void build_zonelists(pg_data_t *pgdat)
 {
-	int node, local_node;
+	int local_node;
 	struct zoneref *zonerefs;
 	int nr_zones;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix.patch

