Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE3213D258
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 19:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711482779; cv=none; b=M6NqLRhSesICyHPcQTh0SbDfsLkW/eNJk5OVR0H+wanEeRhQTxrKJkYT1KtKbAQ6z9I8w6DUOIcaiEUyk4XV0kNwcnCxFJW+pxdxqd/XN1LySDuDWH1d6xLGxlihzEh2mrIGdqqlrJ6eXsEFrjb17lJC+lkqiK33nhosxPIFpNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711482779; c=relaxed/simple;
	bh=uVoIMU07j5N2HZpa1+tcihhK+dnNo3X3R2abA7msXpc=;
	h=Date:To:From:Subject:Message-Id; b=SV/jtgjhmY7lYmMNwUX87m6916AsstLNsOFjfKVIy02/Htlu4HH816uBOgRc8iPKsBu4XT+YUnQnGhjpqG3j1cZ72hS4o53yp+xi5JP5rdMU7qMP5uKwqL3R7jSZ1rKxK2Q0XQdiNOTHHaHHA+6LMFyblLJlGB680OTii9fbb68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MuQG5/Td; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MuQG5/Td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E481DC433F1;
	Tue, 26 Mar 2024 19:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711482779;
	bh=uVoIMU07j5N2HZpa1+tcihhK+dnNo3X3R2abA7msXpc=;
	h=Date:To:From:Subject:From;
	b=MuQG5/Td6rYS9eISzS+sapHR6yfoxpY4fB4SvFb5bOM/e88IuZZnx0o/bBafX08A+
	 D03/EqHrinHLuqexSFww4PzCSE7XhDejboasTovkN+m26sXRR+rgymL0V24nbLBdK4
	 /ZZvOL2yWb5ZXXeh8yDzFH50QYJQ3h2Qg2VKx0Dw=
Date: Tue, 26 Mar 2024 12:52:58 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch added to mm-unstable branch
Message-Id: <20240326195258.E481DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc.c: remove unneeded codes in !NUMA version of build_zonelists()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch

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
Subject: mm/page_alloc.c: remove unneeded codes in !NUMA version of build_zonelists()
Date: Tue, 26 Mar 2024 14:11:30 +0800

When CONFIG_NUMA=n, MAX_NUMNODES is always 1 because Kconfig item
NODES_SHIFT depends on NUMA.  So in !NUMA version of build_zonelists(), no
need to bother with the two for loop because code execution won't enter
them ever.

Here, remove those unneeded codes in !NUMA version of build_zonelists().

Link: https://lkml.kernel.org/r/20240326061134.1055295-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   21 ---------------------
 1 file changed, 21 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists
+++ a/mm/page_alloc.c
@@ -5295,27 +5295,6 @@ static void build_zonelists(pg_data_t *p
 	nr_zones = build_zonerefs_node(pgdat, zonerefs);
 	zonerefs += nr_zones;
 
-	/*
-	 * Now we build the zonelist so that it contains the zones
-	 * of all the other nodes.
-	 * We don't want to pressure a particular node, so when
-	 * building the zones for node N, we make sure that the
-	 * zones coming right after the local ones are those from
-	 * node N+1 (modulo N)
-	 */
-	for (node = local_node + 1; node < MAX_NUMNODES; node++) {
-		if (!node_online(node))
-			continue;
-		nr_zones = build_zonerefs_node(NODE_DATA(node), zonerefs);
-		zonerefs += nr_zones;
-	}
-	for (node = 0; node < local_node; node++) {
-		if (!node_online(node))
-			continue;
-		nr_zones = build_zonerefs_node(NODE_DATA(node), zonerefs);
-		zonerefs += nr_zones;
-	}
-
 	zonerefs->zone = NULL;
 	zonerefs->zone_idx = 0;
 }
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

