Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889041DC993
	for <mm-commits@vger.kernel.org>; Wed, 15 Jan 2025 23:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736984575; cv=none; b=RmSlbtyOukG2lKCVYE9LNDZg1DeGerrkDPWMVqvLAj30TJ5cnRMjdNfODf0isinrINbiIpvShiSeXdm7BHVIQZi8DoAFuED7NEM/rCwyISuUQ193CCp6ePiRsjbnEN37S/x9C+zJOgLTM6/wjh2D6N7fI+5c0Ig76jlsfufe6gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736984575; c=relaxed/simple;
	bh=Qxf+7DLSCHl4D+0R1f0YcBy4sxIsezOCrXxmquAzGFs=;
	h=Date:To:From:Subject:Message-Id; b=VlEbLb0kto5HJTJBu2uujukoelQqw6fTGP63dhUjHbti9jqlcGTxfwY5Itp+NmSrvcerjB6Mccj+UoWDcqBs61JdjkqLromNsx8buP+D7d5F6eSu7YCX0rnypebAPFj55QLSIoFhi1VVNWwfvCu9W4LCOKQaJ6yjUmdoO8ZGvAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EHFBheDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EHFBheDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A58C4CED1;
	Wed, 15 Jan 2025 23:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736984575;
	bh=Qxf+7DLSCHl4D+0R1f0YcBy4sxIsezOCrXxmquAzGFs=;
	h=Date:To:From:Subject:From;
	b=EHFBheDhGzBUNmzfUFMTb9rHQLZ4KaNJJyVoMXDDdqiupRKvSjAFvELCMlHmmdhTl
	 Eodlyja5GR4TwVTXnu7rViCJ4LjAsusxoEPedGTS53cDw7aCsTjToOaE3xgO/kGCNW
	 K03OwkhdOqtxGTmHVadOG0Ngjc98Y1dUBLyMm/oI=
Date: Wed, 15 Jan 2025 15:42:54 -0800
To: mm-commits@vger.kernel.org,mhocko@suse.com,yuntao.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-the-incorrect-and-misleading-comment.patch added to mm-unstable branch
Message-Id: <20250115234254.F3A58C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: remove the incorrect and misleading comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-the-incorrect-and-misleading-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-the-incorrect-and-misleading-comment.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yuntao Wang <yuntao.wang@linux.dev>
Subject: mm/page_alloc: remove the incorrect and misleading comment
Date: Wed, 15 Jan 2025 12:16:34 +0800

The comment removed in this patch originally belonged to the
build_zonelists_in_zone_order() function, which was introduced by commit
f0c0b2b808f2 ("change zonelist order: zonelist order selection logic").

Later, commit c9bff3eebc09 ("mm, page_alloc: rip out ZONELIST_ORDER_ZONE")
removed build_zonelists_in_zone_order() but left its comment behind.

Subsequently, commit 9d3be21bf9c0 ("mm, page_alloc: simplify zonelist
initialization") moved the node_order variable into build_zonelists(),
making the comment originally belonged to build_zonelists_in_zone_order()
appear as if it were part of build_zonelists().

Remove this misleading comment.

Link: https://lkml.kernel.org/r/20250115041634.63387-1-yuntao.wang@linux.dev
Signed-off-by: Yuntao Wang <yuntao.wang@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-the-incorrect-and-misleading-comment
+++ a/mm/page_alloc.c
@@ -5159,13 +5159,6 @@ static void build_thisnode_zonelists(pg_
 	zonerefs->zone_idx = 0;
 }
 
-/*
- * Build zonelists ordered by zone and nodes within zones.
- * This results in conserving DMA zone[s] until all Normal memory is
- * exhausted, but results in overflowing to remote node while memory
- * may still exist in local DMA zone.
- */
-
 static void build_zonelists(pg_data_t *pgdat)
 {
 	static int node_order[MAX_NUMNODES];
_

Patches currently in -mm which might be from yuntao.wang@linux.dev are

mm-page_alloc-remove-the-incorrect-and-misleading-comment.patch

