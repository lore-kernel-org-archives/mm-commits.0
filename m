Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9C023958D
	for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2025 20:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753821454; cv=none; b=iAiAw4lU0n81DCCHfhaJbfqrl/+mX12U00P4/JbcRMZH3759kjlqEAdQmCNjBmIn1w2v0d5SNUR5e2LgxI1WDgQQGZrPj4WbA/5NH1X+rP8EbQjTldirQz7hnxC+59TeibCkGtvEpz77/eSLbBTwA9nW9hkfm/QWu7WXuU1R/wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753821454; c=relaxed/simple;
	bh=sB5sTpSyQD3D0TJ9lwqtz0+N+gU35LhVOL4KUYCrl9E=;
	h=Date:To:From:Subject:Message-Id; b=l7XE6qipw0j13WaW9/eiWO0fsccnwOnw4UzMIyu4HzQZ8nfshkHk5KYU2B9YZ3rda904AxYBq+4OzXFOqDTC7DPEg3lTDM/CH3ScKgj7nncLmmVVwxW4oLaJpYIFAywMj7emhCoD4pDundn7+Gt62I7GiVEbKKc+ShVGh9fhteM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z4EYdc7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z4EYdc7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A96C4CEEF;
	Tue, 29 Jul 2025 20:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753821453;
	bh=sB5sTpSyQD3D0TJ9lwqtz0+N+gU35LhVOL4KUYCrl9E=;
	h=Date:To:From:Subject:From;
	b=z4EYdc7svQBXBLz6aQrU9ilMSIDWTgodJRZ/Z/Q3+Qs9hmsB6/osDbI7D6JJ7p9Ue
	 bKwqujHG/jbPHYYWxs2J+MEqxMlSbWS9mqF0ue3X68r3wDRoI30l1Y2YFhhFBTKFFD
	 iazC6fvepGfejyoEJG5MlMOjcTx0QtQH1XhmZGVM=
Date: Tue, 29 Jul 2025 13:37:33 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,donettom@linux.ibm.com,david@redhat.com,hare@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-memory-add-node-id-parameter-to-add_memory_block.patch added to mm-new branch
Message-Id: <20250729203733.D3A96C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/base/memory: add node id parameter to add_memory_block()
has been added to the -mm mm-new branch.  Its filename is
     drivers-base-memory-add-node-id-parameter-to-add_memory_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-memory-add-node-id-parameter-to-add_memory_block.patch

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
From: Hannes Reinecke <hare@kernel.org>
Subject: drivers/base/memory: add node id parameter to add_memory_block()
Date: Tue, 29 Jul 2025 08:46:34 +0200

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

drivers-base-memory-add-node-id-parameter-to-add_memory_block.patch
mm-memory_hotplug-activate-node-before-adding-new-memory-blocks.patch
drivers-base-move-memory_block_add_nid-into-the-caller.patch

