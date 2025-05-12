Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1107D14830F
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011004; cv=none; b=oL73WedhQNj2eaWUyW5U3FcymnYUgvTawTm+rhogvKZyJO4wIRuqRWkh+37NJb707Kt56BJllZiLWisdTt382BxKV3+I4H5gKbVph/KRJZVsCA0nkerqAoTLlsnv8caMcWfr0LrDYovZVDy4lor9lnW7Y+On8WpejsKH63rmTK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011004; c=relaxed/simple;
	bh=ISaacLqhS3Vvw/zy7khrGjTm8HSJ7TrJ1DYhgegVlpU=;
	h=Date:To:From:Subject:Message-Id; b=VKS2lOyP1z4X5uDMPEUL5IZQfrl9SLYimDu8tW+EcL7Vu2dOwXbIRB9Bzq0H4NeRhOIfa3msG0rIuk0sbwkEi8u5eBKvPvg2R2JwO3kldt2bG72whQxvXaHbSemt7GzgjfvSVOXp7mPPuZtzJvmZ9e1ZfrbkT7TNObshxruKsJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cavUL5Td; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cavUL5Td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CD5C4CEE4;
	Mon, 12 May 2025 00:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011003;
	bh=ISaacLqhS3Vvw/zy7khrGjTm8HSJ7TrJ1DYhgegVlpU=;
	h=Date:To:From:Subject:From;
	b=cavUL5TdYu57tvjknDXmIzGVQWpJ0rCv6GarW7o+n8meLk07KD7h6F098IL+W1XLe
	 c6NUJWO8MK/WvkS+DdQSDs6D6ykoVQAoGP3oAlnXxgiYk4JyvRnYTtXjhwtiPE1Osm
	 XqxXFyI49cow1udULix9DHOSqJCmYr8ibn1VJZdw=
Date: Sun, 11 May 2025 17:50:03 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rrichter@amd.com,rppt@kernel.org,rafael.j.wysocki@intel.com,peterz@infradead.org,osalvador@suse.de,mingo@redhat.com,luto@kernel.org,lenb@kernel.org,Jonathan.Cameron@huawei.com,ira.weiny@intel.com,hpa@zytor.com,haibo1.xu@intel.com,gregkh@linuxfoundation.org,fan.ni@samsung.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,bp@alien8.de,bfaccini@nvidia.com,alison.schofield@intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-implement-memory_block_advise-probe_max_size.patch removed from -mm tree
Message-Id: <20250512005003.D8CD5C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memory: implement memory_block_advise/probe_max_size
has been removed from the -mm tree.  Its filename was
     memory-implement-memory_block_advise-probe_max_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: memory: implement memory_block_advise/probe_max_size
Date: Mon, 27 Jan 2025 10:34:03 -0500

Patch series "memory,x86,acpi: hotplug memory alignment advisement", v8.

When physical address regions are not aligned to memory block size, the
misaligned portion is lost (stranded capacity).

Block size (min/max/selected) is architecture defined.  Most architectures
tend to use the minimum block size or some simplistic heurist.  On x86,
memory block size increases up to 2GB, and is otherwise fitted to the
alignment of non-hotplug (i.e.  not special purpose memory).

CXL exposes its memory for management through the ACPI CEDT (CXL Early
Detection Table) in a field called the CXL Fixed Memory Window.  Per the
CXL specification, this memory must be aligned to at least 256MB.

When a CFMW aligns on a size less than the block size, this causes a loss
of up to 2GB per CFMW on x86.  It is not uncommon for CFMW to be allocated
per-device - though this behavior is BIOS defined.

This patch set provides 3 things:
 1) implement advise/query functions in driverse/base/memory.c to
    report/query architecture agnostic hotplug block alignment advice.
 2) update x86 memblock size logic to consider the hotplug advice
 3) add code in acpi/numa/srat.c to report CFMW alignment advice

The advisement interfaces are design to be called during arch_init code
prior to allocator and smp_init.  start_kernel will call these through
setup_arch() (via acpi and mm/init_64.c on x86), which occurs prior to
mm_core_init and smp_init - so no need for atomics.

There's an attempt to signal callers to advise() that query has already
occurred, but this is predicated on the notion that query actually occurs
(which presently only happens on the x86 arch).  This is to assist
debugging future users.  Otherwise, the advise() call has been marked
__init to help static discovery of bad call times.

Once query is called the first time, it will always return the same value.

Interfaces return -EBUSY and 0 respectively on systems without hotplug.


This patch (of 3):

