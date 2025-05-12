Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E6F14830F
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011010; cv=none; b=DyUyEZctm0E3zINXczQg/J7k3VX+uAvExMG+WwdEuLZVc74XKor5jtku0GkihIj8hzwSLERd+TPJEZIa17OJPGCWmQ8lm1fSd7lW9/KRSOKCIWiXIJbgzeZ8OV93zZhw8hpiuiQuLqVT9DS3XA/NB8nR6OBm/V4Nu9j9+MPmcMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011010; c=relaxed/simple;
	bh=hp10ybdrMtd65dBZz9P+gDp1KvPa5rxJbLPNrRsxPUY=;
	h=Date:To:From:Subject:Message-Id; b=ENIqr3kHcqwhKlqxW8vLcrygtL2rSrZ168fA11Ze9T/DbwGVAf+JSpD606bNzpheVROFnDo8ZpVDjon0LWa65v13sPfm7fluZBuoaQeuN7VcIx3ch2Cn48e/grIaVGdeBc+ucPt//86ufOCB+VWorO6Cz8FjfoQkVvRnPD0WpQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H+ERDCgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H+ERDCgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C816C4CEE4;
	Mon, 12 May 2025 00:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011010;
	bh=hp10ybdrMtd65dBZz9P+gDp1KvPa5rxJbLPNrRsxPUY=;
	h=Date:To:From:Subject:From;
	b=H+ERDCgxzAlhUiAgPA/zKqK6VZ3hfgp8hKXftjz5zbYSo4enj9+vNxiWP6yfIY4Vm
	 RUFL/DWfDgb11qO6980AnqFliAMC88s5P4gtrKwtsdwbPx8IwTD/LRxocuen+Ukti9
	 nijYnF/F2uQ5awAhfXgCphggCJUPkPQ4gIhX8xiQ=
Date: Sun, 11 May 2025 17:50:09 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,harry.yoo@oracle.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-show_mem-optimize-si_meminfo_node-by-reducing-redundant-code.patch removed from -mm tree
Message-Id: <20250512005010.4C816C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/show_mem: optimize si_meminfo_node by reducing redundant code
has been removed from the -mm tree.  Its filename was
     mm-show_mem-optimize-si_meminfo_node-by-reducing-redundant-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/show_mem: optimize si_meminfo_node by reducing redundant code
Date: Tue, 25 Mar 2025 15:38:03 +0800

Refactors the si_meminfo_node() function by reducing redundant code and
improving readability.

Moved the calculation of managed_pages inside the existing loop that
processes pgdat->node_zones, eliminating the need for a separate loop.

Simplified the logic by removing unnecessary preprocessor conditionals.

Ensured that both totalram, totalhigh, and other memory statistics are
consistently set without duplication.

This change results in cleaner and more efficient code without altering
functionality.

Link: https://lkml.kernel.org/r/20250325073803.852594-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/mm/show_mem.c~mm-show_mem-optimize-si_meminfo_node-by-reducing-redundant-code
+++ a/mm/show_mem.c
@@ -94,26 +94,20 @@ void si_meminfo_node(struct sysinfo *val
 	unsigned long free_highpages = 0;
 	pg_data_t *pgdat = NODE_DATA(nid);
 
-	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++)
-		managed_pages += zone_managed_pages(&pgdat->node_zones[zone_type]);
-	val->totalram = managed_pages;
-	val->sharedram = node_page_state(pgdat, NR_SHMEM);
-	val->freeram = sum_zone_node_page_state(nid, NR_FREE_PAGES);
-#ifdef CONFIG_HIGHMEM
 	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
 		struct zone *zone = &pgdat->node_zones[zone_type];
-
+		managed_pages += zone_managed_pages(zone);
 		if (is_highmem(zone)) {
 			managed_highpages += zone_managed_pages(zone);
 			free_highpages += zone_page_state(zone, NR_FREE_PAGES);
 		}
 	}
+
+	val->totalram = managed_pages;
+	val->sharedram = node_page_state(pgdat, NR_SHMEM);
+	val->freeram = sum_zone_node_page_state(nid, NR_FREE_PAGES);
 	val->totalhigh = managed_highpages;
 	val->freehigh = free_highpages;
-#else
-	val->totalhigh = managed_highpages;
-	val->freehigh = free_highpages;
-#endif
 	val->mem_unit = PAGE_SIZE;
 }
 #endif
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-rmap-rename-page__anon_vma-to-anon_vma-for-consistency.patch
mm-rmap-fix-typo-in-comment-in-page_address_in_vma.patch
mm-io-mapping-precompute-remap-protection-flags-for-clarity.patch
mm-debug_page_alloc-improve-error-message-for-invalid-guardpage-minorder.patch
mm-numa-remove-unnecessary-local-variable-in-alloc_node_data.patch

