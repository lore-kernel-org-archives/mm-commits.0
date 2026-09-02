Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA5243932A
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 22:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788388249; cv=none; b=L7y6FEwv8ZjU9WIzVX7QmAFXeB+sB3oN4FHPcDvt59xZ9ACnN94KhbCJfxWMuGuTJqoDxQRHDGnRatGf0ZCR6bQrmqAPwfYdOlLk6NTc1bV1jMVP7AcgFpXHWwlUwBmHNVJBQfttoUxKK+9mJlAp8arQ0gdjXmZry3ShNfDeCTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788388249; c=relaxed/simple;
	bh=jrs24jDC1OqH8VYZnff1/SEyBkUz1+Cz+xx/Gy4Y1Zc=;
	h=Date:To:From:Subject:Message-Id; b=Paz00stJ/FDbRdt9R5tjFLjbLuk6j/mFHGeAvrvajkVdUSMgKmu/D867uk0eMYD8Jsa8iweafS+MPYXCgdGCpOurC0tJ8iy+4H8H3c34LyL3jYM2qw1ghSDq6r1aLTsL/Xz5NopA9TiL+uGPWkNzgovK52LqTTarJ6/IW3O++WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XhEnC1eq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XhEnC1eq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94541F00A3A;
	Wed,  2 Sep 2026 22:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788388242;
	bh=jVIrpUt+szGYh0Jfpf2Oqur3hhXuNKMxtYfTYlaGhrA=;
	h=Date:To:From:Subject;
	b=XhEnC1equQXwlwlTvWDo+6FMS2e+5yXQArYbtKONXlehQ4ChZ1tVbgiUZWh/iwaF9
	 RKMfZHjlIrmjP9YjimWXKcLttknzUx1MIWuvfBWrzBAhWH2IfABDsQj+eYFOgRZ1Fy
	 1y500hU/JAnl5xt4UYjYKrAmCR5cDVi2PQ8ZerrY=
Date: Wed, 02 Sep 2026 15:30:42 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-memory-related-docs-in-core-mm-to-mm-misc-section.patch added to mm-new branch
Message-Id: <20260902223042.A94541F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add memory related docs in core-mm/ to MM - MISC section
has been added to the -mm mm-new branch.  Its filename is
     maintainers-add-memory-related-docs-in-core-mm-to-mm-misc-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-memory-related-docs-in-core-mm-to-mm-misc-section.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MAINTAINERS: add memory related docs in core-mm/ to MM - MISC section
Date: Wed, 02 Sep 2026 11:10:12 +0300

Previous efforts to make sure that mm files are properly listed in
MAINTAINERS missed

Documentation/core-api/mm-api.rst
Documentation/core-api/memory-allocation.rst

Add them to "MEMORY MANAGEMENT - MISC"

Link: https://lore.kernel.org/20260902-docs-memalloc-guide-v2-2-218c1a4dcb80@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-memory-related-docs-in-core-mm-to-mm-misc-section
+++ a/MAINTAINERS
@@ -17271,6 +17271,8 @@ F:	Documentation/ABI/testing/sysfs-kerne
 F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
 F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
 F:	Documentation/admin-guide/mm/
+F:	Documentation/core-api/memory-allocation.rst
+F:	Documentation/core-api/mm-api.rst
 F:	Documentation/mm/
 F:	mm/char-mem.c
 F:	include/linux/cma.h
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