Hotplug memory sources may have opinions on what the memblock size should
be - usually for alignment purposes.  For example, CXL memory extents can
be 256MB with a matching alignment.  If this size/alignment is smaller
than the block size, it can result in stranded capacity.

Implement memory_block_advise_max_size for use prior to allocator init,
for software to advise the system on the max block size.

Implement memory_block_probe_max_size for use by arch init code to
calculate the best block size.  Use of advice is architecture defined.

The probe value can never change after first probe.  Calls to advise after
probe will return -EBUSY to aid debugging.

On systems without hotplug, always return -ENODEV and 0 respectively.

Link: https://lkml.kernel.org/r/20250127153405.3379117-1-gourry@gourry.net
Link: https://lkml.kernel.org/r/20250127153405.3379117-2-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Bruno Faccini <bfaccini@nvidia.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haibo Xu <haibo1.xu@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Robert Richter <rrichter@amd.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |   51 +++++++++++++++++++++++++++++++++++++++
 include/linux/memory.h |   10 +++++++
 2 files changed, 61 insertions(+)

--- a/drivers/base/memory.c~memory-implement-memory_block_advise-probe_max_size
+++ a/drivers/base/memory.c
@@ -110,6 +110,57 @@ static void memory_block_release(struct
 	kfree(mem);
 }
 
+
+/* Max block size to be set by memory_block_advise_max_size */
+static unsigned long memory_block_advised_size;
+static bool memory_block_advised_size_queried;
+
+/**
+ * memory_block_advise_max_size() - advise memory hotplug on the max suggested
+ *				    block size, usually for alignment.
+ * @size: suggestion for maximum block size. must be aligned on power of 2.
+ *
+ * Early boot software (pre-allocator init) may advise archs on the max block
+ * size. This value can only decrease after initialization, as the intent is
+ * to identify the largest supported alignment for all sources.
+ *
+ * Use of this value is arch-defined, as is min/max block size.
+ *
+ * Return: 0 on success
+ *	   -EINVAL if size is 0 or not pow2 aligned
+ *	   -EBUSY if value has already been probed
+ */
+int __init memory_block_advise_max_size(unsigned long size)
+{
+	if (!size || !is_power_of_2(size))
+		return -EINVAL;
+
+	if (memory_block_advised_size_queried)
+		return -EBUSY;
+
+	if (memory_block_advised_size)
+		memory_block_advised_size = min(memory_block_advised_size, size);
+	else
+		memory_block_advised_size = size;
+
+	return 0;
+}
+
+/**
+ * memory_block_advised_max_size() - query advised max hotplug block size.
+ *
+ * After the first call, the value can never change. Callers looking for the
+ * actual block size should use memory_block_size_bytes. This interface is
+ * intended for use by arch-init when initializing the hotplug block size.
+ *
+ * Return: advised size in bytes, or 0 if never set.
+ */
+unsigned long memory_block_advised_max_size(void)
+{
+	memory_block_advised_size_queried = true;
+	return memory_block_advised_size;
+}
+
 unsigned long __weak memory_block_size_bytes(void)
 {
 	return MIN_MEMORY_BLOCK_SIZE;
--- a/include/linux/memory.h~memory-implement-memory_block_advise-probe_max_size
+++ a/include/linux/memory.h
@@ -149,6 +149,14 @@ static inline int hotplug_memory_notifie
 {
 	return 0;
 }
+static inline int memory_block_advise_max_size(unsigned long size)
+{
+	return -ENODEV;
+}
+static inline unsigned long memory_block_advised_max_size(void)
+{
+	return 0;
+}
 #else /* CONFIG_MEMORY_HOTPLUG */
 extern int register_memory_notifier(struct notifier_block *nb);
 extern void unregister_memory_notifier(struct notifier_block *nb);
@@ -181,6 +189,8 @@ int walk_dynamic_memory_groups(int nid,
 void memory_block_add_nid(struct memory_block *mem, int nid,
 			  enum meminit_context context);
 #endif /* CONFIG_NUMA */
+int memory_block_advise_max_size(unsigned long size);
+unsigned long memory_block_advised_max_size(void);
 #endif	/* CONFIG_MEMORY_HOTPLUG */
 
 /*
_

Patches currently in -mm which might be from gourry@gourry.net are

cpuset-rename-cpuset_node_allowed-to-cpuset_current_node_allowed.patch
vmscancgroup-apply-mems_effective-to-reclaim.patch
dax-warn-when-kmem-regions-are-truncated-for-memory-block-alignment.patch

