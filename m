Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A851B6CE9
	for <mm-commits@vger.kernel.org>; Sat, 21 Mar 2026 17:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774115647; cv=none; b=pj/SUzZJcUzHCHKTdcE4aR0ByCvitELGv/Q2RjcG6ejPKRebEVEJspqWC2gJ5HvYAMCcvSWiTCPfijvsG9Tr1qRz0VdNCtKds+D7kGWctQntiFzlFdmSFtWv/Z5yKCNLPI9wYFrJh9LuIxe54TCblSaf/KcvHPrHt6Kqk5Pz5z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774115647; c=relaxed/simple;
	bh=5LANFuRH4FIvlhhGXf9UIQmBeAkPsZ+ezDdCo2RCXiw=;
	h=Date:To:From:Subject:Message-Id; b=oN3i4Z9oJqSAJqRY4+ZONee9Mo7lAMv6awiVkOnac/8w9JaM/Nk50TJVnkDUTVOkqTzayMXwOK63lzlEri1ZV8GTEjSNTF63Q7E6KfnuaJbZ/N6LCnIrziYcVgSkanOlNoKxnOPHTN0NMdwlAzbCwvbDfH9QnAztzZ/wN8gMsRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UY/X65iD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UY/X65iD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E3BC19421;
	Sat, 21 Mar 2026 17:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774115646;
	bh=5LANFuRH4FIvlhhGXf9UIQmBeAkPsZ+ezDdCo2RCXiw=;
	h=Date:To:From:Subject:From;
	b=UY/X65iDv3UzRKIxf178rslLXARoMsaWv/IF5o08fOmH237LhwWQfWK/xfLGMqdeY
	 i0kNXPvbTeAt15ICT/XSM9qHjFf3kqwHuuM+iHCVe51MFRJdRihcRJSS57o6XsBsQR
	 nB2B+VX+L27segr8dwV5sFqUHac2+pP8UfwexOrQ=
Date: Sat, 21 Mar 2026 10:54:06 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mark-early-init-static-variables-with-__meminitdata.patch added to mm-new branch
Message-Id: <20260321175406.A1E3BC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mark early-init static variables with __meminitdata
has been added to the -mm mm-new branch.  Its filename is
     mm-mark-early-init-static-variables-with-__meminitdata.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mark-early-init-static-variables-with-__meminitdata.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
@@ -813,7 +813,7 @@ void __meminit reserve_bootmem_region(ph
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

mm-convert-vmemmap_pd_populate-to-static-functions.patch
sparc-use-vmemmap_populate_hugepages-for-vmemmap_populate.patch
mm-mark-early-init-static-variables-with-__meminitdata.patch

