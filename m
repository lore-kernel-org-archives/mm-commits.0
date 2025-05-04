Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329FE33E7
	for <mm-commits@vger.kernel.org>; Sun,  4 May 2025 00:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746319857; cv=none; b=sSibJfAMYz2X9C9K+Zuf2cAOASpYeX5PIcncz8KbObRW95iCmr+/RF3MzYRfUgL0ULvPbzSvpDe1b9tLB4GNBq+qXzFedllEmSM2siQ4oaPTF264v8Ed4T1vDCXteZM0BSxTR8U3NYShzCVqIzNfZwXSBNiMUXYm2cfjChCPfzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746319857; c=relaxed/simple;
	bh=/VyyYt9ODhNKhlwDO6I6wqMQmgupESqzD3NL8xrzFxw=;
	h=Date:To:From:Subject:Message-Id; b=n8pkVu0d49c1QHdL1sdNELyvDy45zAtqUDjQTQ9gYlhEvp5Xilg9lD53wi5j0ih7PsL9Q386g67QpIkPQIiwbDhSX0/s3n+1IFbSoVLqbvI1l0NmKcSyoereL16rG3GF92YUxFae3NgP3L85AEiN3aKYZLbFiEkYnSHKJFzawig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oTTqLojv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oTTqLojv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BF8C4CEE3;
	Sun,  4 May 2025 00:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746319855;
	bh=/VyyYt9ODhNKhlwDO6I6wqMQmgupESqzD3NL8xrzFxw=;
	h=Date:To:From:Subject:From;
	b=oTTqLojvIfYnz+ssaozjappuX0KZXycrjO9f9S13LCfRsEJopd5TMrc1Z30PWczPB
	 vkuxehFQ3GX65FzstV4Y/OUMxULQffHafi/oUwUcOi0kAs7KGVeK5GwnWgPdEse5RF
	 4j08FmuwgqCrETGJW6cTpQiQu4sO4u2guYI/NiLc=
Date: Sat, 03 May 2025 17:50:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yury.norov@gmail.com,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,Jonathan.Cameron@huawei.com,gregkh@linuxfoundation.org,david@redhat.com,dave.jiang@intel.com,dakr@kernel.org,alison.schofield@intel.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + driver-base-remove-register_mem_block_under_node_early.patch added to mm-new branch
Message-Id: <20250504005055.82BF8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: driver/base: remove register_mem_block_under_node_early()
has been added to the -mm mm-new branch.  Its filename is
     driver-base-remove-register_mem_block_under_node_early.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/driver-base-remove-register_mem_block_under_node_early.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: driver/base: remove register_mem_block_under_node_early()
Date: Sat, 3 May 2025 11:10:13 +0530

The function register_mem_block_under_node_early() is no longer used, as
register_memory_blocks_under_node_early() now handles memory block
registration during early boot.

Removed register_mem_block_under_node_early() and get_nid_for_pfn(), the
latter was only used by the former.

Link: https://lkml.kernel.org/r/871e79e4583fcf5f28ecbb37f28297098f1ac748.1746250339.git.donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |   58 ------------------------------------------
 1 file changed, 1 insertion(+), 57 deletions(-)

--- a/drivers/base/node.c~driver-base-remove-register_mem_block_under_node_early
+++ a/drivers/base/node.c
@@ -748,15 +748,6 @@ int unregister_cpu_under_node(unsigned i
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-static int __ref get_nid_for_pfn(unsigned long pfn)
-{
-#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
-	if (system_state < SYSTEM_RUNNING)
-		return early_pfn_to_nid(pfn);
-#endif
-	return pfn_to_nid(pfn);
-}
-
 static void do_register_memory_block_under_node(int nid,
 						struct memory_block *mem_blk,
 						enum meminit_context context)
@@ -783,46 +774,6 @@ static void do_register_memory_block_und
 				    ret);
 }
 
-/* register memory section under specified node if it spans that node */
-static int register_mem_block_under_node_early(struct memory_block *mem_blk,
-					       void *arg)
-{
-	unsigned long memory_block_pfns = memory_block_size_bytes() / PAGE_SIZE;
-	unsigned long start_pfn = section_nr_to_pfn(mem_blk->start_section_nr);
-	unsigned long end_pfn = start_pfn + memory_block_pfns - 1;
-	int nid = *(int *)arg;
-	unsigned long pfn;
-
-	for (pfn = start_pfn; pfn <= end_pfn; pfn++) {
-		int page_nid;
-
-		/*
-		 * memory block could have several absent sections from start.
-		 * skip pfn range from absent section
-		 */
-		if (!pfn_in_present_section(pfn)) {
-			pfn = round_down(pfn + PAGES_PER_SECTION,
-					 PAGES_PER_SECTION) - 1;
-			continue;
-		}
-
-		/*
-		 * We need to check if page belongs to nid only at the boot
-		 * case because node's ranges can be interleaved.
-		 */
-		page_nid = get_nid_for_pfn(pfn);
-		if (page_nid < 0)
-			continue;
-		if (page_nid != nid)
-			continue;
-
-		do_register_memory_block_under_node(nid, mem_blk, MEMINIT_EARLY);
-		return 0;
-	}
-	/* mem section does not span the specified node */
-	return 0;
-}
-
 /*
  * During hotplug we know that all pages in the memory block belong to the same
  * node.
@@ -892,15 +843,8 @@ void register_memory_blocks_under_node(i
 				       unsigned long end_pfn,
 				       enum meminit_context context)
 {
-	walk_memory_blocks_func_t func;
-
-	if (context == MEMINIT_HOTPLUG)
-		func = register_mem_block_under_node_hotplug;
-	else
-		func = register_mem_block_under_node_early;
-
 	walk_memory_blocks(PFN_PHYS(start_pfn), PFN_PHYS(end_pfn - start_pfn),
-			   (void *)&nid, func);
+			   (void *)&nid, register_mem_block_under_node_hotplug);
 	return;
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

selftests-mm-restore-default-nr_hugepages-value-during-cleanup-in-hugetlb_reparenting_testsh.patch
driver-base-optimize-memory-block-registration-to-reduce-boot-time.patch
driver-base-remove-register_mem_block_under_node_early.patch
drivers-base-rename-register_memory_blocks_under_node-and-remove-context-argument.patch

