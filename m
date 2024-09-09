Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC29F18E02A
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725924646; cv=none; b=FMvLPgjnWlwyzNOL/Q5gxxYLpEVSTrwz1am3U7aqFls6buROFVrzBjsIT3U/q7mjquOv3NUu1nPIMsA03rp2p0N5tLoNnxpAfJomY8YUXm80oHGnhKcH2oTVufSDMZj8MLcR0QHYKR4WVGqpiLb0BfrKrYjWpyTN4EtTOhe7V8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725924646; c=relaxed/simple;
	bh=n4Y7hheqAAaISmD8bzmK3LPJrKRuv2vPgqCLfQaPgDA=;
	h=Date:To:From:Subject:Message-Id; b=ZxhlhXgeB8IF3jNZiHkyO3oCEx1ER+DeceqBA8YVBR6f013KlKKuNd7e082x/5ecya4GWOXQzqdMAHuaMMhcGcZ2APxZU7w0Ra1ASU2ogTs5rPE9QBAFlFnm8w37Rvl6mdi8yf2AYRlI6UBvPR4IrPbg33k1w3weDWTJPXHZOhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YqvTER6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YqvTER6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E59C4CEC6;
	Mon,  9 Sep 2024 23:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725924645;
	bh=n4Y7hheqAAaISmD8bzmK3LPJrKRuv2vPgqCLfQaPgDA=;
	h=Date:To:From:Subject:From;
	b=YqvTER6cxe/KQ1U0PnYSSSDr92OTox6z2OLwLLcLhmNcME55HwiyhS+8YuQiKYmyc
	 yO7U75wmP2q1bLUuDV/2wuCrobZvaumRS+15uZab+dNQpv2OZyFhWJtnNIXFOgWQRL
	 BPtgUcDnwn2qgpp5S4dMIwv+SSznLsRBykc9rVXQ=
Date: Mon, 09 Sep 2024 16:30:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ioworker0@gmail.com,hughd@google.com,gshan@redhat.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-tidy-up-shmem-mthp-controls-and-stats-fix.patch removed from -mm tree
Message-Id: <20240909233045.68E59C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-tidy-up-shmem-mthp-controls-and-stats-fix
has been removed from the -mm tree.  Its filename was
     mm-tidy-up-shmem-mthp-controls-and-stats-fix.patch

This patch was dropped because it was folded into mm-tidy-up-shmem-mthp-controls-and-stats.patch

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm-tidy-up-shmem-mthp-controls-and-stats-fix
Date: Wed, 4 Sep 2024 11:47:29 +0100

Link: https://lkml.kernel.org/r/f7ced14c-8bc5-405f-bee7-94f63980f525@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-tidy-up-shmem-mthp-controls-and-stats-fix
+++ a/mm/huge_memory.c
@@ -606,8 +606,6 @@ static struct attribute *anon_stats_attr
 	&swpout_attr.attr,
 	&swpout_fallback_attr.attr,
 #endif
-	&split_attr.attr,
-	&split_failed_attr.attr,
 	&split_deferred_attr.attr,
 	NULL,
 };
@@ -636,6 +634,8 @@ static struct attribute *any_stats_attrs
 	&swpout_attr.attr,
 	&swpout_fallback_attr.attr,
 #endif
+	&split_attr.attr,
+	&split_failed_attr.attr,
 	NULL,
 };
 
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-cleanup-count_mthp_stat-definition.patch
mm-tidy-up-shmem-mthp-controls-and-stats.patch

