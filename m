Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45139217F5D
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188476; cv=none; b=Rh0lZP2k9j8/tnTw/0fi+RpU2K9bXK04iZ3NwslfOVY2qDCDr+0Zxa2nwuVSvqgRaHWuCD+aLEmlk7kfFohNCt4PpHH6TuSpSiBjTSJnQ9R5xqrKM5xSJub1miUAzqLiTYpggonxpJg1ryuIiw12HaRjp+8okxC/CJE6TvBDet8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188476; c=relaxed/simple;
	bh=NfkB5LWuCJPVrk4KVZBKQ5f6UeLxlecEAhcaGXSo5Ag=;
	h=Date:To:From:Subject:Message-Id; b=Zz+NJ/1r0GVSDfW/oIxR0Tyt4Xydp6Uc9Uc+NTeUu/OcSwnmcqjtYvTMQxuo8doHACc33P9cW9LcaR595C8Vl0QJub0eiiYrT/jrXWQI6EbhN0EAi2KKw3mVRlqizO92UZW7EOrRhOHZoPcYjqHkx6uJ+qjwmXHz16ITBATw8xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lfx6n1if; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lfx6n1if"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14223C4CEEC;
	Mon, 17 Mar 2025 05:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188476;
	bh=NfkB5LWuCJPVrk4KVZBKQ5f6UeLxlecEAhcaGXSo5Ag=;
	h=Date:To:From:Subject:From;
	b=Lfx6n1ifzFjK3xKqHLcZrdGkI56dEocDCMrj5h+Npc4A/ZpPHqFZyZumcjSVFk89H
	 JpqvmfR4UsX5RDwLxEkD5zxu8elx+G4LKEGY9piu+DSjmZ1Z/n2CwRlQLIw6JuGkH3
	 92XUICNNAvn0CDE7kLUgw+YIZNZhKlreUT+Ya25Y=
Date: Sun, 16 Mar 2025 22:14:35 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,hannes@cmpxchg.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-warn-on-nr_reserved_highatomic-underflow.patch removed from -mm tree
Message-Id: <20250317051436.14223C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: warn on nr_reserved_highatomic underflow
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-warn-on-nr_reserved_highatomic-underflow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: warn on nr_reserved_highatomic underflow
Date: Tue, 25 Feb 2025 18:45:09 +0000

As documented in the comment this underflow should not happen.  The
locking has indeed changed here since the comment was written, see the
migratetype hygiene patches[0].  However, those changes made the locking
_safer_, so the underflow _really_ shouldn't happen now.  So upgrade the
comment to a warning.

[0] https://lore.kernel.org/all/20240320180429.678181-7-hannes@cmpxchg.org/T/#m3da87e6cc3348a4640aa298137bc9f8f61b76c84

Link: https://lkml.kernel.org/r/20250225-warn-underflow-v1-1-3dc542941d3a@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-warn-on-nr_reserved_highatomic-underflow
+++ a/mm/page_alloc.c
@@ -3095,6 +3095,7 @@ static bool unreserve_highatomic_pageblo
 			if (!page)
 				continue;
 
+			size = max(pageblock_nr_pages, 1UL << order);
 			/*
 			 * It should never happen but changes to
 			 * locking could inadvertently allow a per-cpu
@@ -3102,8 +3103,8 @@ static bool unreserve_highatomic_pageblo
 			 * while unreserving so be safe and watch for
 			 * underflows.
 			 */
-			size = max(pageblock_nr_pages, 1UL << order);
-			size = min(size, zone->nr_reserved_highatomic);
+			if (WARN_ON_ONCE(size > zone->nr_reserved_highatomic))
+				size = zone->nr_reserved_highatomic;
 			zone->nr_reserved_highatomic -= size;
 
 			/*
_

Patches currently in -mm which might be from jackmanb@google.com are

scripts-gdb-add-lx_per_cpu_ptr.patch

