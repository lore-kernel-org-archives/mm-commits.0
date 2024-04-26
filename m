Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4BA2BAE5
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714102159; cv=none; b=O6lID72slZG3lkxvX6Oaf5UTWZ5unR1Ipqy4VUgu2p1HuUI4deuggEQ4LH91TvsHXso8KLq1HsESVaJGXjumgztY07rRzHlWayey+61qXu9SpTrQ3lzOoml6Ws+pMn89eriTO2/6iH0cQdzl+fIYEmy6KXQ1dN/bysA6pyMNhV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714102159; c=relaxed/simple;
	bh=m4YRL36WSQ47fisE63BlAAsYdod8wpTCpInrlodDiYY=;
	h=Date:To:From:Subject:Message-Id; b=Aw2zmDX5Qt3qU4J6DRTTeH6fnM9l9wSMPdrjODXPtzSnUP4Zd/+bG1KyI9Tlq6yJQV9QueZ2FSHruD28f968GPr1PMjhnjxOAHB5iDxnSwwfn7fLqWhSCVMg0H1nAfUcUcfRoIAWB3Az3j2tTjklvaZhZvpiMYwy5j5/mGU3D/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oDIpcsOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oDIpcsOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD38C113CD;
	Fri, 26 Apr 2024 03:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714102159;
	bh=m4YRL36WSQ47fisE63BlAAsYdod8wpTCpInrlodDiYY=;
	h=Date:To:From:Subject:From;
	b=oDIpcsOhixtF+f0f4ZiQgzIiBvge0LnF4NoP0dE5YIH4aI0uOti/HEB4IiQr5Se6+
	 2AFXgTphZhN36VF+Scq/m5eu+22ft/EKm2ecFhQaGMdxB4vQqz1yVgQntBE3Ia+WGB
	 wbq8ta1l8k7ZgDwNwjJBIP9PLXgkuOWARlDPcmGw=
Date: Thu, 25 Apr 2024 20:29:18 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node-v2.patch removed from -mm tree
Message-Id: <20240426032919.3AD38C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node-v2
has been removed from the -mm tree.  Its filename was
     mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node-v2.patch

This patch was dropped because it was folded into mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node.patch

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node-v2
Date: Wed, 10 Apr 2024 11:35:29 +0800

redo code comments, per Mike

As Mike suggested, the old code comments above the 'continue' statement is
still useful for easier understanding code and system behaviour.  So
rephrase and move them above line 'if (pgdat->node_present_pages)'. 
Thanks to Mike.  

Link: https://lkml.kernel.org/r/ZhYJAVQRYJSTKZng@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node-v2
+++ a/mm/mm_init.c
@@ -1840,7 +1840,14 @@ void __init free_area_init(unsigned long
 		pgdat = NODE_DATA(nid);
 		free_area_init_node(nid);
 
-		/* Any memory on that node */
+		/*
+		 * No sysfs hierarcy will be created via register_one_node()
+		 *for memory-less node because here it's not marked as N_MEMORY
+		 *and won't be set online later. The benefit is userspace
+		 *program won't be confused by sysfs files/directories of
+		 *memory-less node. The pgdat will get fully initialized by
+		 *hotadd_init_pgdat() when memory is hotplugged into this node.
+		 */
 		if (pgdat->node_present_pages) {
 			node_set_state(nid, N_MEMORY);
 			check_for_memory(pgdat);
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch
x86-remove-unneeded-memblock_find_dma_reserve.patch
mm-mm_initc-remove-the-useless-dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_all_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch
mm-move-array-mem_section-init-code-out-of-memory_present.patch
mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node.patch
mm-make-__absent_pages_in_range-as-static.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2.patch
mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch
mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch
mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch
documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch
crash-add-prefix-for-crash-dumping-messages.patch

