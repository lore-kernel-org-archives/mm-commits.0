Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A4E2868B5
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 01:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785893085; cv=none; b=XVF6nC9/NVscv9wCPqaGmSg7cB309vWkw2BVlCFt+TYifbcSXH3c+WNBMMuNkwcss0Ngvs1VM3N4mW8TRUlazyjfWRmNOpQsv5Gd+BTQxh0b6d/N3x2ro1BNOiUejZiAGGVIS98YsQEAZypJevvzsXaQ1Kuog3JcnT68nsOnt7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785893085; c=relaxed/simple;
	bh=PdLwCXhnom5xL/SeGEMhfFvYLuSnPZ6EhhuppIUggo8=;
	h=Date:To:From:Subject:Message-Id; b=X1pYVLYsbxvqijYAxjqKmnwPi4Irrfo79brGuxkH+RFXG/l89kPrFpXHPKPhNRUz4b6HxKhK/QSCYyWGrkJXhSreNooQlC8Yz+kZxmjsGz/Vj2cEK9kJBioDPMqIYlVHgzVCdWtOrmxrp1tANutQ5mBuHhYFfTmcZIMhAo9gZb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jaNt0+Sj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jaNt0+Sj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760651F000E9;
	Wed,  5 Aug 2026 01:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785893083;
	bh=aElch5rWk83wHMnGm0VJXpswkPVQAqd4kj8vDBYK+68=;
	h=Date:To:From:Subject;
	b=jaNt0+SjiFH4eDAB7954iHwLW7rweOkcwcS4lvfm2PB8P6MfcRCOrNVFpFfZlK6F5
	 REhgBJE890NxR2fGXQdKrhzkRHJrZhVpUaclIzNgXCsLjOsmBpSMHnUD30jGJP7hz3
	 KNfLm1oauSflZEeLbLxojiaWO/ySkqGjK1tY0R9Y=
Date: Tue, 04 Aug 2026 18:24:43 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,brendan.jackman@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode-fix.patch removed from -mm tree
Message-Id: <20260805012443.760651F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode-fix.patch

This patch was dropped because it was folded into mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode.patch

------------------------------------------------------
From: "Brendan Jackman" <brendan.jackman@linux.dev>
Subject: mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode-fix
Date: Sat, 25 Jul 2026 12:34:29 +0000

fix try_to_compact_pages() kerneldoc

Link: https://lore.kernel.org/DK7NM9RPUJOD.11PNJJ5N2OBED@linux.dev
Signed-off-by: "Brendan Jackman" <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode-fix
+++ a/mm/compaction.c
@@ -2823,7 +2823,7 @@ static enum compact_result compact_zone_
 /**
  * try_to_compact_pages - Direct compact to satisfy a high-order allocation
  * @gfp_mask: The GFP mask of the current allocation
- * @order: The order of the current allocation
+ * @order: The order to try to make available
  * @alloc_flags: The allocation flags of the current allocation
  * @ac: The context of current allocation
  * @prio: Determines how hard direct compaction should try to succeed
_

Patches currently in -mm which might be from brendan.jackman@linux.dev are

maintainers-update-address-for-brendan-jackman.patch
mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode.patch

