From: akpm@linux-foundation.org
Subject: [merged]
 mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done.patch removed from -mm tree
Date: Mon, 27 Feb 2017 12:24:14 -0800
Message-ID: <58b48aee.oZ4ZbTnqdXgcJVOU%akpm__29867.4993835904$1488227170$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60320 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751571AbdB0UYm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:24:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, ben@decadent.org.uk, logang@deltatee.com, m.mizuma@jp.fujitsu.com, mhocko@suse.com, stable@vger.kernel.org, toshi.kani@hpe.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, devm_memremap_pages: hold device_hotplug lock over mem_hotplug_{begin, done}
has been removed from the -mm tree.  Its filename was
     mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm, devm_memremap_pages: hold device_hotplug lock over mem_hotplug_{begin, done}

The mem_hotplug_{begin,done} lock coordinates with {get,put}_online_mems()
to hold off "readers" of the current state of memory from new hotplug
actions.  mem_hotplug_begin() expects exclusive access, via the
device_hotplug lock, to set mem_hotplug.active_writer.  Calling
mem_hotplug_begin() without locking device_hotplug can lead to corrupting
mem_hotplug.refcount and missed wakeups / soft lockups.

[dan.j.williams@intel.com: v2]
  Link: http://lkml.kernel.org/r/148728203365.38457.17804568297887708345.stgit@dwillia2-desk3.amr.corp.intel.com
Link: http://lkml.kernel.org/r/148693885680.16345.17802627926777862337.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: f931ab479dd2 ("mm: fix devm_memremap_pages crash, use mem_hotplug_{begin, done}")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/memremap.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/memremap.c~mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done kernel/memremap.c
--- a/kernel/memremap.c~mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done
+++ a/kernel/memremap.c
@@ -246,9 +246,13 @@ static void devm_memremap_pages_release(
 	/* pages are dead and unused, undo the arch mapping */
 	align_start = res->start & ~(SECTION_SIZE - 1);
 	align_size = ALIGN(resource_size(res), SECTION_SIZE);
+
+	lock_device_hotplug();
 	mem_hotplug_begin();
 	arch_remove_memory(align_start, align_size);
 	mem_hotplug_done();
+	unlock_device_hotplug();
+
 	untrack_pfn(NULL, PHYS_PFN(align_start), align_size);
 	pgmap_radix_release(res);
 	dev_WARN_ONCE(dev, pgmap->altmap && pgmap->altmap->alloc,
@@ -360,9 +364,11 @@ void *devm_memremap_pages(struct device
 	if (error)
 		goto err_pfn_remap;
 
+	lock_device_hotplug();
 	mem_hotplug_begin();
 	error = arch_add_memory(nid, align_start, align_size, true);
 	mem_hotplug_done();
+	unlock_device_hotplug();
 	if (error)
 		goto err_add_memory;
 
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


