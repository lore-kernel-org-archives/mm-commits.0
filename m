Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0557413BC0C;
	Mon, 17 Mar 2025 00:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742172084; cv=none; b=gYoi+P6yy3cDFJHpjzShw9OuacpiXFxJ3oXIyT8ded9ckYzr3T9Ys4PXYRTtsyXluqnpSLXy3B5xKiLbjocyBstc8QPmwODGqk+uK/9lTmzL0C8b5wmjWnXJjSmJi6yFiXqD4Gu/5VrX3iasqs9MBatISVRlX+PyucyIMNFS0Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742172084; c=relaxed/simple;
	bh=TdKP6bj+SPLGRtvGNvqhWkCOa/EEEjj2Uvk6RL37bO8=;
	h=Date:To:From:Subject:Message-Id; b=NBu/JyLSv8YN/kcXEvAk1MtOgoKbMYu1XyHeexd8F5Igqj9GAANEyIequeIiwKPbtXLAD7TCy+dZRC7lYypZYFhRi6Br9rzElnM3AEVyPbpyHT8xr9ShcTLP8ehlAjvHdn352RSZSujOSJivrMrkONxrH41FMJjFSCEFmxXF+Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F9UqR/dp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F9UqR/dp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0AEC4CEDD;
	Mon, 17 Mar 2025 00:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742172083;
	bh=TdKP6bj+SPLGRtvGNvqhWkCOa/EEEjj2Uvk6RL37bO8=;
	h=Date:To:From:Subject:From;
	b=F9UqR/dp5SR/pyOon/fCMz0aQYzgaToQ0jQWxmRZrzQF9c6V26D3IWZ7hGftFTllh
	 j4uy+BMfilGDrF+i2x4LGdYtf3WUpQDreBuTJHS7irb/4e1t7AS2244stPFRc5oUj4
	 3e3BQ1fosH1kRpMSe/coA5VVpN7iT1I9bBZeVDdQ=
Date: Sun, 16 Mar 2025 17:41:22 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,thomas.lendacky@amd.com,stable@vger.kernel.org,rppt@kernel.org,rick.p.edgecombe@intel.com,pankaj.gupta@amd.com,mgorman@techsingularity.net,farrah.chen@intel.com,david@redhat.com,ashish.kalra@amd.com,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-fix-memory-accept-before-watermarks-gets-initialized.patch removed from -mm tree
Message-Id: <20250317004123.6F0AEC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: fix memory accept before watermarks gets initialized
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-memory-accept-before-watermarks-gets-initialized.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/page_alloc: fix memory accept before watermarks gets initialized
Date: Mon, 10 Mar 2025 10:28:55 +0200

Watermarks are initialized during the postcore initcall.  Until then, all
watermarks are set to zero.  This causes cond_accept_memory() to
incorrectly skip memory acceptance because a watermark of 0 is always met.

This can lead to a premature OOM on boot.

To ensure progress, accept one MAX_ORDER page if the watermark is zero.

Link: https://lkml.kernel.org/r/20250310082855.2587122-1-kirill.shutemov@linux.intel.com
Fixes: dcdfdd40fa82 ("mm: Add support for unaccepted memory")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Reported-by: Farrah Chen <farrah.chen@intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: <stable@vger.kernel.org>	[6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-memory-accept-before-watermarks-gets-initialized
+++ a/mm/page_alloc.c
@@ -7004,7 +7004,7 @@ static inline bool has_unaccepted_memory
 
 static bool cond_accept_memory(struct zone *zone, unsigned int order)
 {
-	long to_accept;
+	long to_accept, wmark;
 	bool ret = false;
 
 	if (!has_unaccepted_memory())
@@ -7013,8 +7013,18 @@ static bool cond_accept_memory(struct zo
 	if (list_empty(&zone->unaccepted_pages))
 		return false;
 
+	wmark = promo_wmark_pages(zone);
+
+	/*
+	 * Watermarks have not been initialized yet.
+	 *
+	 * Accepting one MAX_ORDER page to ensure progress.
+	 */
+	if (!wmark)
+		return try_to_accept_memory_one(zone);
+
 	/* How much to accept to get to promo watermark? */
-	to_accept = promo_wmark_pages(zone) -
+	to_accept = wmark -
 		    (zone_page_state(zone, NR_FREE_PAGES) -
 		    __zone_watermark_unusable_free(zone, order, 0) -
 		    zone_page_state(zone, NR_UNACCEPTED));
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


