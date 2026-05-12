Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85B2342524
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 23:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778627305; cv=none; b=ObdGW+zaMLZJEMvRdNkAGZUxDxFtXgvudHdRAXjcgGcdOYe27YJZEX3xp9PxTmbyiBZx84Tzixc5zNdjGn8RNiQAm+mCbDDoraLCu8JCTeQNem9UHwVEC2gZDvaTzvAguD1BSDtB9tH4oIhFJESHmo+Bx7iZKwun88ty+Q9vJqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778627305; c=relaxed/simple;
	bh=6uJmCdx6rpil3jGCK6oy7dzoyKh7gLBOLHruc4oGfwg=;
	h=Date:To:From:Subject:Message-Id; b=fL1rLd5q91GYLU/mo4Hb6p3fqIvjkFHoif8xhMvnSCNmdj2YBIOmVWhJnbAdnaNjnbo9x0E71x2ti+G7jLAtNTKjYmnVeeVRlDeqXIdmjROKWhpkb5P7PTICaX7EL4egpSoCTvxOngeuYGD2Y9uqz3cHKfXXKW8r67iaN4q7rWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dqBiR6Ff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dqBiR6Ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547D1C2BCB0;
	Tue, 12 May 2026 23:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778627305;
	bh=6uJmCdx6rpil3jGCK6oy7dzoyKh7gLBOLHruc4oGfwg=;
	h=Date:To:From:Subject:From;
	b=dqBiR6FfRvsPmJug7V5czRXt6biHbbsfl/dt1WWIhIUTxiVsdTpbpQkCPjz21Zrjb
	 Y9PF5c2MMCs2DM72TPrwoUIePBZdQ57Z1af429HavhUNnqemw03C2PVaJdutn/punC
	 pw9X0Czwa07NdzJ5Nlvryy/P8P/LM+AFeEUdh8bc=
Date: Tue, 12 May 2026 16:08:24 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,david@kernel.org,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-balloon-expose-per-node-balloon-pages-in-node-meminfo.patch removed from -mm tree
Message-Id: <20260512230825.547D1C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc/meminfo: expose per-node balloon pages in node meminfo
has been removed from the -mm tree.  Its filename was
     mm-balloon-expose-per-node-balloon-pages-in-node-meminfo.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hao Ge <hao.ge@linux.dev>
Subject: proc/meminfo: expose per-node balloon pages in node meminfo
Date: Fri, 8 May 2026 17:47:36 +0800

Commit 835de37603ef ("meminfo: add a per node counter for balloon
drivers") added NR_BALLOON_PAGES and exposed it in /proc/meminfo.
However, the per-node view at /sys/devices/system/node/nodeX/meminfo
was not updated, even though the counter is already tracked per-node.

Add it to node_read_meminfo() so users can see balloon usage per
NUMA node without having to parse the raw vmstat file.

Link: https://lore.kernel.org/20260508094736.142467-1-hao.ge@linux.dev
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/base/node.c~mm-balloon-expose-per-node-balloon-pages-in-node-meminfo
+++ a/drivers/base/node.c
@@ -525,6 +525,7 @@ static ssize_t node_read_meminfo(struct
 #endif
 			     "Node %d GPUActive:      %8lu kB\n"
 			     "Node %d GPUReclaim:     %8lu kB\n"
+			     "Node %d Balloon:        %8lu kB\n"
 			     ,
 			     nid, K(node_page_state(pgdat, NR_FILE_DIRTY)),
 			     nid, K(node_page_state(pgdat, NR_WRITEBACK)),
@@ -560,7 +561,8 @@ static ssize_t node_read_meminfo(struct
 #endif
 			     ,
 			     nid, K(node_page_state(pgdat, NR_GPU_ACTIVE)),
-			     nid, K(node_page_state(pgdat, NR_GPU_RECLAIM))
+			     nid, K(node_page_state(pgdat, NR_GPU_RECLAIM)),
+			     nid, K(node_page_state(pgdat, NR_BALLOON_PAGES))
 			    );
 	len += hugetlb_report_node_meminfo(buf, len, nid);
 	return len;
_

Patches currently in -mm which might be from hao.ge@linux.dev are

mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list.patch

