From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 drivers-base-memoryc-indicate-all-memory-blocks-as-removable.patch added to
 -mm tree
Date: Wed, 12 Feb 2020 18:16:21 -0800
Message-ID: <20200213021621.8O7lvqntm%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729469AbgBMCQX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Feb 2020 21:16:23 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, david@redhat.com, gregkh@linuxfoundation.org, heiko.carstens@de.ibm.com, kzak@redhat.com, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, ndfont@gmail.com, pbadari@us.ibm.com, rafael@kernel.org, rcj@linux.vnet.ibm.com


The patch titled
     Subject: drivers/base/memory.c: indicate all memory blocks as removable
has been added to the -mm tree.  Its filename is
     drivers-base-memoryc-indicate-all-memory-blocks-as-removable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-base-memoryc-indicate-all-memory-blocks-as-removable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-base-memoryc-indicate-all-memory-blocks-as-removable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: drivers/base/memory.c: indicate all memory blocks as removable

We see multiple issues with the implementation/interface to compute
whether a memory block can be offlined (exposed via
/sys/devices/system/memory/memoryX/removable) and would like to simplify
it (remove the implementation).

1. It runs basically lockless. While this might be good for performance,
   we see possible races with memory offlining that will require at least
   some sort of locking to fix.

2. Nowadays, more false positives are possible. No arch-specific checks
   are performed that validate if memory offlining will not be denied
   right away (and such check will require locking). For example, arm64
   won't allow to offline any memory block that was added during boot -
   which will imply a very high error rate. Other archs have other
   constraints.

3. The interface is inherently racy. E.g., if a memory block is
   detected to be removable (and was not a false positive at that time),
   there is still no guarantee that offlining will actually succeed. So
   any caller already has to deal with false positives.

4. It is unclear which performance benefit this interface actually
   provides. The introducing commit 5c755e9fd813 ("memory-hotplug: add
   sysfs removable attribute for hotplug memory remove") mentioned
	"A user-level agent must be able to identify which sections of
	 memory are likely to be removable before attempting the
	 potentially expensive operation."
   However, no actual performance comparison was included.

Known users:
- lsmem: Will group memory blocks based on the "removable" property. [1]
- chmem: Indirect user. It has a RANGE mode where one can specify
	 removable ranges identified via lsmem to be offlined. However, it
	 also has a "SIZE" mode, which allows a sysadmin to skip the manual
	 "identify removable blocks" step. [2]
- powerpc-utils: Uses the "removable" attribute to skip some memory
		 blocks right away when trying to find some to
		 offline+remove. However, with ballooning enabled, it
		 already skips this information completely (because it
		 once resulted in many false negatives). Therefore, the
		 implementation can deal with false positives properly
		 already. [3]

According to Nathan Fontenot, DLPAR on powerpc is nowadays no longer
driven from userspace via the drmgr command (powerpc-utils). Nowadays
it's managed in the kernel - including onlining/offlining of memory
blocks - triggered by drmgr writing to /sys/kernel/dlpar. So the
affected legacy userspace handling is only active on old kernels. Only ve=
ry
old versions of drmgr on a new kernel (unlikely) might execute slower -
totally acceptable.

With CONFIG_MEMORY_HOTREMOVE, always indicating "removable" should not
break any user space tool. We implement a very bad heuristic now.  Withou=
t
CONFIG_MEMORY_HOTREMOVE we cannot offline anything, so report
"not removable" as before.

Original discussion can be found in [4] ("[PATCH RFC v1] mm:
is_mem_section_removable() overhaul").

Other users of is_mem_section_removable() will be removed next, so that
we can remove is_mem_section_removable() completely.

[1] http://man7.org/linux/man-pages/man1/lsmem.1.html
[2] http://man7.org/linux/man-pages/man8/chmem.8.html
[3] https://github.com/ibm-power-utilities/powerpc-utils
[4] https://lkml.kernel.org/r/20200117105759.27905-1-david@redhat.com

Link: http://lkml.kernel.org/r/20200128093542.6908-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Nathan Fontenot <ndfont@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Karel Zak <kzak@redhat.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memoryc-indicate-all-memory-blocks-as-removable
+++ a/drivers/base/memory.c
@@ -105,30 +105,13 @@ static ssize_t phys_index_show(struct de
 }
 
 /*
- * Show whether the memory block is likely to be offlineable (or is already
- * offline). Once offline, the memory block could be removed. The return
- * value does, however, not indicate that there is a way to remove the
- * memory block.
+ * Legacy interface that we cannot remove. Always indicate "removable"
+ * with CONFIG_MEMORY_HOTREMOVE - bad heuristic.
  */
 static ssize_t removable_show(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
-	struct memory_block *mem = to_memory_block(dev);
-	unsigned long pfn;
-	int ret = 1, i;
-
-	if (mem->state != MEM_ONLINE)
-		goto out;
-
-	for (i = 0; i < sections_per_block; i++) {
-		if (!present_section_nr(mem->start_section_nr + i))
-			continue;
-		pfn = section_nr_to_pfn(mem->start_section_nr + i);
-		ret &= is_mem_section_removable(pfn, PAGES_PER_SECTION);
-	}
