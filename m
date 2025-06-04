Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43552144C4
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 03:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749006484; cv=none; b=ntpYlWDcxCaEZXpaoyNMS4uBLMmKoNaEhqwRx6yXv67fdqq6JgHEI+MzquJZHkm5VQ7A2nVMpR+8gNxqmdfPJNnHIl+f+j8Yr8vCJ+rInLQfPkcJwvb3c7kcT4vlccxT1zsFVv+HEVU2niKC7UPIKZPhTrCWEFcigcruF8yAQMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749006484; c=relaxed/simple;
	bh=zJBk34ToZkd2H4oN2k/EJogQAVRENf6MSqO8IWF8oqo=;
	h=Date:To:From:Subject:Message-Id; b=GnVdemyhMoIMRQFMk9s0srZGgnPkeaohfWmyf82U/zFnOGxGQruq7JRVqoulunKHiUePQyimSqclyqfDf+ekms7sAbCDAa2GLKomJVLCtlk9KdiwhvI9DPnc3ILffsO1KdqP4B2aPEYm5Yal7PlhGEdMXzMEyrWuZ6RoAj08ONI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lSO08OYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lSO08OYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35356C4CEED;
	Wed,  4 Jun 2025 03:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749006484;
	bh=zJBk34ToZkd2H4oN2k/EJogQAVRENf6MSqO8IWF8oqo=;
	h=Date:To:From:Subject:From;
	b=lSO08OYdoJ8sMzenO29dUIbA7AHQqTgd7OhX305a3KgoaIhfEkqZBQCPm/Zkjb0rE
	 FrQhXT0GoIG4O3VxLdrMJB7YWMtkxVT3m5VIQkEyeFcxFqMJetzyUsgs/T9K2I6yzp
	 Fi8Z3X9Jc5IKLoRGD0qxle+nH//3IeLg7KWdt+Ug=
Date: Tue, 03 Jun 2025 20:08:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,osalvador@suse.de,david@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-node-rename-register_memory_blocks_under_node-and-remove-context-argument.patch added to mm-new branch
Message-Id: <20250604030804.35356C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/base/node: rename register_memory_blocks_under_node() and remove context argument
has been added to the -mm mm-new branch.  Its filename is
     drivers-base-node-rename-register_memory_blocks_under_node-and-remove-context-argument.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-node-rename-register_memory_blocks_under_node-and-remove-context-argument.patch

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
Subject: drivers/base/node: rename register_memory_blocks_under_node() and remove context argument
Date: Wed, 28 May 2025 12:18:03 -0500

The function register_memory_blocks_under_node() is now only called from
the memory hotplug path, as register_memory_blocks_under_node_early()
handles registration during early boot.  Therefore, the context argument
used to differentiate between early boot and hotplug is no longer needed
and was removed.

Since the function is only called from the hotplug path, we renamed
register_memory_blocks_under_node() to
register_memory_blocks_under_node_hotplug()

Link: https://lkml.kernel.org/r/907c22292b0ee4975107876efc875c75c11badd9.1748452242.git.donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c  |    5 ++---
 include/linux/node.h |   11 +++++------
 mm/memory_hotplug.c  |    5 ++---
 3 files changed, 9 insertions(+), 12 deletions(-)

--- a/drivers/base/node.c~drivers-base-node-rename-register_memory_blocks_under_node-and-remove-context-argument
+++ a/drivers/base/node.c
@@ -860,9 +860,8 @@ static void register_memory_blocks_under
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
--- a/include/linux/node.h~drivers-base-node-rename-register_memory_blocks_under_node-and-remove-context-argument
+++ a/include/linux/node.h
@@ -111,13 +111,12 @@ struct memory_block;
 extern struct node *node_devices[];
 
 #if defined(CONFIG_MEMORY_HOTPLUG) && defined(CONFIG_NUMA)
-void register_memory_blocks_under_node(int nid, unsigned long start_pfn,
-				       unsigned long end_pfn,
-				       enum meminit_context context);
+void register_memory_blocks_under_node_hotplug(int nid, unsigned long start_pfn,
+					       unsigned long end_pfn);
 #else
-static inline void register_memory_blocks_under_node(int nid, unsigned long start_pfn,
-						     unsigned long end_pfn,
-						     enum meminit_context context)
+static inline void register_memory_blocks_under_node_hotplug(int nid,
+							     unsigned long start_pfn,
+							     unsigned long end_pfn)
 {
 }
 static inline void register_memory_blocks_under_nodes(void)
--- a/mm/memory_hotplug.c~drivers-base-node-rename-register_memory_blocks_under_node-and-remove-context-argument
+++ a/mm/memory_hotplug.c
@@ -1575,9 +1575,8 @@ int add_memory_resource(int nid, struct
 		BUG_ON(ret);
 	}
 
-	register_memory_blocks_under_node(nid, PFN_DOWN(start),
-					  PFN_UP(start + size - 1),
-					  MEMINIT_HOTPLUG);
+	register_memory_blocks_under_node_hotplug(nid, PFN_DOWN(start),
+					  PFN_UP(start + size - 1));
 
 	/* create new memmap entry */
 	if (!strcmp(res->name, "System RAM"))
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time.patch
drivers-base-node-remove-register_mem_block_under_node_early.patch
drivers-base-node-remove-register_memory_blocks_under_node-function-call-from-register_one_node.patch
drivers-base-node-rename-register_memory_blocks_under_node-and-remove-context-argument.patch
drivers-base-node-rename-__register_one_node-to-register_one_node.patch

