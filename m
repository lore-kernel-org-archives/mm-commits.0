Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECF338CFFE;
	Mon,  6 Apr 2026 18:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775499263; cv=none; b=HRUqIqNtXrLlBenkLgtqtB67IqQD1QCyB8rAazAPi/joyKPifTfxMrW3TVLHCKRI0NaBAyhWks6kFlznlDKHr88BfI3PL2rh3PdU7QWkEtr0dxUQ22HL/nUYOSCeCjp4rtoAfTbSFQOj3q2uy0WFLZppdw8uby+4BxUUj2qnPyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775499263; c=relaxed/simple;
	bh=j6jsV0fJuS8L00HjM1qF18Ze0Unhn2fonu8m+hvR3sI=;
	h=Date:To:From:Subject:Message-Id; b=TE6YT7/QGDAqHr/keP1CJ/kMqvzXhJeeLvnTyKwWkT2RECBHWSE7/TQVuS4zu3zmi1nEK/wNRPY5/otDK4WAekDsg+zueLXsdJ8NqFg1vrtnx6DXQO+RmYx0n97w+bD8aYyZ0hZyMd31p/jC/ZCz6nfgAodYEBsAZHRf+3chm1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rCQ0TrJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rCQ0TrJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D090C4CEF7;
	Mon,  6 Apr 2026 18:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775499263;
	bh=j6jsV0fJuS8L00HjM1qF18Ze0Unhn2fonu8m+hvR3sI=;
	h=Date:To:From:Subject:From;
	b=rCQ0TrJH00TiQtPatwVYS34vAVLfW4NqladKW9Ra1sgRUJEtCnW19O3vNr5vV+Wj4
	 LZHy5NZ+BVIMsKdvuTudzI9e5KF0gwuIf/kgYUU4Qxp2iDS8vY9iHT1Hvn4oFl5J1Q
	 t5tkP7jnWdfesSKR53iyn9nZdzRvsLhBo3iyhox8=
Date: Mon, 06 Apr 2026 11:14:22 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,vbabka@kernel.org,stable@vger.kernel.org,osalvador@suse.de,joshua.hahnjy@gmail.com,harry@kernel.org,david@kernel.org,hao.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory_hotplug-maintain-n_normal_memory-during-hotplug.patch removed from -mm tree
Message-Id: <20260406181423.4D090C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: maintain N_NORMAL_MEMORY during hotplug
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-maintain-n_normal_memory-during-hotplug.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Li <hao.li@linux.dev>
Subject: mm/memory_hotplug: maintain N_NORMAL_MEMORY during hotplug
Date: Mon, 30 Mar 2026 11:57:49 +0800

N_NORMAL_MEMORY is initialized from zone population at boot, but memory
hotplug currently only updates N_MEMORY.  As a result, a node that gains
normal memory via hotplug can remain invisible to users iterating over
N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
incorrectly marked as such.

The most visible effect is that
/sys/devices/system/node/has_normal_memory does not report a node even
after that node has gained normal memory via hotplug.

Also, list_lru-based shrinkers can undercount objects on such a node
and may skip reclaim on that node entirely, which can lead to a higher
memory footprint than expected.

Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
offline_pages().  Set the bit when a node that currently lacks normal
memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
offlining removes the last present pages from zones <= ZONE_NORMAL.

This restores the intended semantics without bringing back the old
status_change_nid_normal notifier plumbing which was removed in
8d2882a8edb8.

Current users that benefit include list_lru, zswap, nfsd filecache,
hugetlb_cgroup, and has_normal_memory sysfs reporting.

Link: https://lkml.kernel.org/r/20260330035941.518186-1-hao.li@linux.dev
Fixes: 8d2882a8edb8 ("mm,memory_hotplug: remove status_change_nid_normal and update documentation")
Signed-off-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-maintain-n_normal_memory-during-hotplug
+++ a/mm/memory_hotplug.c
@@ -1209,6 +1209,13 @@ int online_pages(unsigned long pfn, unsi
 
 	if (node_arg.nid >= 0)
 		node_set_state(nid, N_MEMORY);
+	/*
+	 * Check whether we are adding normal memory to the node for the first
+	 * time.
+	 */
+	if (!node_state(nid, N_NORMAL_MEMORY) && zone_idx(zone) <= ZONE_NORMAL)
+		node_set_state(nid, N_NORMAL_MEMORY);
+
 	if (need_zonelists_rebuild)
 		build_all_zonelists(NULL);
 
@@ -1908,6 +1915,8 @@ int offline_pages(unsigned long start_pf
 	unsigned long flags;
 	char *reason;
 	int ret;
+	unsigned long normal_pages = 0;
+	enum zone_type zt;
 
 	/*
 	 * {on,off}lining is constrained to full memory sections (or more
@@ -2056,6 +2065,17 @@ int offline_pages(unsigned long start_pf
 	init_per_zone_wmark_min();
 
 	/*
+	 * Check whether this operation removes the last normal memory from
+	 * the node. We do this before clearing N_MEMORY to avoid the possible
+	 * transient "!N_MEMORY && N_NORMAL_MEMORY" state.
+	 */
+	if (zone_idx(zone) <= ZONE_NORMAL) {
+		for (zt = 0; zt <= ZONE_NORMAL; zt++)
+			normal_pages += pgdat->node_zones[zt].present_pages;
+		if (!normal_pages)
+			node_clear_state(node, N_NORMAL_MEMORY);
+	}
+	/*
 	 * Make sure to mark the node as memory-less before rebuilding the zone
 	 * list. Otherwise this node would still appear in the fallback lists.
 	 */
_

Patches currently in -mm which might be from hao.li@linux.dev are


