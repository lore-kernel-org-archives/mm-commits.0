Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BAF13A3F7
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 01:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783993154; cv=none; b=XjFWjQ4bRyucUgM0d17PoT1h7+2Zpbgb7TfzzoAhx/yN2ONjs09mc+Hlhh9vFwo0sxAAzGyOG8bIl9pMo5/jXiae6yfkcvNwj1A+mNWR/asO7bmIUk41PPKrEOUWYqh1Qo3Io0VfFho3OSVcxWoS59Wr5sDv6mJTTvjc53EyVsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783993154; c=relaxed/simple;
	bh=smkX9WXkvO1IGxp8GKNxENHCikJ+p8r4gILX5FF4dqs=;
	h=Date:To:From:Subject:Message-Id; b=nYZziVUqTtI7VDZrvsQ5NYxGtS0Jl8LV9tn+W80+DG2Py3R6bD4s+UpV+IamnpizMdN+AUtWOwW7FzEnTHJLi1s1dZq/BpxrAOshwT1VpvfcN5RtkueW4a3HqLQm4aOP6mv5De9eFOgtYOnwAd4KrDL0yvjcessPg71xMIm/4a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kIPlBFb0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kIPlBFb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA281F000E9;
	Tue, 14 Jul 2026 01:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783993152;
	bh=FJ2s1ntTqv7ttq8WipMqpiQD13HIG6epPUuztZykRG0=;
	h=Date:To:From:Subject;
	b=kIPlBFb0/intMa1UOyNPA6t1ism8U8x4xF8f1FGmiWq52XUWZ+wiOzFC9tulr9IWV
	 eMBfhAt+g32w/m0Hd8R1zxrkBOcA5GfvayYqYlSPaiwluoJLzWlbO0x/y0NC5xdak6
	 tyOZKHuNp1sxVWf2GF3sl+1rHaevjStmzazSxN2E=
Date: Mon, 13 Jul 2026 18:39:12 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rafael@kernel.org,pankaj.gupta@amd.com,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hare@suse.de,gregkh@linuxfoundation.org,djbw@kernel.org,david@kernel.org,dave.jiang@intel.com,dakr@kernel.org,alison.schofield@intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-add-memory_block_aligned_range-helper.patch added to mm-new branch
Message-Id: <20260714013912.7CA281F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: add memory_block_aligned_range() helper
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-add-memory_block_aligned_range-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-add-memory_block_aligned_range-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: mm/memory: add memory_block_aligned_range() helper
Date: Sun, 12 Jul 2026 11:44:55 -0400

Patch series "dax/kmem: atomic whole-device hotplug via sysfs", v7.

The dax kmem driver onlines memory during probe using the system default
policy, with no atomic control for the state of an entire region at
runtime - only by toggling individual memory blocks.

Offlining and removing a whole region therefore races with other userland
controllers that interfere between the two steps.

This series adds a sysfs "state" attribute for atomic whole-device hotplug
control, plus the mm and dax plumbing to support it.

Transitions are atomic across every range of the device.  The state names
mirror the per-block memoryX/state ABI with one modification:

  - "unplugged":      memory blocks are not present
  - "online":         online as system RAM, zone chosen by the kernel
  - "online_kernel":  online in ZONE_NORMAL
  - "online_movable": online in ZONE_MOVABLE

"offline" (blocks present but offline) is reportable for backward
compatibility but is not writable because it entices the race condition we
are trying to solve (separate atomic steps for offline and unplug).

'unplugged' (atomic offline+remove of the whole device) is the new
capability provided by the new kmem sysfs attribute.

dax/kmem probe still creates the memory blocks by default when the default
policy is "offline", to preserve backwards compatibility.


This patch (of 10):

Memory hotplug operations require ranges aligned to memory block
boundaries.  This is a generic operation for hotplug.

Add memory_block_aligned_range() as a common helper in <linux/memory.h>
that aligns the start address up and end address down to memory block
boundaries.  Guard against end underflow when the range falls below the
first memory block boundary, returning an empty range instead.

Update dax/kmem to use this helper.

Link: https://lore.kernel.org/20260712154505.3564379-1-gourry@gourry.net
Link: https://lore.kernel.org/20260712154505.3564379-2-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <djbw@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/kmem.c     |    4 +---
 include/linux/memory.h |   27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 3 deletions(-)

--- a/drivers/dax/kmem.c~mm-memory-add-memory_block_aligned_range-helper
+++ a/drivers/dax/kmem.c
@@ -33,9 +33,7 @@ static int dax_kmem_range(struct dev_dax
 	struct dev_dax_range *dax_range = &dev_dax->ranges[i];
 	struct range *range = &dax_range->range;
 
-	/* memory-block align the hotplug range */
-	r->start = ALIGN(range->start, memory_block_size_bytes());
-	r->end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) - 1;
+	*r = memory_block_aligned_range(range);
 	if (r->start >= r->end) {
 		r->start = range->start;
 		r->end = range->end;
--- a/include/linux/memory.h~mm-memory-add-memory_block_aligned_range-helper
+++ a/include/linux/memory.h
@@ -20,6 +20,7 @@
 #include <linux/compiler.h>
 #include <linux/mutex.h>
 #include <linux/memory_hotplug.h>
+#include <linux/range.h>
 
 #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
@@ -100,6 +101,32 @@ int arch_get_memory_phys_device(unsigned
 unsigned long memory_block_size_bytes(void);
 int set_memory_block_size_order(unsigned int order);
 
+/**
+ * memory_block_aligned_range - align a physical address range to memory blocks
+ * @range: the input range to align
+ *
+ * Aligns the start address up and the end address down to memory block
+ * boundaries. This is required for memory hotplug operations which must
+ * operate on memory-block aligned ranges.
+ *
+ * Returns the aligned range. Callers should check that the returned
+ * range is valid (aligned.start < aligned.end) before using it.
+ */
+static inline struct range memory_block_aligned_range(const struct range *range)
+{
+	struct range aligned;
+
+	aligned.start = ALIGN(range->start, memory_block_size_bytes());
+	aligned.end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes());
+	/* No whole block fits (e.g. range below the first boundary): empty. */
+	if (aligned.end <= aligned.start)
+		aligned.start = aligned.end;
+	else
+		aligned.end -= 1;
+
+	return aligned;
+}
+
 struct memory_notify {
 	unsigned long start_pfn;
 	unsigned long nr_pages;
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-vmstat-fold-stranded-per-cpu-node-stats-when-a-node-comes-online.patch
mm-constify-oom_control-scan_control-and-alloc_context-nodemask.patch
mm-mm_init-handle-alloc_percpu-failure-in-free_area_init_core_hotplug.patch
mm-memory-add-memory_block_aligned_range-helper.patch
mm-memory_hotplug-add-mhp_online_type_to_str-and-export-string-helpers.patch
mm-memory_hotplug-pass-online_type-to-online_memory_block-via-arg.patch
mm-memory_hotplug-export-mhp_get_default_online_type.patch
mm-memory_hotplug-add-__add_memory_driver_managed-with-online_type-arg.patch
mm-memory_hotplug-add-offline_and_remove_memory_ranges.patch
dax-kmem-resolve-default-online-type-at-probe-time.patch
dax-kmem-extract-hotplug-hotremove-helper-functions.patch
dax-kmem-add-sysfs-interface-for-atomic-whole-device-hotplug.patch
selftests-dax-add-dax-kmem-hotplug-sysfs-regression-test.patch

