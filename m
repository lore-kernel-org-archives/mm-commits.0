Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A6132AACB
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622261; cv=none; b=W2VwmvsGE3GiXJgyBXcSDjJuZm4PAr/pPUGNCpo85qJGnF0M7OM2uGCWjRYuzPovaXfiHREm7S9FagAChJi9yG/KWzSl++kb6RZsOjEWOpXW3Dhk8mZQvS9Hq5nVR6mEClzGAeqmKWwhccjoeWRIqPsuRPqP7un20rzeYL8fra4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622261; c=relaxed/simple;
	bh=R+ejRogbTP0CJgBIA7YP/l7+ds1BqTOyPHiIqS3GySQ=;
	h=Date:To:From:Subject:Message-Id; b=owS4eZSMRLNKYXIoph+T6t6NKd9H/0z5uTZBGnjsXVDWGFalJjAjUeMcOBFY2DLw4j6g5FM4oH7/A+X0anCOFJocCN++E0Du50toIkgp70b8fBsCu1K9IdBR3sjYdSclZyGCg3leUe2LB4P+BDN2dQ3UygNSV0iF7pckOs8ElOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lT3YwnjG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lT3YwnjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893CA1F00A3A;
	Tue, 25 Aug 2026 01:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622259;
	bh=Iyw8cHyg4jYkebakqMDJdFHfGO4d5OPNrOkpubfeLLs=;
	h=Date:To:From:Subject;
	b=lT3YwnjGuUXjlIoAheNmc6qbHdIX6qtoA9IIDLzaH/mypJ5Tlv4QnHzz8Ht954iAF
	 aPo35u/EhimsixBQU8/FeD5ugRvk9EWpclYC1gw1R/+L/bUHH4dIs8GqzwGLt9UTMY
	 kAxJ6Qs8Dk9ByRGC8WVSyBRxe80Hy9A0N/+lJwRw=
Date: Mon, 24 Aug 2026 18:44:19 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kconfig-drop-redundant-memory-hotplug-dependencies.patch removed from -mm tree
Message-Id: <20260825014419.893CA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kconfig: drop redundant memory hotplug dependencies
has been removed from the -mm tree.  Its filename was
     mm-kconfig-drop-redundant-memory-hotplug-dependencies.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/kconfig: drop redundant memory hotplug dependencies
Date: Tue, 7 Jul 2026 17:03:31 +0800

MHP_MEMMAP_ON_MEMORY is defined inside the MEMORY_HOTPLUG block, and
MEMORY_HOTPLUG already depends on SPARSEMEM_VMEMMAP.  Keep the explicit
MEMORY_HOTPLUG dependency for local readability, but drop the redundant
SPARSEMEM_VMEMMAP dependency.

ZONE_DEVICE depends on MEMORY_HOTREMOVE, which depends on MEMORY_HOTPLUG. 
MEMORY_HOTPLUG in turn depends on SPARSEMEM_VMEMMAP.  Drop the direct
MEMORY_HOTPLUG and SPARSEMEM_VMEMMAP dependencies from ZONE_DEVICE.

This does not change the set of valid configurations.

Link: https://lore.kernel.org/20260707090331.52971-1-kaitao.cheng@linux.dev
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/Kconfig~mm-kconfig-drop-redundant-memory-hotplug-dependencies
+++ a/mm/Kconfig
@@ -588,7 +588,7 @@ config MEMORY_HOTREMOVE
 
 config MHP_MEMMAP_ON_MEMORY
 	def_bool y
-	depends on MEMORY_HOTPLUG && SPARSEMEM_VMEMMAP
+	depends on MEMORY_HOTPLUG
 	depends on ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
 
 endif # MEMORY_HOTPLUG
@@ -1227,9 +1227,7 @@ config ZONE_DMA32
 
 config ZONE_DEVICE
 	bool "Device memory (pmem, HMM, etc...) hotplug support"
-	depends on MEMORY_HOTPLUG
 	depends on MEMORY_HOTREMOVE
-	depends on SPARSEMEM_VMEMMAP
 	select XARRAY_MULTI
 
 	help
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are


