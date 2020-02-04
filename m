From: akpm@linux-foundation.org
Subject: [merged]
 fs-proc-pagec-allow-inspection-of-last-section-and-fix-end-detection.patch
 removed from -mm tree
Date: Tue, 04 Feb 2020 10:39:57 -0800
Message-ID: <20200204183957.HACBGBZua%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbgBDSj6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:39:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, bob.picco@oracle.com, dan.j.williams@intel.com, daniel.m.jordan@oracle.com, david@redhat.com, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, osalvador@suse.de, pasha.tatashin@oracle.com, sfr@canb.auug.org.au, steven.sistare@oracle.com


The patch titled
     Subject: fs/proc/page.c: allow inspection of last section and fix end detection
has been removed from the -mm tree.  Its filename was
     fs-proc-pagec-allow-inspection-of-last-section-and-fix-end-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/page.c: allow inspection of last section and fix end detection

If max_pfn does not fall onto a section boundary, it is possible to
inspect PFNs up to max_pfn, and PFNs above max_pfn, however, max_pfn
itself can't be inspected.  We can have a valid (and online) memmap at and
above max_pfn if max_pfn is not aligned to a section boundary.  The whole
early section has a memmap and is marked online.  Being able to inspect
the state of these PFNs is valuable for debugging, especially because
max_pfn can change on memory hotplug and expose these memmaps.

Also, querying page flags via "./page-types -r -a 0x144001,"
(tools/vm/page-types.c) inside a x86-64 guest with 4160MB under QEMU
results in an (almost) endless loop in user space, because the end is not
detected properly when starting after max_pfn.

Instead, let's allow to inspect all pages in the highest section and
return 0 directly if we try to access pages above that section.

While at it, check the count before adjusting it, to avoid masking user
errors.

Link: http://lkml.kernel.org/r/20191211163201.17179-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Bob Picco <bob.picco@oracle.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Steven Sistare <steven.sistare@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- a/fs/proc/page.c~fs-proc-pagec-allow-inspection-of-last-section-and-fix-end-detection
+++ a/fs/proc/page.c
@@ -21,6 +21,21 @@
 #define KPMMASK (KPMSIZE - 1)
 #define KPMBITS (KPMSIZE * BITS_PER_BYTE)
 
+static inline unsigned long get_max_dump_pfn(void)
+{
+#ifdef CONFIG_SPARSEMEM
+	/*
+	 * The memmap of early sections is completely populated and marked
+	 * online even if max_pfn does not fall on a section boundary -
+	 * pfn_to_online_page() will succeed on all pages. Allow inspecting
+	 * these memmaps.
+	 */
+	return round_up(max_pfn, PAGES_PER_SECTION);
+#else
+	return max_pfn;
+#endif
+}
+
 /* /proc/kpagecount - an array exposing page counts
  *
  * Each entry is a u64 representing the corresponding
@@ -29,6 +44,7 @@
 static ssize_t kpagecount_read(struct file *file, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
+	const unsigned long max_dump_pfn = get_max_dump_pfn();
 	u64 __user *out = (u64 __user *)buf;
 	struct page *ppage;
 	unsigned long src = *ppos;
@@ -37,9 +53,11 @@ static ssize_t kpagecount_read(struct fi
 	u64 pcount;
 
 	pfn = src / KPMSIZE;
-	count = min_t(size_t, count, (max_pfn * KPMSIZE) - src);
 	if (src & KPMMASK || count & KPMMASK)
 		return -EINVAL;
+	if (src >= max_dump_pfn * KPMSIZE)
+		return 0;
+	count = min_t(unsigned long, count, (max_dump_pfn * KPMSIZE) - src);
 
 	while (count > 0) {
 		/*
@@ -206,6 +224,7 @@ u64 stable_page_flags(struct page *page)
 static ssize_t kpageflags_read(struct file *file, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
+	const unsigned long max_dump_pfn = get_max_dump_pfn();
 	u64 __user *out = (u64 __user *)buf;
 	struct page *ppage;
 	unsigned long src = *ppos;
@@ -213,9 +232,11 @@ static ssize_t kpageflags_read(struct fi
 	ssize_t ret = 0;
 
 	pfn = src / KPMSIZE;
-	count = min_t(unsigned long, count, (max_pfn * KPMSIZE) - src);
 	if (src & KPMMASK || count & KPMMASK)
 		return -EINVAL;
+	if (src >= max_dump_pfn * KPMSIZE)
+		return 0;
+	count = min_t(unsigned long, count, (max_dump_pfn * KPMSIZE) - src);
 
 	while (count > 0) {
 		/*
@@ -251,6 +272,7 @@ static const struct file_operations proc
 static ssize_t kpagecgroup_read(struct file *file, char __user *buf,
 				size_t count, loff_t *ppos)
 {
+	const unsigned long max_dump_pfn = get_max_dump_pfn();
 	u64 __user *out = (u64 __user *)buf;
 	struct page *ppage;
 	unsigned long src = *ppos;
@@ -259,9 +281,11 @@ static ssize_t kpagecgroup_read(struct f
 	u64 ino;
 
 	pfn = src / KPMSIZE;
-	count = min_t(unsigned long, count, (max_pfn * KPMSIZE) - src);
 	if (src & KPMMASK || count & KPMMASK)
 		return -EINVAL;
+	if (src >= max_dump_pfn * KPMSIZE)
+		return 0;
+	count = min_t(unsigned long, count, (max_dump_pfn * KPMSIZE) - src);
 
 	while (count > 0) {
 		/*
_

Patches currently in -mm which might be from david@redhat.com are

drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch
