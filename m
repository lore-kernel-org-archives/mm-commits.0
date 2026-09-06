Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBC93128B8
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 02:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788660359; cv=none; b=NEF8hqwuygKjd7vOU74JoC7tC3qCeRdYmQGRlTHN2iBRjIssLRvGubvubZ2gdEpIBuv2GXKNeWaPMitRaK0LacTq13+2frUCMS9ziBiGPxzyMjpFJ8dfpAcAnjSneYcbGmVgVTRkglh5GjUaej5x0JPpxV/AhTq7QC/7HYHG7v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788660359; c=relaxed/simple;
	bh=ug5JP9j0riRqAWk9ar0m5rPZJYDSQizUBhd+eXb3aBM=;
	h=Date:To:From:Subject:Message-Id; b=RbnbTmDi/nLfbWNXjH+SFHZTNvkc9czOJ+0SSC5m7jJSfF9EEE+Ey5A2jOMtbpF8EUVHLRKwDaiYNtwaEZCA0LSa9LUMeodFiGar5PwgNfCPZab7nCJa/vYE0hVWC0VHgtduLLFB05n7utFEJQb7wcvaCceSvUjbi50kdaqavTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WgfoWgLn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WgfoWgLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7171F00A3A;
	Sun,  6 Sep 2026 02:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788660358;
	bh=M5Bv+1HzPtDCcXOtmSPc1GK0EQzCGWS14M2qr76Ioy8=;
	h=Date:To:From:Subject;
	b=WgfoWgLnLSerxva4jOOts+8H3UDJLVNG5ZOOa2q1RtvrwAAZFC2btg8o1q7LuxfyZ
	 8IObW0/2QBJ5qv3QhaGd/XMFysttWWhtLbbv/9aVTXmdIETAcXu46d/Qb2EbtDKumY
	 j/VLHaC6+OZ/R0hJaPTGYkE+QmmOO3xaFI6sB0K4=
Date: Sat, 05 Sep 2026 19:05:57 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,mcgrof@kernel.org,jikos@kernel.org,bentiss@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-add-define_free-for-vfree.patch added to mm-new branch
Message-Id: <20260906020557.DC7171F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: add DEFINE_FREE() for vfree()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-add-define_free-for-vfree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-add-define_free-for-vfree.patch

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
Subject: mm/vmalloc: add DEFINE_FREE() for vfree()
Date: Thu, 03 Sep 2026 18:50:01 +0300

...  and use it in hid-core, the only place with a cleanup for a vmalloc()
allocation.

Link: https://lore.kernel.org/20260903-execmem-rox-cache-pmd-v1-v1-4-11beb2a3d249@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-core.c  |    4 ++--
 include/linux/vmalloc.h |    3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-core.c~mm-vmalloc-add-define_free-for-vfree
+++ a/drivers/hid/hid-core.c
@@ -944,7 +944,7 @@ static int hid_scan_report(struct hid_de
 		hid_parser_reserved
 	};
 
-	struct hid_parser *parser __free(kvfree) = vzalloc(sizeof(*parser));
+	struct hid_parser *parser __free(vfree) = vzalloc(sizeof(*parser));
 	if (!parser)
 		return -ENOMEM;
 
@@ -1265,7 +1265,7 @@ static int hid_parse_collections(struct
 		hid_parser_reserved
 	};
 
-	struct hid_parser *parser __free(kvfree) = vzalloc(sizeof(*parser));
+	struct hid_parser *parser __free(vfree) = vzalloc(sizeof(*parser));
 	if (!parser)
 		return -ENOMEM;
 
--- a/include/linux/vmalloc.h~mm-vmalloc-add-define_free-for-vfree
+++ a/include/linux/vmalloc.h
@@ -3,6 +3,7 @@
 #define _LINUX_VMALLOC_H
 
 #include <linux/alloc_tag.h>
+#include <linux/cleanup.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
@@ -215,6 +216,8 @@ void *__must_check vrealloc_node_align_n
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
 
+DEFINE_FREE(vfree, void *, if (!IS_ERR_OR_NULL(_T)) vfree(_T))
+
 extern void *vmap(struct page **pages, unsigned int count,
 			unsigned long flags, pgprot_t prot);
 void *vmap_pfn(unsigned long *pfns, unsigned int count, pgprot_t prot);
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

