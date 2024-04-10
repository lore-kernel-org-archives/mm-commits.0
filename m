Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E23D1E877
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 20:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712781422; cv=none; b=g0/eNxkYRQVIOSI1zT6Z7PxraE0TK18SYWxcfN88wVjTYIQVHTkVv8VhswzNDqOUBu7lOEzBn+JcXftCj85eedtqDNNfmas6tzbjDFBxaMITNkMOr/PBUogyFYGpU6TUsbde56pQlHTQHBHD8ncJyY96vWs6h7ZpHLmWoavOd7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712781422; c=relaxed/simple;
	bh=RMwmaYafr797lfqVY1jIY0qpYR2agWRS9QfakTY9fPE=;
	h=Date:To:From:Subject:Message-Id; b=kpM5EmFwJsBPn4GmS/JfzWRYaPGeT7GZhKEsFBbhazpyZmC8NQHg8nDI3UZ7+oNYO9oUqiHOBSxtUMzOvSzbHNUIl80dm39QfncKLPueN7aXF6LoqS6214JTEWlwpGG/bDYznQkE5/8CYC/kDtueqB3NKrRPHvzSULaw92s5eqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MaCL9SIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MaCL9SIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77F7C433C7;
	Wed, 10 Apr 2024 20:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712781421;
	bh=RMwmaYafr797lfqVY1jIY0qpYR2agWRS9QfakTY9fPE=;
	h=Date:To:From:Subject:From;
	b=MaCL9SIutP3RoO7UyldWrQsIH0bsTuBDNw8ZERSGK+Dm16gbBKLO5vs/TTCxjX60o
	 9gKftFGWbzsYXjRBVuZKHqAvacMIyzdxU+JkDjKmW/CikKVIepgF77zLpST7MRmEPj
	 Z9+PrHs/TYpsoTaPSxkhgPiF3ccoYXfN/mmcb0Hc=
Date: Wed, 10 Apr 2024 13:37:01 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node-v2.patch added to mm-unstable branch
Message-Id: <20240410203701.B77F7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node-v2.patch

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
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core-v3.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch
mm-move-array-mem_section-init-code-out-of-memory_present.patch
mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node.patch
mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node-v2.patch
mm-make-__absent_pages_in_range-as-static.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2.patch
mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch
mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch
mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch
arch-loongarch-clean-up-the-left-code-and-kconfig-item-related-to-crash_core.patch
documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch

