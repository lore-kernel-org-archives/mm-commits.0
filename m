Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9093B05B6
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068034; cv=none; b=sXkCzLoe+5kGXzfEQblyNqm0w/9rt2gIq5IJw/ItU82d+/SbpYbkKblfBqhDb/QfA7Ft50p30xI+7/RrPl+TjW7VDd723wDrEYGk/Wxd9TT0EQ1ZN0yVBLkTXLVx5Mq8XUkJ+ECoBfoW7niJFfJngiaPxd2BWc//55pfp+UOqsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068034; c=relaxed/simple;
	bh=zEBVDMVFpagdswuVD4QZLgWJfqvJNIbnBL/AJZSn03c=;
	h=Date:To:From:Subject:Message-Id; b=CTVCGSMp0EdBguHTfRKN5aUxqM1uwn4Jq1TDSMUq6GpzVpBRaXQXX8G+nexGWaQJn1reDz7Up/f/RTIvQ3A5XXU6BMI6ua4AUSeRe6AktBaom03gaJbb7jFSknmFDgDxy23Hrcp1R1hPlTUM2cKLlUfFd5Ge6pFzL3UKTIbIOD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DFMQHCj9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DFMQHCj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A211F00ADF;
	Fri,  7 Aug 2026 02:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068028;
	bh=Az+cPugpFueOz3Ta4fGtbvGFgddg74m6OVfbedP7uVU=;
	h=Date:To:From:Subject;
	b=DFMQHCj9d5GBHrWhVeoleR0z3gwCbyFXs72ByNcgN38gEAaAmBpFBoiEF0K1KhxmG
	 FtlsKM6JpPTB9rWA2vHKQPieLXslMua7ad92KzWFk0GiSw7PJRX0RiHpOP2DIoqnlc
	 GtZxKQGteRsXfDoK/MOnfQ4hHpm/KHA1me+t/WEs=
Date: Thu, 06 Aug 2026 19:00:28 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rafael@kernel.org,pankaj.gupta@amd.com,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hare@suse.de,gregkh@linuxfoundation.org,djbw@kernel.org,david@kernel.org,dave.jiang@intel.com,dakr@kernel.org,alison.schofield@intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-add-memory_block_aligned_range-helper.patch removed from -mm tree
Message-Id: <20260807020028.A0A211F00ADF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: add memory_block_aligned_range() helper
has been removed from the -mm tree.  Its filename was
     mm-memory-add-memory_block_aligned_range-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


