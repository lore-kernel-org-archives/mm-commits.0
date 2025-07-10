Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDFB285062
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126314; cv=none; b=hd7iBPpXVIG/dmo4JG7SnC5iuI7Q4+dgjC5Cf9aLB1B+DGRfwYnHHVZJNNCT9GtzEOJuVzU+150c3W2XU9KIdEJMdsYsss1CP2kTiPGPociDnIqe1hqTbNahickkZGrfZR64A5t8RRYBbVfgueCa1nwQv+usO8ohIovjo4i3l1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126314; c=relaxed/simple;
	bh=6EcUs4Q4TKfAJPVnBCFmASiwSMDke+T0tJi1VJTTSUk=;
	h=Date:To:From:Subject:Message-Id; b=Rj+wDuEvdcltfCm30xSN9WA+/1se2eDz07Wdpg7umgMu5bTTN52yXZLY57G16ukjwFE262W5YP2kcHjN7KpNIxLjAKpLAknOln1S4FzCxhYZgHVV3/ZrQFN0u1mABUQx9jkn35ilnyCDqhd1AceTHKbUssm/OxQZVxLHwMAk5vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gdGyPd6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gdGyPd6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83470C4CEE3;
	Thu, 10 Jul 2025 05:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126313;
	bh=6EcUs4Q4TKfAJPVnBCFmASiwSMDke+T0tJi1VJTTSUk=;
	h=Date:To:From:Subject:From;
	b=gdGyPd6rrIo6rbWpahFt3uSYthAJmo1lxcmo8Lhwu8DL5uenAmB48dLpuKeBPUMDt
	 zq2QbuHp7Cgc/5wkRJzd+fvWd5cOAfKSMYcJ4xRkWTx1LAO0ozpvJDiLNKkMZ1cMMU
	 5RXsyW47DallHkHMTUopyDmzEmuXgfQseYtXMqxg=
Date: Wed, 09 Jul 2025 22:45:12 -0700
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,willy@infradead.org,surenb@google.com,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,howlett@gmail.com,hailong.liu@oppo.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-radix-tree-test-maple-tree-chaining-mas_preallocate-calls.patch removed from -mm tree
Message-Id: <20250710054513.83470C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/radix-tree: test maple tree chaining mas_preallocate() calls
has been removed from the -mm tree.  Its filename was
     tools-testing-radix-tree-test-maple-tree-chaining-mas_preallocate-calls.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: tools/testing/radix-tree: test maple tree chaining mas_preallocate() calls
Date: Mon, 16 Jun 2025 14:45:21 -0400

Testing calling multiple mas_preallocate() calls in a row after adjusting
the maple state.  Ensures new calls to mas_preallocate() will change the
number of allocated nodes.

Link: https://lkml.kernel.org/r/20250616184521.3382795-4-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Hailong Liu <hailong.liu@oppo.com>
Cc: "Liam R. Howlett" <howlett@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/tools/testing/radix-tree/maple.c~tools-testing-radix-tree-test-maple-tree-chaining-mas_preallocate-calls
+++ a/tools/testing/radix-tree/maple.c
@@ -35669,6 +35669,18 @@ static noinline void __init check_preall
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
+
+	/* Chaining multiple preallocations */
+	mt_set_in_rcu(mt);
+	mas_set_range(&mas, 800, 805); /* Slot store, should be 0 allocations */
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	allocated = mas_allocated(&mas);
+	MT_BUG_ON(mt, allocated != 0);
+	mas.last = 809; /* Node store */
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	allocated = mas_allocated(&mas);
+	MT_BUG_ON(mt, allocated != 1);
+	mas_store_prealloc(&mas, ptr);
 }
 /* End of preallocation testing */
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


