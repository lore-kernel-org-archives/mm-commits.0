Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEE233E7
	for <mm-commits@vger.kernel.org>; Sun,  4 May 2025 00:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746319858; cv=none; b=ZCsjZe7nF3sx70nqHWfl/xAiJLwlx3s4bPOtckmtImhTT4Wq/TDb//fA0twf7auACqDT0g2UmpthuGNcY0DIHql9eegQXpzb+JxBm2wDYEhKQ4Hqx3uHSarKe/7+hncRJp4n6oQhft2pLQ6nFqaY9D5tyIUOn4RWvKJseRFWBQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746319858; c=relaxed/simple;
	bh=P2rAafNFit/PaIXLBcy5Uv2iNn/tQSMxNmi78WLwnQc=;
	h=Date:To:From:Subject:Message-Id; b=iXbQoRWicl8d9OzkxS4Z6+aEGGcjvkmt1nXAgHEnB/L2Azha02jcV51V89MHO4/cNlmVx1/ouSLrQ1+eKzlqPUQDt9YHkiQ3dqVoIlld2U2AMfDuxbxw1a0Fbx6i7bKSP6WM9KnPp9SfYWWS2/3uS3lHZ13p/tTmx+k18f0tDDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sRZ8KzNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sRZ8KzNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA656C4CEE3;
	Sun,  4 May 2025 00:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746319857;
	bh=P2rAafNFit/PaIXLBcy5Uv2iNn/tQSMxNmi78WLwnQc=;
	h=Date:To:From:Subject:From;
	b=sRZ8KzNTuBAy5UtUY2niatm8q+bbOt5/KYF+oojyE5GPtCpNLIrBkgKKp7H54Kvd3
	 CTSzAVou6tbPLztei9GwIQJMSnTXwZjuwHSFEEtRIjoIi9HP2EP92sVJS24Z66cqMh
	 ngpirYM1VyRXjn+3OyMDe7t9Wu039GknndbO/F14=
Date: Sat, 03 May 2025 17:50:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yury.norov@gmail.com,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,Jonathan.Cameron@huawei.com,gregkh@linuxfoundation.org,david@redhat.com,dave.jiang@intel.com,dakr@kernel.org,alison.schofield@intel.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-rename-register_memory_blocks_under_node-and-remove-context-argument.patch added to mm-new branch
Message-Id: <20250504005057.AA656C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/base : rename register_memory_blocks_under_node() and remove context argument
has been added to the -mm mm-new branch.  Its filename is
     drivers-base-rename-register_memory_blocks_under_node-and-remove-context-argument.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-rename-register_memory_blocks_under_node-and-remove-context-argument.patch

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
Subject: drivers/base : rename register_memory_blocks_under_node() and remove context argument
Date: Sat, 3 May 2025 11:10:14 +0530

The function register_memory_blocks_under_node() is now only called from
the memory hotplug path, as register_memory_blocks_under_node_early()
handles registration during early boot.  Therefore, the context argument
used to differentiate between early boot and hotplug is no longer needed
and was removed.

Since the function is only called from the hotplug path, we renamed
register_memory_blocks_under_node() to
register_memory_blocks_under_node_hotplug()

Link: https://lkml.kernel.org/r/9e9fe4715c729e54e3820de0f24c185a26679e72.1746250339.git.donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c  |    5 ++---
 include/linux/node.h |   11 +++++------
 mm/memory_hotplug.c  |    5 ++---
 3 files changed, 9 insertions(+), 12 deletions(-)

--- a/drivers/base/node.c~drivers-base-rename-register_memory_blocks_under_node-and-remove-context-argument
+++ a/drivers/base/node.c
@@ -839,9 +839,8 @@ void register_memory_blocks_under_node_e
 	}
 }
 
-void register_memory_blocks_under_node(int nid, unsigned long start_pfn,
-				       unsigned long end_pfn,
-				       enum meminit_context context)
+void register_memory_blocks_under_node_hotplug(int nid, unsigned long start_pfn,
+					       unsigned long end_pfn)
 {
 	walk_memory_blocks(PFN_PHYS(start_pfn), PFN_PHYS(end_pfn - start_pfn),
 			   (void *)&nid, register_mem_block_under_node_hotplug);
--- a/include/linux/node.h~drivers-base-rename-register_memory_blocks_under_node-and-remove-context-argument
+++ a/include/linux/node.h
@@ -111,14 +111,13 @@ struct memory_block;
 extern struct node *node_devices[];
 
 #if defined(CONFIG_MEMORY_HOTPLUG) && defined(CONFIG_NUMA)
-void register_memory_blocks_under_node(int nid, unsigned long start_pfn,
-				       unsigned long end_pfn,
-				       enum meminit_context context);
+void register_memory_blocks_under_node_hotplug(int nid, unsigned long start_pfn,
+					       unsigned long end_pfn);
 void register_memory_blocks_under_node_early(int nid);
 #else
-static inline void register_memory_blocks_under_node(int nid, unsigned long start_pfn,
-						     unsigned long end_pfn,
-						     enum meminit_context context)
+static inline void register_memory_blocks_under_node_hotplug(int nid,
+							     unsigned long start_pfn,
+							     unsigned long end_pfn)
 {
 }
 static inline void register_memory_blocks_under_node_early(int nid)
--- a/mm/memory_hotplug.c~drivers-base-rename-register_memory_blocks_under_node-and-remove-context-argument
+++ a/mm/memory_hotplug.c
@@ -1575,9 +1575,8 @@ int add_memory_resource(int nid, struct
 		BUG_ON(ret);
 	}
 
-	register_memory_blocks_under_node(nid, PFN_DOWN(start),
-					  PFN_UP(start + size - 1),
-					  MEMINIT_HOTPLUG);
+	register_memory_blocks_under_node_hotplug(nid, PFN_DOWN(start),
+						  PFN_UP(start + size - 1));
 
 	/* create new memmap entry */
 	if (!strcmp(res->name, "System RAM"))
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

selftests-mm-restore-default-nr_hugepages-value-during-cleanup-in-hugetlb_reparenting_testsh.patch
driver-base-optimize-memory-block-registration-to-reduce-boot-time.patch
driver-base-remove-register_mem_block_under_node_early.patch
drivers-base-rename-register_memory_blocks_under_node-and-remove-context-argument.patch

