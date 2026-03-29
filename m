Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8302D13AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744931; cv=none; b=R+cRKexoUZdjhdDlD9asO5S5y2aUTxovxUFgmRJqxODANgxWPPacmsGOat1pOdUvXwSt4GbdR0G1nvpudod6eVpZNyC0ubUuEmOu0an27j7kqiudWBr+lQ2WP1zSs3NAIXCGPo7n2HTZZZSKQqAf7tbLpbi1CqIcpI2YMa3Bgmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744931; c=relaxed/simple;
	bh=p9MRBKuqA8E5MJ3xUKIidssRKs+WbXswM5MH76PZX5U=;
	h=Date:To:From:Subject:Message-Id; b=HVncGELEU6HB3maBs0iLmYjfkmC8bqC9H6AF0kkghZGOyxdUewW1HgG+zW8a7oQ7ZcWXl5PmWXnBftVHWhoXvg/QIqESYzONc2t38YtklQRIgQoxzqj8zE4UDG/W4h9sJQMdhFIBpZrCZ4ldhmzSu/4VgU97Pap76IPx8+3cZpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mML+58CJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mML+58CJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5968DC4CEF7;
	Sun, 29 Mar 2026 00:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744931;
	bh=p9MRBKuqA8E5MJ3xUKIidssRKs+WbXswM5MH76PZX5U=;
	h=Date:To:From:Subject:From;
	b=mML+58CJ5j5RuzST2AXU4/ac5vR1uHoy65J6WoxWxDkl7QP6wtJhieSOKHuyayRxL
	 M0vLcKqVZIOkqyecieDQ4Zf9iicS0+E9qvcV6ekrEgz9hK2dRoUILbEGba70kMQOmK
	 ZFdeLdJBeiDRExu7mLhBoAC9f+HgWDSM8D6vHUwk=
Date: Sat, 28 Mar 2026 17:42:10 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sidhartha.kumar@oracle.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-bootmem_info-avoid-using-sparse_decode_mem_map.patch removed from -mm tree
Message-Id: <20260329004211.5968DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/bootmem_info: avoid using sparse_decode_mem_map()
has been removed from the -mm tree.  Its filename was
     mm-bootmem_info-avoid-using-sparse_decode_mem_map.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/bootmem_info: avoid using sparse_decode_mem_map()
Date: Fri, 20 Mar 2026 23:13:40 +0100

With SPARSEMEM_VMEMMAP, we can just do a pfn_to_page().  It is not super
clear whether the start_pfn is properly aligned ...  so let's just make
sure it is properly aligned to the start of the section.

We will soon might try to remove the bootmem info completely, for now,
just keep it working as is.

Link: https://lkml.kernel.org/r/20260320-sparsemem_cleanups-v2-8-096addc8800d@kernel.org
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

 mm/bootmem_info.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/bootmem_info.c~mm-bootmem_info-avoid-using-sparse_decode_mem_map
+++ a/mm/bootmem_info.c
@@ -44,17 +44,16 @@ static void __init register_page_bootmem
 {
 	unsigned long mapsize, section_nr, i;
 	struct mem_section *ms;
-	struct page *page, *memmap;
 	struct mem_section_usage *usage;
+	struct page *page;
 
+	start_pfn = SECTION_ALIGN_DOWN(start_pfn);
 	section_nr = pfn_to_section_nr(start_pfn);
 	ms = __nr_to_section(section_nr);
 
-	memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-
 	if (!preinited_vmemmap_section(ms))
-		register_page_bootmem_memmap(section_nr, memmap,
-				PAGES_PER_SECTION);
+		register_page_bootmem_memmap(section_nr, pfn_to_page(start_pfn),
+					     PAGES_PER_SECTION);
 
 	usage = ms->usage;
 	page = virt_to_page(usage);
_

Patches currently in -mm which might be from david@kernel.org are


