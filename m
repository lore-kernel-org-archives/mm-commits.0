From: akpm@linux-foundation.org
Subject: +
 mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done.patch added to -mm tree
Date: Tue, 14 Feb 2017 14:01:23 -0800
Message-ID: <58a37e33.klV+BXwUAqwRmjsf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56084 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751289AbdBNWBY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2017 17:01:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, ben@decadent.org.uk, logang@deltatee.com, m.mizuma@jp.fujitsu.com, mhocko@suse.com, toshi.kani@hpe.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, devm_memremap_pages: hold device_hotplug lock over mem_hotplug_{begin, done}
has been added to the -mm tree.  Its filename is
     mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done.patch

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
Subject: mm, devm_memremap_pages: hold device_hotplug lock over mem_hotplug_{begin, done}

The mem_hotplug_{begin,done} lock coordinates with {get,put}_online_mems()
to hold off "readers" of the current state of memory from new hotplug
actions.  mem_hotplug_begin() expects exclusive access, via the
device_hotplug lock, to set mem_hotplug.active_writer.  Calling
mem_hotplug_begin() without locking device_hotplug can lead to corrupting
mem_hotplug.refcount and missed wakeups / soft lockups.

Link: http://lkml.kernel.org/r/148693885680.16345.17802627926777862337.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: f931ab479dd2 ("mm: fix devm_memremap_pages crash, use mem_hotplug_{begin, done}")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/memremap.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/memremap.c~mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done kernel/memremap.c
--- a/kernel/memremap.c~mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done
+++ a/kernel/memremap.c
@@ -264,9 +264,12 @@ static void devm_memremap_pages_release(
 	}
 
 	/* pages are dead and unused, undo the arch mapping */
+	lock_device_hotplug();
 	mem_hotplug_begin();
 	arch_remove_memory(res->start, resource_size(res));
 	mem_hotplug_done();
+	unlock_device_hotplug();
+
 	untrack_pfn(NULL, PHYS_PFN(res->start), resource_size(res));
 	pgmap_radix_release(res);
 	dev_WARN_ONCE(dev, pgmap->altmap && pgmap->altmap->alloc,
@@ -374,9 +377,11 @@ void *devm_memremap_pages(struct device
 	if (error)
 		goto err_pfn_remap;
 
+	lock_device_hotplug();
 	mem_hotplug_begin();
 	error = arch_add_memory(nid, res->start, resource_size(res), true);
 	mem_hotplug_done();
+	unlock_device_hotplug();
 	if (error)
 		goto err_add_memory;
 
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
mm-support-section-unaligned-zone_device-memory-ranges-fix-2.patch
mm-enable-section-unaligned-devm_memremap_pages.patch
libnvdimm-pfn-dax-stop-padding-pmem-namespaces-to-section-alignment.patch
mm-fix-get_user_pages-vs-device-dax-pud-mappings.patch
mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done.patch
mm-validate-device_hotplug-is-held-for-memory-hotplug.patch

