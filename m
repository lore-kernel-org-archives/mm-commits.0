Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FFE26738D
	for <mm-commits@vger.kernel.org>; Fri,  3 Oct 2025 23:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759534993; cv=none; b=duHCW6AAookGWdEO7pUVhGhJrvwyM2IM4zPOwI5+nVge8nntqdIYIM0sjvQhdkYyLzWosFRAlLOavwnbZ3y6Krw/wJ7BYtM0bXmyP6CtkXffytiUDtHyTkK0z8PZGG4gcLEBfVRYHM/N/Trz4swo+o/oIUUN5UPhx9AUuFcvX04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759534993; c=relaxed/simple;
	bh=hFxPHnerK73eAeNSUdAkeFF0LslCWblou3n1Nws0qqY=;
	h=Date:To:From:Subject:Message-Id; b=dYwBQqRY3GZyPM70zC1LU3civhHCUKyWuHrJJ/df8G+8AaC6jXsTG1vB+tGvianSOHmOvewrmEZM6S+yUMt5e4PqHOyt5PDQlvrnTxMooEUt5MdnRJeFg85ej9geDxKRaZYzJRqGbGeBCYjeMtZO9CrIhm+fEH1X8m1kT+N/Nis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sl6BwdGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sl6BwdGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A80C4CEF5;
	Fri,  3 Oct 2025 23:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759534992;
	bh=hFxPHnerK73eAeNSUdAkeFF0LslCWblou3n1Nws0qqY=;
	h=Date:To:From:Subject:From;
	b=sl6BwdGLXrj1OXMuQPH9xhfW7TISws6hrVkzclYGo7r6kFeLbU4WmSTDmNuusNEUG
	 qGSSl9tG+GQOjPV0ZFNc3ZEZ4R8kCEBePk6IEkxVdkivOpuQIpmokm2aK4sCt9LhzT
	 q5GnCx8pzwbyL2VkWU+7mCBUrRE6lNgqKF0t5xXg=
Date: Fri, 03 Oct 2025 16:43:11 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,donettom@linux.ibm.com,david@redhat.com,hare@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-base-memory-add-node-id-parameter-to-add_memory_block.patch removed from -mm tree
Message-Id: <20251003234312.44A80C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/memory: add node id parameter to add_memory_block()
has been removed from the -mm tree.  Its filename was
     drivers-base-memory-add-node-id-parameter-to-add_memory_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hannes Reinecke <hare@kernel.org>
Subject: drivers/base/memory: add node id parameter to add_memory_block()
Date: Tue, 29 Jul 2025 08:46:34 +0200

Patch series "mm/memory_hotplug: fixup crash during uevent handling", v4.

we have some udev rules trying to read the sysfs attribute 'valid_zones'
during an memory 'add' event, causing a crash in zone_for_pfn_range(). 
Debugging found that mem->nid was set to NUMA_NO_NODE, which crashed in
NODE_DATA(nid).  Further analysis revealed that we're running into a race
with udev event processing: add_memory_resource() has this function calls:

1) __try_online_node()
2) arch_add_memory()
3) create_memory_block_devices()
  -> calls device_register() -> memory 'add' event
4) node_set_online()/__register_one_node()
  -> calls device_register() -> node 'add' event
5) register_memory_blocks_under_node()
  -> sets mem->nid

Which, to the uninitated, is ... weird ...

Why do we try to online the node in 1), but only register the node in 4)
_after_ we have created the memory blocks in 3) ?  And why do we set the
'nid' value in 5), when the uevent (which might need to see the correct
'nid' value) is sent out in 3) ?  There must be a reason, I'm sure ...

So here's a small patchset to fixup uevent ordering.  The first patch adds
a 'nid' parameter to add_memory_blocks() (to avoid mem->nid being
initialized with NUMA_NO_NODE), and the second patch reshuffles the code
in add_memory_resource() to fully initialize the node prior to calling
create_memory_block_devices() so that the node is valid at that time and
uevent processing will see correct values in sysfs.


