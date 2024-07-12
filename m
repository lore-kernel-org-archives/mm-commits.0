Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455063FB9F
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824325; cv=none; b=pJyUOoUrXTYCZwX+TheJdikxWpHbBJi18qFy14B6dnwNX0F2xZYEOilWGaOKrrHWg/pJ9Zez5Vt5s8GMpIlnop2Yn8CMQHAfOQszmX3ASq9cPOtU8hX0kL40rmvHF31msQv7O3FMhxZF7e95NpC+k4eShHlFVFZMvngPp8ioJzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824325; c=relaxed/simple;
	bh=vGknsx0VoFLMCgjQzECMqPqu65cZ17TrM8DWp2EZ1Gc=;
	h=Date:To:From:Subject:Message-Id; b=iBkrCXVzUouPslUTF800Hq8rbDollx3WK2XCoVdcDxojfws7CDqVxLZyWXMy11+hg9s4bj5AJi2veKPKeabv/aMLzNwamL5g7M3m81P9LyHndVzjbycZ2Mb869acpGoxdLAdcdvfgu+i5BpRmVvA9mqIfIHoMY5yq3PttA8RRko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pkF82TKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pkF82TKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EB8C4AF07;
	Fri, 12 Jul 2024 22:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824325;
	bh=vGknsx0VoFLMCgjQzECMqPqu65cZ17TrM8DWp2EZ1Gc=;
	h=Date:To:From:Subject:From;
	b=pkF82TKXLCw5AAgq0X0DXUtlTbbOdEFRRuxp+6xQEFI1QshU7/Ree3dXaXQjmAKua
	 ghlsHg5gAfuVrXKlZ3SNCMZ3diRdHi3tzSpjZ8RnY0wBIJj4rj1DGZ0a48nzDGvJeQ
	 +Vi8ic9IP/h7L79MY6q9byzBt4n+7LiDe+/ATBug=
Date: Fri, 12 Jul 2024 15:45:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shy828301@gmail.com,ryan.roberts@arm.com,mingzhe.yang@ly.com,libang.li@antgroup.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-per-order-mthp-split-counters-fix.patch removed from -mm tree
Message-Id: <20240712224524.E3EB8C4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-per-order-mthp-split-counters-fix
has been removed from the -mm tree.  Its filename was
     mm-add-per-order-mthp-split-counters-fix.patch

This patch was dropped because it was folded into mm-add-per-order-mthp-split-counters.patch

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mm-add-per-order-mthp-split-counters-fix
Date: Fri, 5 Jul 2024 19:31:19 +0800

use == for `order' test, per David

Link: https://lkml.kernel.org/r/20240705113119.82210-1-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mingzhe Yang <mingzhe.yang@ly.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-add-per-order-mthp-split-counters-fix
+++ a/mm/huge_memory.c
@@ -3260,7 +3260,7 @@ out_unlock:
 		i_mmap_unlock_read(mapping);
 out:
 	xas_destroy(&xas);
-	if (order >= HPAGE_PMD_ORDER)
+	if (order == HPAGE_PMD_ORDER)
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	count_mthp_stat(order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
 	return ret;
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-add-per-order-mthp-split-counters.patch
mm-add-docs-for-per-order-mthp-split-counters.patch
mm-add-docs-for-per-order-mthp-split-counters-v3.patch
mm-add-docs-for-per-order-mthp-split-counters-v3-fix.patch

