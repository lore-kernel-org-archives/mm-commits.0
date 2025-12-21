Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDF7219E8C
	for <mm-commits@vger.kernel.org>; Sun, 21 Dec 2025 18:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766341603; cv=none; b=pKkDjFAFgg0btClZt2qzreYDpJQGbW4EbLAnmPrC0DACwvhyCDwPiJYrdyBKFqwnkp3Olajr+mydJZ8VcSgF6yIqxKjoWb8whbSnCQU2q+Mizc0ueK6O2ESmBJu3k9YBe2CX4O8IOdPTYJP6+hbfP2sYXJp7gKmtoQMV3EZx4xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766341603; c=relaxed/simple;
	bh=BQpPsfekIstWNVQ+0JDZs87Tb9khHmaYOVp/RVhlcek=;
	h=Date:To:From:Subject:Message-Id; b=D50z8TvZImZk40G5+JNkT57RE192XmZoac1w0L0sfniJ3qxgOBwL+x2qkcrOdQvN28CHBfgs9cb7hDnAWd7Ox7dzDGVD68jqUFPUDdNdRSpLBWvIXxuBpaOYvFZOgsfkXlv7xTUdtyhv9HxidZr7+UE2UCqkWJkuW4CelYdmQ/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A2Rc/z1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A2Rc/z1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F03C4CEFB;
	Sun, 21 Dec 2025 18:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766341602;
	bh=BQpPsfekIstWNVQ+0JDZs87Tb9khHmaYOVp/RVhlcek=;
	h=Date:To:From:Subject:From;
	b=A2Rc/z1FYekPtsPdDptUCluWohcohf+NgCzTM0mJqTCbqcZt2RqTw14P9y4XpA6VS
	 ERHwkoWapBVl0+Ob7Rm+OeGa0boIf3Q7v5X6XF+leSr8yQKWAOe3hJ6jAyFChiXGo7
	 ZLzp/mcnHfLeWvwLKcUNcBXrMQ+m/ySKpydc1P38=
Date: Sun, 21 Dec 2025 10:26:42 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rientjes@google.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david@kernel.org,corbet@lwn.net,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-implement-movable_gigantic_pages-sysctl.patch added to mm-new branch
Message-Id: <20251221182642.A9F03C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, hugetlb: implement movable_gigantic_pages sysctl
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-implement-movable_gigantic_pages-sysctl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-implement-movable_gigantic_pages-sysctl.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Gregory Price <gourry@gourry.net>
Subject: mm, hugetlb: implement movable_gigantic_pages sysctl
Date: Sun, 21 Dec 2025 07:56:03 -0500

This reintroduces a concept removed by: commit d6cb41cc44c6 ("mm, hugetlb:
remove hugepages_treat_as_movable sysctl")

This sysctl provides flexibility between ZONE_MOVABLE use cases:
1) onlining memory in ZONE_MOVABLE to maintain hotplug compatibility
2) onlining memory in ZONE_MOVABLE to make hugepage allocate reliable

When ZONE_MOVABLE is used to make huge page allocation more reliable,
disallowing gigantic pages memory in this region is pointless.  If hotplug
is not a requirement, we can loosen the restrictions to allow 1GB gigantic
pages in ZONE_MOVABLE.

Since 1GB can be difficult to migrate / has impacts on compaction /
defragmentation, we don't enable this by default.  Notably, 1GB pages can
only be migrated if another 1GB page is available - so hot-unplug will
fail if such a page cannot be found.

However, since there are scenarios where gigantic pages are migratable, we
should allow use of these on movable regions.

When not valid 1GB is available for migration, hot-unplug will retry
indefinitely (or until interrupted).  For example:

  echo 0 > node0/hugepages/..-1GB/nr_hugepages  # clear node0 1GB pages
  echo 1 > node1/hugepages/..-1GB/nr_hugepages  # reserve node1 1GB page
  ./alloc_huge_node1 &    # Allocate a 1GB page on node1
  ./node1_offline  &      # attempt to offline all node1 memory
  echo 1 > node0/hugepages/..-1GB/nr_hugepages  # reserve node0 1GB page

In this example, node1_offline will block indefinitely until the final
step, when a node0 1GB page is made available.

Note: Boot-time CMA is not possible for driver-managed hotplug memory, as
CMA requires the memory to be registered as SystemRAM at boot time. 
Additionally, 1GB huge pages are not supported by THP.

Link: https://lkml.kernel.org/r/20251221125603.2364174-1-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Suggested-by: David Rientjes <rientjes@google.com>
Link: https://lore.kernel.org/all/20180201193132.Hk7vI_xaU%25akpm@linux-foundation.org/
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/memory-hotplug.rst |   14 ++++++-
 Documentation/admin-guide/sysctl/vm.rst         |   28 ++++++++++++++
 include/linux/hugetlb.h                         |    3 +
 mm/hugetlb_sysctl.c                             |   11 +++++
 4 files changed, 53 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/memory-hotplug.rst~mm-hugetlb-implement-movable_gigantic_pages-sysctl
