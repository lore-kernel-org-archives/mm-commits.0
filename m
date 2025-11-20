Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAC23242B5
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675081; cv=none; b=okZwgEFMksT76p6tp6kiLMWgTX/GTvPOF2qntW/7ABZbUV8B6nCvSy/fDuLGsMgijcrQBBXiKgiQXCaudZJ+p1ZZjFfOL3EBJ/osJ48SB7yHwRh1byfxuAuoGXnTLOU2Fw4sXKHc4ibPatgPmJQKfhx0zkKE1edyLg8duSbjKGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675081; c=relaxed/simple;
	bh=aHu71/yC+CJK/rxfyp4lRDsDRbk5EWEYxPBF+LBAOTo=;
	h=Date:To:From:Subject:Message-Id; b=erxjhqP+EOlXIQcZMSMbMjhIve8XpXqe0PTWGvcgOa/90TGuAkgpjCQ5/Rq5daOd23mB3Ht063fbt2l2vRTcLtqbns5fYzWkAdD6Op89Hecn+aQSbvo+Yc/4Mh9WX/G6YzUnGWhLVWSTxXpiNHRJ970Octe7fQdzDitoHA3Qx6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1R1GXU81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1R1GXU81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5997AC4CEF1;
	Thu, 20 Nov 2025 21:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675081;
	bh=aHu71/yC+CJK/rxfyp4lRDsDRbk5EWEYxPBF+LBAOTo=;
	h=Date:To:From:Subject:From;
	b=1R1GXU81+hF0oQ0kg//14s2FP0jg1YxG87XkLzHccQnuNG9k9PcqCn26po55W677c
	 o7MkkBBadtzVsD/CfMjX5T96IYZwvAr1vTQ5zSAj3NAwT0N2KPkDaUVQJDcsAD7CS3
	 W5dW5juIr8K3XhwlY7LXc9MnBIE9Wbai9xGqcohw=
Date: Thu, 20 Nov 2025 13:44:40 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,david@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory_hotplug-optimise-try_offline_memory_block.patch removed from -mm tree
Message-Id: <20251120214441.5997AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memory_hotplug: optimise try_offline_memory_block()
has been removed from the -mm tree.  Its filename was
     memory_hotplug-optimise-try_offline_memory_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: memory_hotplug: optimise try_offline_memory_block()
Date: Thu, 6 Nov 2025 20:14:50 +0000

Extract the zone number directly from the page instead of using the page's
zone number to look up the zone and asking the zone what its number is.

Link: https://lkml.kernel.org/r/20251106201452.2292631-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~memory_hotplug-optimise-try_offline_memory_block
+++ a/mm/memory_hotplug.c
@@ -2327,7 +2327,7 @@ static int try_offline_memory_block(stru
 	 * by offlining code ... so we don't care about that.
 	 */
 	page = pfn_to_online_page(section_nr_to_pfn(mem->start_section_nr));
-	if (page && zone_idx(page_zone(page)) == ZONE_MOVABLE)
+	if (page && page_zonenum(page) == ZONE_MOVABLE)
 		online_type = MMOP_ONLINE_MOVABLE;
 
 	rc = device_offline(&mem->dev);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-tweak-__vma_enter_locked.patch

