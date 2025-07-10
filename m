Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C152284B2E
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126237; cv=none; b=Ierjl4F049x7Y8jSDxoY2bGXDyEwCW2b70xPCC7z849H0S/RTm1olaRdhM6bu7Sy6c7D4BNE60HbbpEI+NkXoWS2W1V5/lw+cmphF0w5CoGVPZD6FDW6junLdTYftayu2l/vN2vuiqczFMC0hBuhEvPaviz5cKUsXNSRle3T7gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126237; c=relaxed/simple;
	bh=k2Ks5zAP/m2scG6YmXcXodWy9M9pua6SVV5NuJ23fhw=;
	h=Date:To:From:Subject:Message-Id; b=rUxGdxRCos3Lez+U8e3Oj1pyn1/Y9huevGy4XQ07Hmd9SkNhPyhDM4eZMeWZpToVDhzmGURyfAY9khp0Mzo2XNJNX0xS8MQ07uPfWW4wt+CWUHBcvsSVH+gqRS/bLXtqll19W/d2CSkNvtzZScDDpDZeIkFLdxcG6VY1MuFKsNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C2voQvge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C2voQvge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F63CC4CEE3;
	Thu, 10 Jul 2025 05:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126237;
	bh=k2Ks5zAP/m2scG6YmXcXodWy9M9pua6SVV5NuJ23fhw=;
	h=Date:To:From:Subject:From;
	b=C2voQvgevFzyRmRrorsXkIO/1UwJpiPZ7ImJUGKPUoCGW65jfdY+wqM4Qf9Fud8R9
	 fUon9susmW/7kxeTcm79oX37yyOuHYsC5WeQPxl9elqYDdprGjj2Mkg5aq8IJ4khWY
	 TOHiqzVrEcXAv9yojFNf20mrdR3MlnzxtYD77t8c=
Date: Wed, 09 Jul 2025 22:43:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,osalvador@suse.de,david@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-base-node-rename-__register_one_node-to-register_one_node.patch removed from -mm tree
Message-Id: <20250710054357.6F63CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/node: rename __register_one_node() to register_one_node()
has been removed from the -mm tree.  Its filename was
     drivers-base-node-rename-__register_one_node-to-register_one_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -848,7 +848,7 @@ void register_memory_blocks_under_node_h
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-int __register_one_node(int nid)
+int register_one_node(int nid)
 {
 	int error;
 	int cpu;
@@ -955,7 +955,7 @@ void __init node_dev_init(void)
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


