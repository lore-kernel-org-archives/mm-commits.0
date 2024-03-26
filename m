Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DC413D263
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 19:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711482775; cv=none; b=c+CBJpSKuqTRph0RXRHcGw06UChB20f+M7PQvlrS4U080jO+TGKL4c11nex/XbXA8Pk2Xk9r3MZrmA4WjCA46sr3CHnSLfKeE6BE/e5jw738LayOAYNcFGkzlGKPeabX5mUYQwZYZ4yH2qs8LKn5ySPRRfjFHI/MDtMYo9IRDjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711482775; c=relaxed/simple;
	bh=IRDOLuQTnd6ACO6DldwZwDl6IogrKm+XrGSE7/RhzYA=;
	h=Date:To:From:Subject:Message-Id; b=XnnhOFDlpa/HMOtrfAwpq4uzS6WfDk09RY5EKjkxTGScBBGtX8ctx1QnwGjkvFK6nw2pmKe+a3w40kjDssdk/8G7rvZPaX/ObybhWB34V0F4IuDHUCwy824wAX0Mp6oo6WQZ6QZSbbX79OWGEm+rnoYJindwdjvdzgc5LlL3AZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jnOQaHHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jnOQaHHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF0BC433F1;
	Tue, 26 Mar 2024 19:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711482775;
	bh=IRDOLuQTnd6ACO6DldwZwDl6IogrKm+XrGSE7/RhzYA=;
	h=Date:To:From:Subject:From;
	b=jnOQaHHmkqr7NLLKJKpaH5vUpCCFOljySAhbTMzK68rCDc/coetnXWhTKWCix8uCz
	 dsw3z8udvZ6WuyJjPJs4CpLYETqULsnyhRsZc7ikBSFtCQ0nt/oRCUV3YJGEMmxYJ+
	 BGzhPujp/TllBj9pJ1y65nJPR/1cQW5fvxQCRKS8=
Date: Tue, 26 Mar 2024 12:52:54 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node.patch added to mm-unstable branch
Message-Id: <20240326195255.0BF0BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/init: remove the unnecessary special treatment for memory-less node
has been added to the -mm mm-unstable branch.  Its filename is
     mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node.patch

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
Subject: mm/init: remove the unnecessary special treatment for memory-less node
Date: Tue, 26 Mar 2024 14:11:28 +0800

Because memory-less node's ->node_present_pages and its zone's
->present_pages are all 0, the judgement before calling node_set_state()
to set N_MEMORY, N_HIGH_MEMORY, N_NORMAL_MEMORY for node is enough to skip
memory-less node.  The 'continue;' statement inside for_each_node() loop
of free_area_init() is gilding the lily.

Here, remove the special handling to make memory-less node share the same
code flow as normal node.  And the code comment above the 'continue'
statement is not needed either.

Link: https://lkml.kernel.org/r/20240326061134.1055295-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/mm/mm_init.c~mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node
+++ a/mm/mm_init.c
@@ -1835,28 +1835,16 @@ void __init free_area_init(unsigned long
 				panic("Cannot allocate %zuB for node %d.\n",
 				       sizeof(*pgdat), nid);
 			arch_refresh_nodedata(nid, pgdat);
-			free_area_init_node(nid);
-
-			/*
-			 * We do not want to confuse userspace by sysfs
-			 * files/directories for node without any memory
-			 * attached to it, so this node is not marked as
-			 * N_MEMORY and not marked online so that no sysfs
-			 * hierarchy will be created via register_one_node for
-			 * it. The pgdat will get fully initialized by
-			 * hotadd_init_pgdat() when memory is hotplugged into
-			 * this node.
-			 */
-			continue;
 		}
 
 		pgdat = NODE_DATA(nid);
 		free_area_init_node(nid);
 
 		/* Any memory on that node */
-		if (pgdat->node_present_pages)
+		if (pgdat->node_present_pages) {
 			node_set_state(nid, N_MEMORY);
-		check_for_memory(pgdat);
+			check_for_memory(pgdat);
+		}
 	}
 
 	calc_nr_kernel_pages();
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
mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch
mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch
mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch

