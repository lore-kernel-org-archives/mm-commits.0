Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720D32DEA8C
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 01:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790127790; cv=none; b=tl0KoakIc4K2nKXtBgTytyiSF2sXuHUbL6gM39Oyh/9xoNRljHYggZcu/Xpo28Y0d3qMSPhB3g1jMIyfxSqY13fU0GiszFkiLptIWWB0FAjumVk11CQmQ+bFKo0NdrXn67T4uA1rAJiOCwY9nNj+sNFFrQ76TZP0yF01MGEG85U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790127790; c=relaxed/simple;
	bh=D01pmgTwUQWaGJKf6TJBP7YCGpZEywlvmPhNxnmWono=;
	h=Date:To:From:Subject:Message-Id; b=j9JHluhBK704FXaNxoeTCh7gdBKJHP130aX8KbNOWw6i47RJjSSRtrLRt090/23G/QCp49WNUbIDFg1GfWrAb206tGaU3yrfHxK7XsE680gElcnc1y85xy+F0PqjGsZfCR/aPHQbZqlZybFP8JPLSsgbh82Rd198+R0keOxZKWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B9ExI3qS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B9ExI3qS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E4B1F000FF;
	Wed, 23 Sep 2026 01:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790127789;
	bh=bIbzNAldpTgG7y4WqgYz3cwsdxl/Gdx8/0DsUDNy8+U=;
	h=Date:To:From:Subject;
	b=B9ExI3qSe5UI9H3ja2zcuqhhuM0YF5K+71dZPVhRBepZf5E/XHRU5ixWPS70qjEPs
	 Sr1BPyjZrBZH3rCEfv4kZiy6IJipz0c4sPcs40gR+R6kDLfO9EajGxOHcKf2WLVEj7
	 X4UUlCGUP5L9rqFgw18jBfsq9mj5voVpfmRpBX2A=
Date: Tue, 22 Sep 2026 18:43:08 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kevin.brodsky@arm.com,david@kernel.org,corbet@lwn.net,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-describe-set_memory-and-set_direct_map-apis-fix.patch added to mm-unstable branch
Message-Id: <20260923014308.E6E4B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs-mm-describe-set_memory-and-set_direct_map-apis-fix
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-describe-set_memory-and-set_direct_map-apis-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-describe-set_memory-and-set_direct_map-apis-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Mike Rapoport <rppt@kernel.org>
Subject: docs-mm-describe-set_memory-and-set_direct_map-apis-fix
Date: Tue, 22 Sep 2026 12:42:55 +0300

fix phrasing, per Kevin

Link: https://lore.kernel.org/arJNn2QD_pY6e14R@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 Documentation/mm/kernel-page-tables.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/mm/kernel-page-tables.rst~docs-mm-describe-set_memory-and-set_direct_map-apis-fix
+++ a/Documentation/mm/kernel-page-tables.rst
@@ -103,9 +103,9 @@ There are two families of functions for
 * `set_memory_*()` change permissions of an arbitrary kernel mapping. They
   take a kernel virtual address and the number of pages.
 
-* `set_direct_map_*()` change permissions of the direct mapping of the page
-  frame represented by a `struct page`. They take a `struct page` pointer and
-  the number of pages.
+* `set_direct_map_*()` change permissions of the direct mapping for the range
+  of page frames starting at the page represented by a `struct page`. They take
+  a `struct page` pointer and the number of pages.
 
 Architectures that implement `set_memory()` select `CONFIG_ARCH_HAS_SET_MEMORY`
 
_

Patches currently in -mm which might be from rppt@kernel.org are

set_memory-add-number-of-pages-parameter-to-set_direct_map-apis.patch
mm-vmalloc-set-areas-page_order-after-allocation-succeeds.patch
mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch
mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly.patch
mm-execmem-use-vm_flush_reset_perms-for-rox-cache-allocations.patch
revert-arch-introduce-set_direct_map_valid_noflush.patch
docs-core-api-memory-allocation-add-kalloc_obj-and-clarify-kmalloc.patch
maintainers-add-memory-related-docs-in-core-mm-to-mm-misc-section.patch
mm-execmem-free-rox-cache-chunks-only-when-they-span-an-entire-vm-area.patch
mm-execmem-handle-potential-allocation-errors-in-the-maple-tree.patch
mm-execmem-make-sure-rox-cache-always-contains-multiples-of-pmd_size.patch
mm-vmalloc-add-define_free-for-vfree.patch
mm-execmem-use-cleanup-infrastructure-in-rox-cache-functions.patch
docs-core-api-memory-allocation-clarify-when-to-use-kzalloc_obj-and-kzalloc.patch
docs-mm-describe-set_memory-and-set_direct_map-apis.patch
docs-mm-describe-set_memory-and-set_direct_map-apis-fix.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch

