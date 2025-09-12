Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F4F261B71
	for <mm-commits@vger.kernel.org>; Fri, 12 Sep 2025 22:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757717658; cv=none; b=Dw/jMBcJwWhI6ydQZxHkAnXDN0Tl9g1KIq9yuB6XPQsyfube+zgfxTZc6ySYhWETJyEIuA1lfOqHs2RwXGBo7OmqawqzKyMeGKog7bOXQn1lMpFZLlKft1Bc5IWOaNu+BewDvQ1UjZQ/P7hYtvqAjKr9T9VtZ0EdBg/kth+tCi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757717658; c=relaxed/simple;
	bh=74EzaqWLsSa6Ur5k2Czp4koK6KD+06PS2YUCAm0Csj8=;
	h=Date:To:From:Subject:Message-Id; b=SNS3tWOcNh5ZhD5GnDDjI19r4TMwAbxdY1UFauhHeQJMOs193w3607WoSbSuwlLKpW3S6vwbb0D3KtP5vhxFMFWtYGfHUJE619OztvqGhh8vvz52iaLBb0ian5KIpsqU/C6Gv14c0d2aM9gHXjrbPZH2rXuxjP/qj35x/m6AZKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N2DhoslT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N2DhoslT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B61CC4CEF1;
	Fri, 12 Sep 2025 22:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757717658;
	bh=74EzaqWLsSa6Ur5k2Czp4koK6KD+06PS2YUCAm0Csj8=;
	h=Date:To:From:Subject:From;
	b=N2DhoslTQAtX+LOA5NMhs5XxovKtcwWbNRKe2+5w5RQfTyfSGqj3eHox42tnileAv
	 xtk6UN1GkNFn/9aID3C/MnLkAH3S1vqF9bbSwA47dOrxH3Fcj4kRmPM/Apq2rGt+RQ
	 nfQtjYlXxzz/TFxpiazlUjNOMmIaWu/2VUEy9S7M=
Date: Fri, 12 Sep 2025 15:54:17 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dan.j.williams@intel.com,andriy.shevchenko@linux.intel.com,agordeev@linux.ibm.com,sumanthk@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-improve-child-resource-handling-in-release_mem_region_adjustable.patch added to mm-new branch
Message-Id: <20250912225418.6B61CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: improve child resource handling in release_mem_region_adjustable()
has been added to the -mm mm-new branch.  Its filename is
     resource-improve-child-resource-handling-in-release_mem_region_adjustable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-improve-child-resource-handling-in-release_mem_region_adjustable.patch

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
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: resource: improve child resource handling in release_mem_region_adjustable()
Date: Fri, 12 Sep 2025 14:30:21 +0200

When memory block is removed via try_remove_memory(), it eventually
reaches release_mem_region_adjustable().  The current implementation
assumes that when a busy memory resource is split into two, all child
resources remain in the lower address range.

This simplification causes problems when child resources actually belong
to the upper split.  For example:

* Initial memory layout:
lsmem
RANGE                                 SIZE   STATE REMOVABLE  BLOCK
0x0000000000000000-0x00000002ffffffff  12G  online       yes   0-95

* /proc/iomem
00000000-2dfefffff : System RAM
  158834000-1597b3fff : Kernel code
  1597b4000-159f50fff : Kernel data
  15a13c000-15a218fff : Kernel bss
2dff00000-2ffefffff : Crash kernel
2fff00000-2ffffffff : System RAM

* After offlining and removing range
  0x150000000-0x157ffffff
lsmem -o RANGE,SIZE,STATE,BLOCK,CONFIGURED
(output according to upcoming lsmem changes with the configured column:
s390)
RANGE                                  SIZE   STATE  BLOCK  CONFIGURED
0x0000000000000000-0x000000014fffffff  5.3G  online   0-41  yes
0x0000000150000000-0x0000000157ffffff  128M offline     42  no
0x0000000158000000-0x00000002ffffffff  6.6G  online  43-95  yes

The iomem resource gets split into two entries, but kernel code, kernel
data, and kernel bss remain attached to the lower resource [0–5376M]
instead of the correct upper resource [5504M–12288M].

As a result, WARN_ON() triggers in release_mem_region_adjustable()
("Usecase: split into two entries - we need a new resource")
------------[ cut here ]------------
WARNING: CPU: 5 PID: 858 at kernel/resource.c:1486
release_mem_region_adjustable+0x210/0x280
Modules linked in:
CPU: 5 UID: 0 PID: 858 Comm: chmem Not tainted 6.17.0-rc2-11707-g2c36aaf3ba4e
Hardware name: IBM 3906 M04 704 (z/VM 7.3.0)
Krnl PSW : 0704d00180000000 0000024ec0dae0e4
           (release_mem_region_adjustable+0x214/0x280)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 RI:0 EA:3
Krnl GPRS: 0000000000000000 00000002ffffafc0 fffffffffffffff0 0000000000000000
           000000014fffffff 0000024ec2257608 0000000000000000 0000024ec2301758
           0000024ec22680d0 00000000902c9140 0000000150000000 00000002ffffafc0
           000003ffa61d8d18 0000024ec21fb478 0000024ec0dae014 000001cec194fbb0
Krnl Code: 0000024ec0dae0d8: af000000            mc      0,0
           0000024ec0dae0dc: a7f4ffc1            brc     15,0000024ec0dae05e
          #0000024ec0dae0e0: af000000            mc      0,0
          >0000024ec0dae0e4: a5defffd            llilh   %r13,65533
           0000024ec0dae0e8: c04000c6064c        larl    %r4,0000024ec266ed80
           0000024ec0dae0ee: eb1d400000f8        laa     %r1,%r13,0(%r4)
           0000024ec0dae0f4: 07e0                bcr     14,%r0
           0000024ec0dae0f6: a7f4ffc0            brc     15,0000024ec0dae076

 [<0000024ec0dae0e4>] release_mem_region_adjustable+0x214/0x280
([<0000024ec0dadf3c>] release_mem_region_adjustable+0x6c/0x280)
 [<0000024ec10a2130>] try_remove_memory+0x100/0x140
 [<0000024ec10a4052>] __remove_memory+0x22/0x40
 [<0000024ec18890f6>] config_mblock_store+0x326/0x3e0
 [<0000024ec11f7056>] kernfs_fop_write_iter+0x136/0x210
 [<0000024ec1121e86>] vfs_write+0x236/0x3c0
 [<0000024ec11221b8>] ksys_write+0x78/0x110
 [<0000024ec1b6bfbe>] __do_syscall+0x12e/0x350
 [<0000024ec1b782ce>] system_call+0x6e/0x90
Last Breaking-Event-Address:
 [<0000024ec0dae014>] release_mem_region_adjustable+0x144/0x280
---[ end trace 0000000000000000 ]---

Also, resource adjustment doesn't happen and stale resources still cover
[0-12288M].  Later, memory re-add fails in register_memory_resource() with
-EBUSY.

i.e: /proc/iomem is still:
00000000-2dfefffff : System RAM
  158834000-1597b3fff : Kernel code
  1597b4000-159f50fff : Kernel data
  15a13c000-15a218fff : Kernel bss
2dff00000-2ffefffff : Crash kernel
2fff00000-2ffffffff : System RAM

Enhance release_mem_region_adjustable() to reassign child resources to the
correct parent after a split.  Children are now assigned based on their
actual range: If they fall within the lower split, keep them in the lower
parent.  If they fall within the upper split, move them to the upper
parent.

Kernel code/data/bss regions are not offlined, so they will always reside
entirely within one parent and never span across both.

Output after the enhancement:
* Initial state /proc/iomem (before removal of memory block):
00000000-2dfefffff : System RAM
  1f94f8000-1fa477fff : Kernel code
  1fa478000-1fac14fff : Kernel data
  1fae00000-1faedcfff : Kernel bss
2dff00000-2ffefffff : Crash kernel
2fff00000-2ffffffff : System RAM

* Offline and remove 0x1e8000000-0x1efffffff memory range
* /proc/iomem
00000000-1e7ffffff : System RAM
1f0000000-2dfefffff : System RAM
  1f94f8000-1fa477fff : Kernel code
  1fa478000-1fac14fff : Kernel data
  1fae00000-1faedcfff : Kernel bss
2dff00000-2ffefffff : Crash kernel
2fff00000-2ffffffff : System RAM

Link: https://lkml.kernel.org/r/20250912123021.3219980-1-sumanthk@linux.ibm.com
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   50 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 5 deletions(-)

--- a/kernel/resource.c~resource-improve-child-resource-handling-in-release_mem_region_adjustable
+++ a/kernel/resource.c
@@ -1388,6 +1388,47 @@ void __release_region(struct resource *p
 EXPORT_SYMBOL(__release_region);
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
+static void append_child_to_parent(struct resource *new_parent, struct resource *new_child)
+{
+	struct resource *child;
+
+	child = new_parent->child;
+	if (child) {
+		while (child->sibling)
+			child = child->sibling;
+		child->sibling = new_child;
+	} else {
+		new_parent->child = new_child;
+	}
+	new_child->parent = new_parent;
+	new_child->sibling = NULL;
+}
+
+/*
+ * Reparent all child resources that no longer belong to "low" after a split to
+ * "high". Note that "high" does not have any children, because "low" is the
+ * original resource and "high" is a new resource. Treat "low" as the original
+ * resource being split and defer its range adjustment to __adjust_resource().
+ */
+static void reparent_children_after_split(struct resource *low,
+					  struct resource *high,
+					  resource_size_t split_addr)
+{
+	struct resource *child, *next, **p;
+
+	p = &low->child;
+	while ((child = *p)) {
+		next = child->sibling;
+		if (child->start > split_addr) {
+			/* unlink child */
+			*p = next;
+			append_child_to_parent(high, child);
+		} else {
+			p = &child->sibling;
+		}
+	}
+}
+
 /**
  * release_mem_region_adjustable - release a previously reserved memory region
  * @start: resource start address
@@ -1397,15 +1438,13 @@ EXPORT_SYMBOL(__release_region);
  * is released from a currently busy memory resource.  The requested region
  * must either match exactly or fit into a single busy resource entry.  In
  * the latter case, the remaining resource is adjusted accordingly.
- * Existing children of the busy memory resource must be immutable in the
- * request.
  *
  * Note:
  * - Additional release conditions, such as overlapping region, can be
  *   supported after they are confirmed as valid cases.
- * - When a busy memory resource gets split into two entries, the code
- *   assumes that all children remain in the lower address entry for
- *   simplicity.  Enhance this logic when necessary.
+ * - When a busy memory resource gets split into two entries, its children are
+ *   reassigned to the correct parent based on their range. If a child memory
+ *   resource overlaps with more than one parent, enhance the logic as needed.
  */
 void release_mem_region_adjustable(resource_size_t start, resource_size_t size)
 {
@@ -1482,6 +1521,7 @@ retry:
 			new_res->parent = res->parent;
 			new_res->sibling = res->sibling;
 			new_res->child = NULL;
+			reparent_children_after_split(res, new_res, end);
 
 			if (WARN_ON_ONCE(__adjust_resource(res, res->start,
 							   start - res->start)))
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are

resource-improve-child-resource-handling-in-release_mem_region_adjustable.patch

