Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9D137D101
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439010; cv=none; b=CuLdY8dU7PvJ7dVzGG5j9eqUFX6Lr0KK4SjPiLgk8Tk2VMOxaILiSiZMaBDajcld4SYQ28Gu5bgWF2pn2zTOIzCXzbWZZaMUH0R2lXz80sBm8CxAf9lw4/qJK1kJfrcM/1zE1R56mxAWfCCRXO/sgZfBJl6NHaLBY17gMuwRa1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439010; c=relaxed/simple;
	bh=8cbssYJ43oxnpvbvOvBPoBCAjjUWDrM+Al2H2p4B9fE=;
	h=Date:To:From:Subject:Message-Id; b=VLKy764XQN94LpndHnclVslljltFnjH2KABIVpTvtoB6koUVz9LJqVtsYbiAiILCUlRrzvQX5+kg2QnRMTa3rB/MRlS5tZbztN5KbgO3ZOHqfkZKorXdbanWK38xXgLSG6aPASBvR7Ap4HodzaueDEABOF96AYPTjGYMYb9YRFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BHnxj5Ck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BHnxj5Ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344FB1F00898;
	Tue,  2 Jun 2026 22:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439009;
	bh=ERHLlUUKCBrPpDsmkf8wubV/ITRhcJ5ezcKbvm8uEmA=;
	h=Date:To:From:Subject;
	b=BHnxj5CkTam7UZIwRj8eyQY/nJvht1/NlwkWtimgE310M+zKRCp6KTAgTQosVifib
	 c89JXsaL/N9bf9Q4Gp52+FljyJc0xmTTwjv/HsnHluhiGWyFUAHgfSP6GP0tM5Ulr1
	 NULk+kq+Akph8iYwLUGCD1wr9R1d1eFIDECbfurk=
Date: Tue, 02 Jun 2026 15:23:28 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,gregkh@linuxfoundation.org,david@kernel.org,dakr@kernel.org,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-meminfo-expose-per-node-balloon-pages-in-node-meminfo.patch removed from -mm tree
Message-Id: <20260602222329.344FB1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc/meminfo: expose per-node balloon pages in node meminfo
has been removed from the -mm tree.  Its filename was
     proc-meminfo-expose-per-node-balloon-pages-in-node-meminfo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <hao.ge@linux.dev>
Subject: proc/meminfo: expose per-node balloon pages in node meminfo
Date: Sat, 9 May 2026 08:56:31 +0800

Commit 835de37603ef ("meminfo: add a per node counter for balloon
drivers") added NR_BALLOON_PAGES and exposed it in /proc/meminfo. 
However, the per-node view at /sys/devices/system/node/nodeX/meminfo was
not updated, even though the counter is already tracked per-node.

Add it to node_read_meminfo() so users can see balloon usage per NUMA node
without having to parse the raw vmstat file.

Link: https://lore.kernel.org/20260509005631.17183-1-hao.ge@linux.dev
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/base/node.c~proc-meminfo-expose-per-node-balloon-pages-in-node-meminfo
+++ a/drivers/base/node.c
@@ -523,6 +523,7 @@ static ssize_t node_read_meminfo(struct
 #ifdef CONFIG_UNACCEPTED_MEMORY
 			     "Node %d Unaccepted:     %8lu kB\n"
 #endif
+			     "Node %d Balloon:        %8lu kB\n"
 			     "Node %d GPUActive:      %8lu kB\n"
 			     "Node %d GPUReclaim:     %8lu kB\n"
 			     ,
@@ -559,6 +560,7 @@ static ssize_t node_read_meminfo(struct
 			     nid, K(sum_zone_node_page_state(nid, NR_UNACCEPTED))
 #endif
 			     ,
+			     nid, K(node_page_state(pgdat, NR_BALLOON_PAGES)),
 			     nid, K(node_page_state(pgdat, NR_GPU_ACTIVE)),
 			     nid, K(node_page_state(pgdat, NR_GPU_RECLAIM))
 			    );
_

Patches currently in -mm which might be from hao.ge@linux.dev are

mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list.patch
alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload.patch
lib-test_hmm-fix-memory-leak-in-dmirror_migrate_to_system.patch

