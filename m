Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0012813AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744930; cv=none; b=WAHIErtEhwTn2cMWVuly553OL0PJ+6p2TR/K2N9uy/oXQ7Y2P0Bga2j8wsKJj9/QCGuRCH8AxXKfKmqywfsS9NqA3CUsQgZMIdQb3Ckjg8T4F7ptx6eIAELwdRzaYBFcdZNWJmXyMYoU5yIYePXtZMwX6thbdf39aHn/NjvWPeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744930; c=relaxed/simple;
	bh=R++FGeVUR2+Pb4/JcpA9Z4RBg9PEym5GxSuuzV0SB/U=;
	h=Date:To:From:Subject:Message-Id; b=kAB2otvTDKO18vVjMRq0Cx2AOAaQMw7g5GAV9dLtnePXc/nxdaUl4vraZY7JUflX1xMOkQvKlYIVWVdNxa40mFjoxwacZmgs3u19CF/ikbJhgmwM4WjMe73sS5gcVaAOb3QzjjykiTegoujYq9X/5+CPYa+Sh+RSQ8EdKd+Kzig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dSgxqAlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dSgxqAlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC76BC4CEF7;
	Sun, 29 Mar 2026 00:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744929;
	bh=R++FGeVUR2+Pb4/JcpA9Z4RBg9PEym5GxSuuzV0SB/U=;
	h=Date:To:From:Subject:From;
	b=dSgxqAlbVVantqq3/Pxyq1zZXPw2fjJy9nuqlPJMisuxZp5Uw3394Q3kJu8y/fhwv
	 4m8mqHuPESowAbd1oqESSTsV9Dfe0TZxlCAzHskaCzdYKR1vR2p1/31qhCjchmw8bu
	 FafvfrPBP197/IxsQuTCFP8uKmql6/IM4KN61EA8=
Date: Sat, 28 Mar 2026 17:42:09 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sidhartha.kumar@oracle.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-bootmem_info-remove-handling-for-config_sparsemem_vmemmap.patch removed from -mm tree
Message-Id: <20260329004209.CC76BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/bootmem_info: remove handling for !CONFIG_SPARSEMEM_VMEMMAP
has been removed from the -mm tree.  Its filename was
     mm-bootmem_info-remove-handling-for-config_sparsemem_vmemmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/bootmem_info: remove handling for !CONFIG_SPARSEMEM_VMEMMAP
Date: Fri, 20 Mar 2026 23:13:39 +0100

It is not immediately obvious that CONFIG_HAVE_BOOTMEM_INFO_NODE is only
selected from CONFIG_MEMORY_HOTREMOVE, which itself depends on
CONFIG_MEMORY_HOTPLUG that ...  depends on CONFIG_SPARSEMEM_VMEMMAP.

Let's remove the !CONFIG_SPARSEMEM_VMEMMAP leftovers that are dead code.

Link: https://lkml.kernel.org/r/20260320-sparsemem_cleanups-v2-7-096addc8800d@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem_info.c |   37 -------------------------------------
 1 file changed, 37 deletions(-)

--- a/mm/bootmem_info.c~mm-bootmem_info-remove-handling-for-config_sparsemem_vmemmap
+++ a/mm/bootmem_info.c
@@ -40,42 +40,6 @@ void put_page_bootmem(struct page *page)
 	}
 }
 
-#ifndef CONFIG_SPARSEMEM_VMEMMAP
-static void __init register_page_bootmem_info_section(unsigned long start_pfn)
-{
-	unsigned long mapsize, section_nr, i;
-	struct mem_section *ms;
-	struct page *page, *memmap;
-	struct mem_section_usage *usage;
-
-	section_nr = pfn_to_section_nr(start_pfn);
-	ms = __nr_to_section(section_nr);
-
-	/* Get section's memmap address */
-	memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-
-	/*
-	 * Get page for the memmap's phys address
-	 * XXX: need more consideration for sparse_vmemmap...
-	 */
-	page = virt_to_page(memmap);
-	mapsize = sizeof(struct page) * PAGES_PER_SECTION;
-	mapsize = PAGE_ALIGN(mapsize) >> PAGE_SHIFT;
-
-	/* remember memmap's page */
-	for (i = 0; i < mapsize; i++, page++)
-		get_page_bootmem(section_nr, page, SECTION_INFO);
-
-	usage = ms->usage;
-	page = virt_to_page(usage);
-
-	mapsize = PAGE_ALIGN(mem_section_usage_size()) >> PAGE_SHIFT;
-
-	for (i = 0; i < mapsize; i++, page++)
-		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
-
-}
-#else /* CONFIG_SPARSEMEM_VMEMMAP */
 static void __init register_page_bootmem_info_section(unsigned long start_pfn)
 {
 	unsigned long mapsize, section_nr, i;
@@ -100,7 +64,6 @@ static void __init register_page_bootmem
 	for (i = 0; i < mapsize; i++, page++)
 		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
 }
-#endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
 void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
 {
_

Patches currently in -mm which might be from david@kernel.org are


