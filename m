Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98B9134CF
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 04:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743655096; cv=none; b=bytbOY6UbbjmwQmsc73xyQ5nXei9OJH+mFTpYRj9YzHIoDQgwiY3IyMODEB8bN7RRV2wVvuCnkJE9fWhoECCN7LpdAadxMATOfqafdkirQ+7F4pFvnnHwp3P0PIZ+RF4TaTi8z1/43a954yuO2WlEXNpnBFNGAUNfSQrb/a/OBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743655096; c=relaxed/simple;
	bh=L/lwH+CEsqKNaqBjhRV2HeTTX95P5PrpOFv6BhXwTwE=;
	h=Date:To:From:Subject:Message-Id; b=fhvu+v/LzFdFdmBCX5splvougKy6EFtAiTBftrPDWSeL+UvOOEY4X75t988mszef9PrYzTDsZcPYNa9YGcYtuJRdObYXIdX4ZzO0k66a8310V7Cv7rE/Ixb6tcL/n2TcrhwomsHCT5vI6q0hXJE4bTL9ImlBjBruDjldjoBTbrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JQp7ocGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JQp7ocGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFACC4CEE3;
	Thu,  3 Apr 2025 04:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743655096;
	bh=L/lwH+CEsqKNaqBjhRV2HeTTX95P5PrpOFv6BhXwTwE=;
	h=Date:To:From:Subject:From;
	b=JQp7ocGXSdsT9yqdgTIB72ftguSb21MRWvTKS8dFMnpS9MG7PTBgRcSI4At5e6Zy2
	 faLLxFPW0jAtIL2NhqtEv8ojRFvcGF7uERhSDkCcOZPixmuUdZaAZcOqOf1k2W+8Sm
	 qtTn804cA6hZyim6fTZ+IMyi2qqbYUv+jMgoiFgM=
Date: Wed, 02 Apr 2025 21:38:15 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,harry.yoo@oracle.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-show_mem-optimize-si_meminfo_node-by-reducing-redundant-code.patch added to mm-new branch
Message-Id: <20250403043815.EBFACC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/show_mem: optimize si_meminfo_node by reducing redundant code
has been added to the -mm mm-new branch.  Its filename is
     mm-show_mem-optimize-si_meminfo_node-by-reducing-redundant-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-show_mem-optimize-si_meminfo_node-by-reducing-redundant-code.patch

This patch will later appear in the mm-new branch at
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

mm-show_mem-optimize-si_meminfo_node-by-reducing-redundant-code.patch

