Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A06277CB8
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744955; cv=none; b=H/Hzf99jaAtW279oElZPBj16QuXqyWpAHZiok8t2RzKhx5MuQxmwxB6Cl5sSpRhMdJEZQZDP+XmzPfCSIuW79xbjOqT8rekuWe3sHW/K/en3oOfD8GCOrHPBfi9qWevXIJ/VJwn4R+sDMIEmrRprwfzkVh5HF2W+O/NRePv/SRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744955; c=relaxed/simple;
	bh=+4rmANo9j47jJpR4ua1dzscKtRnCi/bpUHLYFhZg1A4=;
	h=Date:To:From:Subject:Message-Id; b=DyPGP5ITF12sX6myw/cjNhm4PX1m22et5doK+utaxFgRiuJoaW4mGJamKRZdgQqC+QpQFpxo+Gi8g8mw4EMj+D6x/7awHwIT3tUz++luQzlWP+T+t7jSe5txXbJ5TDqtdNB7onu6BPXspYme1zCtat2206ysgWCaaJsD7/dB1Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x1XQXcxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x1XQXcxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3B4C4CEF7;
	Sun, 29 Mar 2026 00:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744955;
	bh=+4rmANo9j47jJpR4ua1dzscKtRnCi/bpUHLYFhZg1A4=;
	h=Date:To:From:Subject:From;
	b=x1XQXcxS6BWiYi6X9Sa1YDVpFakZOG/NE7SdmQGwJM70ijaoShxYW3gBujbBYSPvZ
	 WgyWq6NDUETdG26utgMQjfzajVRfkFaXTF+3MFPaH7K/RCNxrnIqNcDC8Uy+jaWFAh
	 dKnBlk1jC5ffhrCQs+NHzRmuOL6OSRUDEF2lf7WA=
Date: Sat, 28 Mar 2026 17:42:34 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mark-early-init-static-variables-with-__meminitdata.patch removed from -mm tree
Message-Id: <20260329004235.0C3B4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mark early-init static variables with __meminitdata
has been removed from the -mm tree.  Its filename was
     mm-mark-early-init-static-variables-with-__meminitdata.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm: mark early-init static variables with __meminitdata
Date: Sat, 21 Mar 2026 20:08:47 +0800

Static variables defined inside __meminit functions should also be marked
with __meminitdata, so that their storage is placed in the .init.data
section and reclaimed with free_initmem(), thereby reducing permanent .bss
memory usage when CONFIG_MEMORY_HOTPLUG is disabled.

Link: https://lkml.kernel.org/r/20260321120847.8159-1-pilgrimtao@gmail.com
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c        |    2 +-
 mm/sparse-vmemmap.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mm_init.c~mm-mark-early-init-static-variables-with-__meminitdata
+++ a/mm/mm_init.c
@@ -812,7 +812,7 @@ void __meminit reserve_bootmem_region(ph
 static bool __meminit
 overlap_memmap_init(unsigned long zone, unsigned long *pfn)
 {
-	static struct memblock_region *r;
+	static struct memblock_region *r __meminitdata;
 
 	if (mirrored_kernelcore && zone == ZONE_MOVABLE) {
 		if (!r || *pfn >= memblock_region_memory_end_pfn(r)) {
--- a/mm/sparse-vmemmap.c~mm-mark-early-init-static-variables-with-__meminitdata
+++ a/mm/sparse-vmemmap.c
@@ -62,7 +62,7 @@ void * __meminit vmemmap_alloc_block(uns
 	if (slab_is_available()) {
 		gfp_t gfp_mask = GFP_KERNEL|__GFP_RETRY_MAYFAIL|__GFP_NOWARN;
 		int order = get_order(size);
-		static bool warned;
+		static bool warned __meminitdata;
 		struct page *page;
 
 		page = alloc_pages_node(node, gfp_mask, order);
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are


