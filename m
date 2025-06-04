Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E582BA42
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 03:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749006487; cv=none; b=apVky2DijacibTQ+oaERAZAwEWX5JckVkbzImo5V2G5n42+6r+ttN5X4MBKZ4yanQlbqjKj1S41PCpZF4DVX71n0xcUttHDJFiGguOaprdH044rQzqMX5pRvYYFzNqbJSsKz/6NJUdZ+c75PjbS0BwG3EFuNrtnU7GYcaumenaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749006487; c=relaxed/simple;
	bh=9SlArgWFw+/IkuFNEo912FHrkFvQZRrCqmLRzUOrGpw=;
	h=Date:To:From:Subject:Message-Id; b=l0OVCHE9RZQkbzD+Vmv9wRXtnaugQgsiWUwCBSGy4YNEbLSsXpHcD3FNRkFkyNExOZfpMcCMw+UFd091bOgPh2TFZjbnSLMXjrGTyNIooypLsNORKSQfAtRw0Zhshko+tkKpFNqOS0lMQKfCI5stCZnIjhcSidO7DQa24Q7j1ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zn4yyAU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zn4yyAU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06219C4CEED;
	Wed,  4 Jun 2025 03:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749006487;
	bh=9SlArgWFw+/IkuFNEo912FHrkFvQZRrCqmLRzUOrGpw=;
	h=Date:To:From:Subject:From;
	b=zn4yyAU2/SF6QGMyvqAJaHTbvOvT34h9F/cLr0F+ndW19R8xmy8jY2g4Qx7zPq7tl
	 iurSndwXCsi9iFY7XLnUOeVp495+MalmSIr0QTTk37BmKoo6MftC2TBsgQFEmTEYeN
	 py4g1dwOW0okqGYCw5RT5xF84E7oE1SSNTcJEirY=
Date: Tue, 03 Jun 2025 20:08:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,osalvador@suse.de,david@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-node-rename-__register_one_node-to-register_one_node.patch added to mm-new branch
Message-Id: <20250604030807.06219C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/base/node: rename __register_one_node() to register_one_node()
has been added to the -mm mm-new branch.  Its filename is
     drivers-base-node-rename-__register_one_node-to-register_one_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-node-rename-__register_one_node-to-register_one_node.patch

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
Subject: drivers/base/node: rename __register_one_node() to register_one_node()
Date: Wed, 28 May 2025 12:18:04 -0500

The register_one_node() function was a simple wrapper around
__register_one_node().  To simplify the code, register_one_node() has been
removed, and __register_one_node() has been renamed to
register_one_node().

Link: https://lkml.kernel.org/r/8262cd0f44eeb048a1fcd3ac8382760d7f7dea60.1748452242.git.donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/pci_dlpar.c |    2 +-
 drivers/base/node.c                        |    4 ++--
 include/linux/node.h                       |   13 +------------
 mm/memory_hotplug.c                        |    2 +-
 4 files changed, 5 insertions(+), 16 deletions(-)

--- a/arch/powerpc/platforms/pseries/pci_dlpar.c~drivers-base-node-rename-__register_one_node-to-register_one_node
+++ a/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -29,7 +29,7 @@ struct pci_controller *init_phb_dynamic(
 	nid = of_node_to_nid(dn);
 	if (likely((nid) >= 0)) {
 		if (!node_online(nid)) {
-			if (__register_one_node(nid)) {
+			if (register_one_node(nid)) {
 				pr_err("PCI: Failed to register node %d\n", nid);
 			} else {
 				update_numa_distance(dn);
--- a/drivers/base/node.c~drivers-base-node-rename-__register_one_node-to-register_one_node
+++ a/drivers/base/node.c
@@ -869,7 +869,7 @@ void register_memory_blocks_under_node_h
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-int __register_one_node(int nid)
+int register_one_node(int nid)
 {
 	int error;
 	int cpu;
@@ -976,7 +976,7 @@ void __init node_dev_init(void)
 	 * to already created cpu devices.
 	 */
 	for_each_online_node(i) {
-		ret =  __register_one_node(i);
+		ret =  register_one_node(i);
 		if (ret)
 			panic("%s() failed to add node: %d\n", __func__, ret);
 	}
--- a/include/linux/node.h~drivers-base-node-rename-__register_one_node-to-register_one_node
+++ a/include/linux/node.h
@@ -128,14 +128,7 @@ extern void unregister_node(struct node
 #ifdef CONFIG_NUMA
 extern void node_dev_init(void);
 /* Core of the node registration - only memory hotplug should use this */
-extern int __register_one_node(int nid);
-
-/* Registers an online node */
-static inline int register_one_node(int nid)
-{
-	return __register_one_node(nid);
-}
-
+extern int register_one_node(int nid);
 extern void unregister_one_node(int nid);
 extern int register_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid);
@@ -148,10 +141,6 @@ extern int register_memory_node_under_co
 static inline void node_dev_init(void)
 {
 }
-static inline int __register_one_node(int nid)
-{
-	return 0;
-}
 static inline int register_one_node(int nid)
 {
 	return 0;
--- a/mm/memory_hotplug.c~drivers-base-node-rename-__register_one_node-to-register_one_node
+++ a/mm/memory_hotplug.c
@@ -1571,7 +1571,7 @@ int add_memory_resource(int nid, struct
 		 * We online node here. We can't roll back from here.
 		 */
 		node_set_online(nid);
-		ret = __register_one_node(nid);
+		ret = register_one_node(nid);
 		BUG_ON(ret);
 	}
 
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time.patch
drivers-base-node-remove-register_mem_block_under_node_early.patch
drivers-base-node-remove-register_memory_blocks_under_node-function-call-from-register_one_node.patch
drivers-base-node-rename-register_memory_blocks_under_node-and-remove-context-argument.patch
drivers-base-node-rename-__register_one_node-to-register_one_node.patch