This patch (of 3):

We have some udev rules trying to read the sysfs attribute 'valid_zones'
during an memory 'add' event, causing a crash in zone_for_pfn_range(). 
Debugging found that mem->nid was set to NUMA_NO_NODE, which crashed in
NODE_DATA(nid).  Further analysis revealed that we're running into a race
with udev event processing: add_memory_resource() has this function calls:

1) __try_online_node()
2) arch_add_memory()
3) create_memory_block_devices()
  -> calls device_register() -> memory 'add' event
4) node_set_online()/__register_one_node()
  -> calls device_register() -> node 'add' event
5) register_memory_blocks_under_node()
  -> sets mem->nid

Which, to the uninitated, is ... weird ...

Why do we try to online the node in 1), but only register the node in 4)
_after_ we have created the memory blocks in 3) ?  And why do we set the
'nid' value in 5), when the uevent (which might need to see the correct
'nid' value) is sent out in 3) ?  There must be a reason, I'm sure ...

So here's a small patchset to fixup uevent ordering.  The first patch adds
a 'nid' parameter to add_memory_blocks() (to avoid mem->nid being
initialized with NUMA_NO_NODE), and the second patch reshuffles the code
in add_memory_resource() to fully initialize the node prior to calling
create_memory_block_devices() so that the node is valid at that time and
uevent processing will see correct values in sysfs.


This patch (of 3):

Add a 'nid' parameter to add_memory_block() to initialize the memory block
with the correct node id.

Link: https://lkml.kernel.org/r/20250729064637.51662-1-hare@kernel.org
Link: https://lkml.kernel.org/r/20250729064637.51662-2-hare@kernel.org
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-add-node-id-parameter-to-add_memory_block
+++ a/drivers/base/memory.c
@@ -809,7 +809,7 @@ void memory_block_add_nid(struct memory_
 }
 #endif
 
-static int add_memory_block(unsigned long block_id, unsigned long state,
+static int add_memory_block(unsigned long block_id, int nid, unsigned long state,
 			    struct vmem_altmap *altmap,
 			    struct memory_group *group)
 {
@@ -827,7 +827,7 @@ static int add_memory_block(unsigned lon
 
 	mem->start_section_nr = block_id * sections_per_block;
 	mem->state = state;
-	mem->nid = NUMA_NO_NODE;
+	mem->nid = nid;
 	mem->altmap = altmap;
 	INIT_LIST_HEAD(&mem->group_next);
 
@@ -854,13 +854,6 @@ static int add_memory_block(unsigned lon
 	return 0;
 }
 
-static int add_hotplug_memory_block(unsigned long block_id,
-				    struct vmem_altmap *altmap,
-				    struct memory_group *group)
-{
-	return add_memory_block(block_id, MEM_OFFLINE, altmap, group);
-}
-
 static void remove_memory_block(struct memory_block *memory)
 {
 	if (WARN_ON_ONCE(memory->dev.bus != &memory_subsys))
@@ -900,7 +893,7 @@ int create_memory_block_devices(unsigned
 		return -EINVAL;
 
 	for (block_id = start_block_id; block_id != end_block_id; block_id++) {
-		ret = add_hotplug_memory_block(block_id, altmap, group);
+		ret = add_memory_block(block_id, NUMA_NO_NODE, MEM_OFFLINE, altmap, group);
 		if (ret)
 			break;
 	}
@@ -1005,7 +998,7 @@ void __init memory_dev_init(void)
 			continue;
 
 		block_id = memory_block_id(nr);
-		ret = add_memory_block(block_id, MEM_ONLINE, NULL, NULL);
+		ret = add_memory_block(block_id, NUMA_NO_NODE, MEM_ONLINE, NULL, NULL);
 		if (ret) {
 			panic("%s() failed to add memory block: %d\n",
 			      __func__, ret);
_

Patches currently in -mm which might be from hare@kernel.org are


