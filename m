Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AB328467B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126236; cv=none; b=DbcqLY3kijfp4qJd8pH5+KzOBYOWRRlNnCI3ogazkOEAZaS10k9Hek4eZXDiOuH0zc+1Nh7NGxq5ZVXQleL+4vw4+KRXa/U0JOYcw73lFbLLLZKFS1ol7esvyPvcYh2JXMd9qedFfdJv28XgSZFX1I+BQmDMUMzpjW2CCj+AM4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126236; c=relaxed/simple;
	bh=F6lbhab4KvikPNQG98lIbe4Dnu/1gFUigftAp72/i+o=;
	h=Date:To:From:Subject:Message-Id; b=gt6kTQc6idTJTpUoe8E16ZQradTjWOJ4TaXWW8vSx8wABzZhAQeAhsDf+0PeZzo9IXwaSBwt6gkSTIdPg7TsGfODCdBeyLndNyN0nYDnEX0lFsznSydj1cqzE4Jp1iuDxbSrSDteK0ywSRvqIN4nVSBM8l5uSHLIQwtt4Bb1aJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JG2XGf30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JG2XGf30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BD9C4CEE3;
	Thu, 10 Jul 2025 05:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126236;
	bh=F6lbhab4KvikPNQG98lIbe4Dnu/1gFUigftAp72/i+o=;
	h=Date:To:From:Subject:From;
	b=JG2XGf30fyDb+Qv+9VfbF61csAw6PWbo+h2i0N5T6dnfb9vHDx1EpfsdICpZ4Cp6e
	 30FoJhxzNPzdYbCWuV1hr52Fjv2n5hMNiEUTFNzgzGsdayDNdcUbpBPAozKnVfVZMN
	 v3OuE7tq9RBde5fdOaNNDgtqioJocmL5OQklqNys=
Date: Wed, 09 Jul 2025 22:43:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,osalvador@suse.de,david@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-base-node-rename-register_memory_blocks_under_node-and-remove-context-argument.patch removed from -mm tree
Message-Id: <20250710054356.53BD9C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/node: rename register_memory_blocks_under_node() and remove context argument
has been removed from the -mm tree.  Its filename was
     drivers-base-node-rename-register_memory_blocks_under_node-and-remove-context-argument.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -839,9 +839,8 @@ static void register_memory_blocks_under
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


