Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8436F3BBFD1
	for <mm-commits@vger.kernel.org>; Thu, 16 Jul 2026 23:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784245597; cv=none; b=ExzY/7NdxRfjQl6qD305hhxdIOPj5SrhTS9tLM63DX+13AIAAbPJKPEoDUfDImGaEFB4bDNCpMb95rCkMEqAxhvWRDqWSF4lg7eKDeu/8DvSLkEdt5nmnrObk728Cd8N1C5QmjCM1lhhPY0zrRu+YePRwLyn2hNQqApvgylCeBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784245597; c=relaxed/simple;
	bh=UW8ieh9FEY8vInHod6+HcaEuoEk6+Sw12bRPJO2MFxk=;
	h=Date:To:From:Subject:Message-Id; b=G0uKw0c5bdL4GgQCXmEzNwP5Wq3omyl/YSoPz8jcELmAFjgYHGA+PJTsNf5/XQ5M3m7Qf4cfQDSgdmdkfS76aY7jrrwyBgD+A8Ip+sWxtNBgal/ZYOsFRNqNt4aFUVdBkcxasT5SCj6PTqU0xnxya/1QjlJ69qCoxIP4ViEPG7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QQQuSh+H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QQQuSh+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A88B1F000E9;
	Thu, 16 Jul 2026 23:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784245595;
	bh=o98WE8SnRDfp67+rVTn5+t5wHtMMZbzsd8OHROmFjlU=;
	h=Date:To:From:Subject;
	b=QQQuSh+H1zfapMNY6eOCbFsIBjjKblnDWoSwjMzpLrzfUjH+kvOxAsruVj7uScuNf
	 7WH2A7rEqta2he2jhvGOAQFzYYQ42FyF9MyXw0PuofVOMPY3ZNrJnywelaYlvzqAbR
	 Bc4le/mKzhBuAZB6uaUANOZOATtTkIE5XLE1R/yw=
Date: Thu, 16 Jul 2026 16:46:34 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-remove-bootmem_infoh-include.patch removed from -mm tree
Message-Id: <20260716234635.5A88B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: remove bootmem_info.h include
has been removed from the -mm tree.  Its filename was
     mm-sparse-remove-bootmem_infoh-include.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: remove bootmem_info.h include
Date: Wed, 08 Jul 2026 16:11:04 +0200

No longer required, so let's remove it.

Link: https://lore.kernel.org/20260708-bootmem_info_part2-v1-9-156ce4986598@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/sparse.c~mm-sparse-remove-bootmem_infoh-include
+++ a/mm/sparse.c
@@ -13,7 +13,6 @@
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
-#include <linux/bootmem_info.h>
 #include <linux/vmstat.h>
 #include "internal.h"
 #include <asm/dma.h>
_

Patches currently in -mm which might be from david@kernel.org are

sparc-mm-drop-custom-pte_clear_not_present_full.patch
mm-drop-pte_clear_not_present_full.patch
mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch
mm-standardize-printing-for-pgtable-entries.patch

