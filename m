From: akpm@linux-foundation.org
Subject: +
 mm-fix-type-width-of-section-to-from-pfn-conversion-macros.patch added to
 -mm tree
Date: Thu, 19 Jan 2017 16:05:48 -0800
Message-ID: <5881545c.l0MFsyY090X4gFcQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44946 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753520AbdATANw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2017 19:13:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hannes@cmpxchg.org, logang@deltatee.com, mgorman@techsingularity.net, mhocko@suse.com, stephen.bates@microsemi.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix type width of section to/from pfn conversion macros
has been added to the -mm tree.  Its filename is
     mm-fix-type-width-of-section-to-from-pfn-conversion-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-type-width-of-section-to-from-pfn-conversion-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-type-width-of-section-to-from-pfn-conversion-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: fix type width of section to/from pfn conversion macros

Patch series "mm: sub-section memory hotplug support", v3.

The initial motivation for this change is persistent memory platforms
that, unfortunately, align the pmem range on a boundary less than a full
section (64M vs 128M), and may change the alignment from one boot to the
next.  A secondary motivation is the arrival of prospective ZONE_DEVICE
users that want devm_memremap_pages() to map PCI-E device memory ranges to
enable peer-to-peer DMA.  There is a range of possible physical address
alignments of PCI-E BARs that are less than 128M.

Currently the libnvdimm core injects padding when 'pfn' (struct page
mapping configuration) instances are created.  However, not all users of
devm_memremap_pages() have the opportunity to inject such padding.  Users
of the memmap=ss!nn kernel command line option can trigger the following
failure with unaligned parameters like "memmap=0xfc000000!8G":

 WARNING: CPU: 0 PID: 558 at kernel/memremap.c:300
 devm_memremap_pages attempted on mixed region [mem 0x200000000-0x2fbffffff flags 0x200]
 [..]
 Call Trace:
  [<ffffffff814c0393>] dump_stack+0x86/0xc3
  [<ffffffff810b173b>] __warn+0xcb/0xf0
  [<ffffffff810b17bf>] warn_slowpath_fmt+0x5f/0x80
  [<ffffffff811eb105>] devm_memremap_pages+0x3b5/0x4c0
  [<ffffffffa006f308>] __wrap_devm_memremap_pages+0x58/0x70 [nfit_test_iomap]
  [<ffffffffa00e231a>] pmem_attach_disk+0x19a/0x440 [nd_pmem]

Without this change a user could inadvertently lose access to nvdimm
namespaces after a configuration change.  The act of adding, removing, or
rearranging DIMMs in the platform could lead to the BIOS changing the base
alignment of the namespace in an incompatible fashion.  With this support
we can accommodate a BIOS changing the namespace to any alignment provided
it is >= SECTION_ACTIVE_SIZE.

In other words, we are protecting against misalignment injected by the
BIOS after the libnvdimm sub-system already recorded that the namespace
does not need alignment padding.  In that case the user would need to
figure out how to undo the configuration change to regain access to their
nvdimm capacity.


This patch (of 12):

section_nr_to_pfn() will silently accept an argument that is too small to
contain a pfn.  Cast the argument to an unsigned long, similar to
PFN_PHYS().  Fix up pfn_to_section_nr() in the same way.

This was discovered in __add_pages() when converting it to use an signed
integer for the loop variable.

Link: http://lkml.kernel.org/r/148486360180.19694.6303499052926089764.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Stephen Bates <stephen.bates@microsemi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++--
 mm/memory_hotplug.c    |    4 +---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff -puN include/linux/mmzone.h~mm-fix-type-width-of-section-to-from-pfn-conversion-macros include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-fix-type-width-of-section-to-from-pfn-conversion-macros
+++ a/include/linux/mmzone.h
@@ -1062,8 +1062,8 @@ static inline unsigned long early_pfn_to
 #error Allocator MAX_ORDER exceeds SECTION_SIZE
 #endif
 
-#define pfn_to_section_nr(pfn) ((pfn) >> PFN_SECTION_SHIFT)
-#define section_nr_to_pfn(sec) ((sec) << PFN_SECTION_SHIFT)
+#define pfn_to_section_nr(pfn) ((unsigned long)(pfn) >> PFN_SECTION_SHIFT)
+#define section_nr_to_pfn(sec) ((unsigned long)(sec) << PFN_SECTION_SHIFT)
 
 #define SECTION_ALIGN_UP(pfn)	(((pfn) + PAGES_PER_SECTION - 1) & PAGE_SECTION_MASK)
 #define SECTION_ALIGN_DOWN(pfn)	((pfn) & PAGE_SECTION_MASK)
diff -puN mm/memory_hotplug.c~mm-fix-type-width-of-section-to-from-pfn-conversion-macros mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-fix-type-width-of-section-to-from-pfn-conversion-macros
+++ a/mm/memory_hotplug.c
@@ -530,9 +530,7 @@ static int __meminit __add_section(int n
 int __ref __add_pages(int nid, struct zone *zone, unsigned long phys_start_pfn,
 			unsigned long nr_pages)
 {
-	unsigned long i;
-	int err = 0;
-	int start_sec, end_sec;
+	int err = 0, i, start_sec, end_sec;
 	struct vmem_altmap *altmap;
 
 	clear_zone_contiguous(zone);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-fix-type-width-of-section-to-from-pfn-conversion-macros.patch
mm-devm_memremap_pages-use-multi-order-radix-for-zone_device-lookups.patch
mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section.patch
mm-introduce-common-definitions-for-the-size-and-mask-of-a-section.patch
mm-cleanup-sparse_init_one_section-return-value.patch
mm-track-active-portions-of-a-section-at-boot.patch
mm-fix-register_new_memory-zone-type-detection.patch
mm-convert-kmalloc_section_memmap-to-populate_section_memmap.patch
mm-prepare-for-hot-add-remove-of-sub-section-ranges.patch
mm-support-section-unaligned-zone_device-memory-ranges.patch
mm-enable-section-unaligned-devm_memremap_pages.patch
libnvdimm-pfn-dax-stop-padding-pmem-namespaces-to-section-alignment.patch

