Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC89357D16
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 21:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778620664; cv=none; b=qf73xRkYzie7/uJ5ahd35aeq+tX8yVggctZ2s5iporWizh733W5Aw3dbDqoOc1KcK1VlA2fU4kVPczyNwXnSQFvxBdrSV/U4H2LPVrp2zxauMLlNr/EOQ7PNKgsRTiamCQUUEdD2WyE8nVNN+IUrZSmj4XitkGlXbvbKZ19Jt2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778620664; c=relaxed/simple;
	bh=MGQLeBimDy/PM6RDK0IDxK3F+J6bzQG6+ujp4kE+ZFw=;
	h=Date:To:From:Subject:Message-Id; b=brUxwhxukL52t9lYe7ja23jpb0QT8PWmRVmQStUfDlPjd+OAHYT7n3h1IUws4ue2TzrC24HWOlrzTTFytWYwM4/P8WGpmrCyn0HmKR05WcztaUPgSNUHZsAMfVTdRgoDMUkmIhmd72pjm+QbjmU8x5f0j9MURRDGPZILmbG4hXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mIG5Pv39; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mIG5Pv39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3581C2BCB0;
	Tue, 12 May 2026 21:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778620663;
	bh=MGQLeBimDy/PM6RDK0IDxK3F+J6bzQG6+ujp4kE+ZFw=;
	h=Date:To:From:Subject:From;
	b=mIG5Pv39+9X3+7pdYeHDL/TdvcPbpOv/z+9M8v0XWi8E0YbfvePs6Yk7iRhG2BE9P
	 f79LgQ1jGUpdI58eirDCFSV1y09fkhbx2VZEZSPqZF3GGHmAHJ8FoeQVMSPvQWo6/r
	 Db5pq6O7alibvMdwEeSBOemaggTjmprbindibbAY=
Date: Tue, 12 May 2026 14:17:43 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-remove-config_have_bootmem_info_node.patch added to mm-new branch
Message-Id: <20260512211743.D3581C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
has been added to the -mm mm-new branch.  Its filename is
     powerpc-mm-remove-config_have_bootmem_info_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-remove-config_have_bootmem_info_node.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: powerpc/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
Date: Mon, 11 May 2026 16:05:36 +0200

register_page_bootmem_info_node() essentially only calls
register_page_bootmem_memmap(). However, on powerpc that function is a
nop. So there is not benefit in using CONFIG_HAVE_BOOTMEM_INFO_NODE
anymore, let's just drop it.

We can stop including bootmem_info.h.

Link: https://lore.kernel.org/20260511-bootmem_info_prep-v1-8-3fb0be6fc688@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/init_64.c |    8 --------
 mm/Kconfig                |    2 +-
 2 files changed, 1 insertion(+), 9 deletions(-)

--- a/arch/powerpc/mm/init_64.c~powerpc-mm-remove-config_have_bootmem_info_node
+++ a/arch/powerpc/mm/init_64.c
@@ -41,7 +41,6 @@
 #include <linux/libfdt.h>
 #include <linux/memremap.h>
 #include <linux/memory.h>
-#include <linux/bootmem_info.h>
 
 #include <asm/pgalloc.h>
 #include <asm/page.h>
@@ -388,13 +387,6 @@ void __ref vmemmap_free(unsigned long st
 
 #endif
 
-#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
-void register_page_bootmem_memmap(unsigned long section_nr,
-				  struct page *start_page, unsigned long size)
-{
-}
-#endif /* CONFIG_HAVE_BOOTMEM_INFO_NODE */
-
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 #ifdef CONFIG_PPC_BOOK3S_64
--- a/mm/Kconfig~powerpc-mm-remove-config_have_bootmem_info_node
+++ a/mm/Kconfig
@@ -537,7 +537,7 @@ endchoice
 
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
-	select HAVE_BOOTMEM_INFO_NODE if (X86_64 || PPC64)
+	select HAVE_BOOTMEM_INFO_NODE if X86_64
 	depends on MEMORY_HOTPLUG
 	select MIGRATION
 
_

Patches currently in -mm which might be from david@kernel.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free.patch
mm-fix-__vm_normal_page-to-handle-missing-support-for-pmd_special-pud_special.patch
sh-use-folio_mapped-instead-of-page_mapped-in-sh4_flush_cache_page.patch
bpf-arena-use-page_ref_count-instead-of-page_mapped-in-arena_free_pages.patch
mm-remove-page_mapped.patch
sparc-mm-remove-register_page_bootmem_info.patch
mm-bootmem_info-drop-initialization-of-page-lru.patch
mm-bootmem_info-stop-using-pg_private.patch
mm-bootmem_info-remove-call-to-kmemleak_free_part_phys.patch
mm-bootmem_info-stop-marking-the-pgdat-as-node_info.patch
mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info.patch
s390-mm-use-free_reserved_page-in-vmem_free_pages.patch
powerpc-mm-remove-config_have_bootmem_info_node.patch