+++ a/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -612,8 +612,9 @@ ZONE_MOVABLE, especially when fine-tunin
   allocations and silently create a zone imbalance, usually triggered by
   inflation requests from the hypervisor.
 
-- Gigantic pages are unmovable, resulting in user space consuming a
-  lot of unmovable memory.
+- Gigantic pages are unmovable when an architecture does not support
+  huge page migration and/or the ``movable_gigantic_pages`` sysctl is false.
+  See Documentation/admin-guide/sysctl/vm.rst for more info on this sysctl.
 
 - Huge pages are unmovable when an architectures does not support huge
   page migration, resulting in a similar issue as with gigantic pages.
@@ -672,6 +673,15 @@ block might fail:
 - Concurrent activity that operates on the same physical memory area, such as
   allocating gigantic pages, can result in temporary offlining failures.
 
+- When an admin sets the ``movable_gigantic_pages`` sysctl to true, gigantic
+  pages are allowed in ZONE_MOVABLE.  This only allows migratable gigantic
+  pages to be allocated; however, if there are no eligible destination gigantic
+  pages at offline, the offlining operation will fail.
+
+  Users leveraging ``movable_gigantic_pages`` should weigh the value of
+  ZONE_MOVABLE for increasing the reliability of gigantic page allocation
+  against the potential loss of hot-unplug reliability.
+
 - Out of memory when dissolving huge pages, especially when HugeTLB Vmemmap
   Optimization (HVO) is enabled.
 
--- a/Documentation/admin-guide/sysctl/vm.rst~mm-hugetlb-implement-movable_gigantic_pages-sysctl
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -53,6 +53,7 @@ Currently, these files are in /proc/sys/
 - mmap_min_addr
 - mmap_rnd_bits
 - mmap_rnd_compat_bits
+- movable_gigantic_pages
 - nr_hugepages
 - nr_hugepages_mempolicy
 - nr_overcommit_hugepages
@@ -616,6 +617,33 @@ This value can be changed after boot usi
 /proc/sys/vm/mmap_rnd_compat_bits tunable
 
 
+movable_gigantic_pages
+======================
+
+This parameter controls whether gigantic pages may be allocated from
+ZONE_MOVABLE. If set to non-zero, gigantic pages can be allocated
+from ZONE_MOVABLE. ZONE_MOVABLE memory may be created via the kernel
+boot parameter `kernelcore` or via memory hotplug as discussed in
+Documentation/admin-guide/mm/memory-hotplug.rst.
+
+Support may depend on specific architecture.
+
+Note that using ZONE_MOVABLE gigantic pages make memory hotremove unreliable.
+
+Memory hot-remove operations will block indefinitely until the admin reserves
+sufficient gigantic pages to service migration requests associated with the
+memory offlining process.  As HugeTLB gigantic page reservation is a manual
+process (via `nodeN/hugepages/.../nr_hugepages` interfaces) this may not be
+obvious when just attempting to offline a block of memory.
+
+Additionally, as multiple gigantic pages may be reserved on a single block,
+it may appear that gigantic pages are available for migration when in reality
+they are in the process of being removed. For example if `memoryN` contains
+two gigantic pages, one reserved and one allocated, and an admin attempts to
+offline that block, this operations may hang indefinitely unless another
+reserved gigantic page is available on another block `memoryM`.
+
+
 nr_hugepages
 ============
 
--- a/include/linux/hugetlb.h~mm-hugetlb-implement-movable_gigantic_pages-sysctl
+++ a/include/linux/hugetlb.h
@@ -171,6 +171,7 @@ bool hugetlbfs_pagecache_present(struct
 
 struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
 
+extern int movable_gigantic_pages __read_mostly;
 extern int sysctl_hugetlb_shm_group __read_mostly;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
@@ -929,7 +930,7 @@ static inline bool hugepage_movable_supp
 	if (!hugepage_migration_supported(h))
 		return false;
 
-	if (hstate_is_gigantic(h))
+	if (hstate_is_gigantic(h) && !movable_gigantic_pages)
 		return false;
 	return true;
 }
--- a/mm/hugetlb_sysctl.c~mm-hugetlb-implement-movable_gigantic_pages-sysctl
+++ a/mm/hugetlb_sysctl.c
@@ -8,6 +8,8 @@
 
 #include "hugetlb_internal.h"
 
+int movable_gigantic_pages;
+
 #ifdef CONFIG_SYSCTL
 static int proc_hugetlb_doulongvec_minmax(const struct ctl_table *table, int write,
 					  void *buffer, size_t *length,
@@ -125,6 +127,15 @@ static const struct ctl_table hugetlb_ta
 		.mode		= 0644,
 		.proc_handler	= hugetlb_overcommit_handler,
 	},
+#ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
+	{
+		.procname	= "movable_gigantic_pages",
+		.data		= &movable_gigantic_pages,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
 };
 
 void __init hugetlb_sysctl_init(void)
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-hugetlb-implement-movable_gigantic_pages-sysctl.patch

