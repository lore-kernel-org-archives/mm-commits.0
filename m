From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplug-dont-read-nid-from-struct-page-during-hotplug.patch added to -mm tree
Date: Thu, 15 Feb 2018 14:46:36 -0800
Message-ID: <5a860dcc.kXlpsBImYOkRvnsU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42042 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756384AbeBOWrG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Feb 2018 17:47:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, bharata@linux.vnet.ibm.com, bhe@redhat.com, daniel.m.jordan@oracle.com, dan.j.williams@intel.com, gregkh@linuxfoundation.org, hpa@zytor.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, mingo@kernel.org, steven.sistare@oracle.com, tglx@linutronix.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: don't read nid from struct page during hotplug
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-dont-read-nid-from-struct-page-during-hotplug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-dont-read-nid-from-struct-page-during-hotplug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-dont-read-nid-from-struct-page-during-hotplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm/memory_hotplug: don't read nid from struct page during hotplug

During memory hotplugging the probe routine will leave struct pages
uninitialized, the same as it is currently done during boot.  Therefore,
we do not want to access the inside of struct pages before
__init_single_page() is called during onlining.

Because during hotplug we know that pages in one memory block belong to
the same numa node, we can skip the checking.  We should keep checking for
the boot case.

Link: http://lkml.kernel.org/r/20180215165920.8570-6-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    2 +-
 drivers/base/node.c   |   22 +++++++++++++++-------
 include/linux/node.h  |    4 ++--
 3 files changed, 18 insertions(+), 10 deletions(-)

diff -puN drivers/base/memory.c~mm-memory_hotplug-dont-read-nid-from-struct-page-during-hotplug drivers/base/memory.c
--- a/drivers/base/memory.c~mm-memory_hotplug-dont-read-nid-from-struct-page-during-hotplug
+++ a/drivers/base/memory.c
@@ -731,7 +731,7 @@ int register_new_memory(int nid, struct
 	}
 
 	if (mem->section_count == sections_per_block)
-		ret = register_mem_sect_under_node(mem, nid);
+		ret = register_mem_sect_under_node(mem, nid, false);
 out:
 	mutex_unlock(&mem_sysfs_mutex);
 	return ret;
diff -puN drivers/base/node.c~mm-memory_hotplug-dont-read-nid-from-struct-page-during-hotplug drivers/base/node.c
--- a/drivers/base/node.c~mm-memory_hotplug-dont-read-nid-from-struct-page-during-hotplug
+++ a/drivers/base/node.c
@@ -397,7 +397,8 @@ static int __ref get_nid_for_pfn(unsigne
 }
 
 /* register memory section under specified node if it spans that node */
-int register_mem_sect_under_node(struct memory_block *mem_blk, int nid)
+int register_mem_sect_under_node(struct memory_block *mem_blk, int nid,
+				 bool check_nid)
 {
 	int ret;
 	unsigned long pfn, sect_start_pfn, sect_end_pfn;
@@ -423,11 +424,18 @@ int register_mem_sect_under_node(struct
 			continue;
 		}
 
-		page_nid = get_nid_for_pfn(pfn);
-		if (page_nid < 0)
-			continue;
-		if (page_nid != nid)
-			continue;
+		/*
+		 * We need to check if page belongs to nid only for the boot
+		 * case, during hotplug we know that all pages in the memory
+		 * block belong to the same node.
+		 */
+		if (check_nid) {
+			page_nid = get_nid_for_pfn(pfn);
+			if (page_nid < 0)
+				continue;
+			if (page_nid != nid)
+				continue;
+		}
 		ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
 					&mem_blk->dev.kobj,
 					kobject_name(&mem_blk->dev.kobj));
@@ -502,7 +510,7 @@ int link_mem_sections(int nid, unsigned
 
 		mem_blk = find_memory_block_hinted(mem_sect, mem_blk);
 
-		ret = register_mem_sect_under_node(mem_blk, nid);
+		ret = register_mem_sect_under_node(mem_blk, nid, true);
 		if (!err)
 			err = ret;
 
diff -puN include/linux/node.h~mm-memory_hotplug-dont-read-nid-from-struct-page-during-hotplug include/linux/node.h
--- a/include/linux/node.h~mm-memory_hotplug-dont-read-nid-from-struct-page-during-hotplug
+++ a/include/linux/node.h
@@ -67,7 +67,7 @@ extern void unregister_one_node(int nid)
 extern int register_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int register_mem_sect_under_node(struct memory_block *mem_blk,
-						int nid);
+						int nid, bool check_nid);
 extern int unregister_mem_sect_under_nodes(struct memory_block *mem_blk,
 					   unsigned long phys_index);
 
@@ -97,7 +97,7 @@ static inline int unregister_cpu_under_n
 	return 0;
 }
 static inline int register_mem_sect_under_node(struct memory_block *mem_blk,
-							int nid)
+							int nid, bool check_nid)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-initialize-pages-on-demand-during-boot.patch
mm-initialize-pages-on-demand-during-boot-fix-3.patch
mm-memory_hotplug-enforce-block-size-aligned-range-check.patch
x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory.patch
x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory-v4.patch
mm-uninitialized-struct-page-poisoning-sanity-checking.patch
mm-uninitialized-struct-page-poisoning-sanity-checking-v4.patch
mm-memory_hotplug-optimize-probe-routine.patch
mm-memory_hotplug-dont-read-nid-from-struct-page-during-hotplug.patch
mm-memory_hotplug-optimize-memory-hotplug.patch
sparc64-ng4-memset-32-bits-overflow.patch

