Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4B21FC9
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TFizaU0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E99C433C9;
	Mon, 11 Dec 2023 00:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256042;
	bh=kmnJspM6SkjpjTpFVsy+bvXpPGJn10SVbG2At53TFfA=;
	h=Date:To:From:Subject:From;
	b=TFizaU0e99PELQOXbJIoAFGaiHR1hEM0piirh2IHNkLL9JiVB617qZAwmzZPTa6Ly
	 EzRprN7Q2yn2fmPkBBFgf8sA14QeMxbgCsQs8SbBE8zUEVS9C7C6qz/Og/lvIz697/
	 iGzNo68K2bXX3DE7ldOtpZrIchoWNYgrw8S2WBOk=
Date: Sun, 10 Dec 2023 16:54:02 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,osalvador@suse.de,mhocko@suse.com,Jonathan.Cameron@huawei.com,jmoyer@redhat.com,fan.ni@samsung.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,aneesh.kumar@linux.ibm.com,vishal.l.verma@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-replace-an-open-coded-kmemdup-in-add_memory_resource.patch removed from -mm tree
Message-Id: <20231211005402.85E99C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: replace an open-coded kmemdup() in add_memory_resource()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-replace-an-open-coded-kmemdup-in-add_memory_resource.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: mm/memory_hotplug: replace an open-coded kmemdup() in add_memory_resource()
Date: Tue, 07 Nov 2023 00:22:41 -0700

Patch series "mm: use memmap_on_memory semantics for dax/kmem", v10.

The dax/kmem driver can potentially hot-add large amounts of memory
originating from CXL memory expanders, or NVDIMMs, or other 'device
memories'.  There is a chance there isn't enough regular system memory
available to fit the memmap for this new memory.  It's therefore
desirable, if all other conditions are met, for the kmem managed memory to
place its memmap on the newly added memory itself.

The main hurdle for accomplishing this for kmem is that memmap_on_memory
can only be done if the memory being added is equal to the size of one
memblock.  To overcome this, allow the hotplug code to split an
add_memory() request into memblock-sized chunks, and try_remove_memory()
to also expect and handle such a scenario.

Patch 1 replaces an open-coded kmemdup()

Patch 2 teaches the memory_hotplug code to allow for splitting
add_memory() and remove_memory() requests over memblock sized chunks.

Patch 3 allows the dax region drivers to request memmap_on_memory
semantics. CXL dax regions default this to 'on', all others default to
off to keep existing behavior unchanged.


This patch (of 3):

A review of the memmap_on_memory modifications to add_memory_resource()
revealed an instance of an open-coded kmemdup().  Replace it with
kmemdup().

Link: https://lkml.kernel.org/r/20231107-vv-kmem_memmap-v10-0-1253ec050ed0@intel.com
Link: https://lkml.kernel.org/r/20231107-vv-kmem_memmap-v10-1-1253ec050ed0@intel.com
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reported-by: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-replace-an-open-coded-kmemdup-in-add_memory_resource
+++ a/mm/memory_hotplug.c
@@ -1439,13 +1439,13 @@ int __ref add_memory_resource(int nid, s
 	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
 		if (mhp_supports_memmap_on_memory(size)) {
 			mhp_altmap.free = memory_block_memmap_on_memory_pages();
-			params.altmap = kmalloc(sizeof(struct vmem_altmap), GFP_KERNEL);
+			params.altmap = kmemdup(&mhp_altmap,
+						sizeof(struct vmem_altmap),
+						GFP_KERNEL);
 			if (!params.altmap) {
 				ret = -ENOMEM;
 				goto error;
 			}
-
-			memcpy(params.altmap, &mhp_altmap, sizeof(mhp_altmap));
 		}
 		/* fallback to not using altmap  */
 	}
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are


