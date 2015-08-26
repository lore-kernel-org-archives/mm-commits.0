From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-check-if-section-present-during-memory-block-unregistering.patch removed from -mm tree
Date: Wed, 26 Aug 2015 14:06:18 -0700
Message-ID: <55de2a4a.muPqbrnJONeVzyKC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbbHZVGT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Aug 2015 17:06:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, greg@kroah.com, mingo@kernel.org, stable@vger.kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: check if section present during memory block (un)registering
has been removed from the -mm tree.  Its filename was
     mm-check-if-section-present-during-memory-block-unregistering.patch

This patch was dropped because it was folded into ocfs2-direct-write-will-call-ocfs2_rw_unlock-twice-when-doing-aiodio.patch

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: mm: check if section present during memory block (un)registering

Tony Luck found on his setup, if memory block size 512M will cause crash
during booting.

 BUG: unable to handle kernel paging request at ffffea0074000020
 IP: [<ffffffff81670527>] get_nid_for_pfn+0x17/0x40
 PGD 128ffcb067 PUD 128ffc9067 PMD 0
 Oops: 0000 [#1] SMP
 Modules linked in:
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.2.0-rc8 #1
...
 Call Trace:
  [<ffffffff81453b56>] ? register_mem_sect_under_node+0x66/0xe0
  [<ffffffff81453eeb>] register_one_node+0x17b/0x240
  [<ffffffff81b1f1ed>] ? pci_iommu_alloc+0x6e/0x6e
  [<ffffffff81b1f229>] topology_init+0x3c/0x95
  [<ffffffff8100213d>] do_one_initcall+0xcd/0x1f0

The system has non continuous RAM address:
 BIOS-e820: [mem 0x0000001300000000-0x0000001cffffffff] usable
 BIOS-e820: [mem 0x0000001d70000000-0x0000001ec7ffefff] usable
 BIOS-e820: [mem 0x0000001f00000000-0x0000002bffffffff] usable
 BIOS-e820: [mem 0x0000002c18000000-0x0000002d6fffefff] usable
 BIOS-e820: [mem 0x0000002e00000000-0x00000039ffffffff] usable

So there are start sections in memory block not present.
For example:
memory block : [0x2c18000000, 0x2c20000000) 512M
first three sections are not present.

Current register_mem_sect_under_node() assume first section is present,
but memory block section number range [start_section_nr, end_section_nr]
would include not present section.

For arch that support vmemmap, we don't setup memmap for struct page area
within not present sections area.

So skip the pfn range that belong to not present section.

Also fixes unregister_mem_sect_under_nodes().

Fixes: bdee237c0343 ("x86: mm: Use 2GB memory block size on large memory x86-64 systems")
Fixes: 982792c782ef ("x86, mm: probe memory block size for generic x86 64bit")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reported-by: Tony Luck <tony.luck@intel.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>	[3.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff -puN drivers/base/node.c~mm-check-if-section-present-during-memory-block-unregistering drivers/base/node.c
--- a/drivers/base/node.c~mm-check-if-section-present-during-memory-block-unregistering
+++ a/drivers/base/node.c
@@ -390,8 +390,14 @@ int register_mem_sect_under_node(struct
 	sect_end_pfn = section_nr_to_pfn(mem_blk->end_section_nr);
 	sect_end_pfn += PAGES_PER_SECTION - 1;
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
-		int page_nid;
+		int page_nid, scn_nr;
 
+		scn_nr = pfn_to_section_nr(pfn);
+		if (!present_section_nr(scn_nr)) {
+			pfn = round_down(pfn + PAGES_PER_SECTION,
+					 PAGES_PER_SECTION) - 1;
+			continue;
+		}
 		page_nid = get_nid_for_pfn(pfn);
 		if (page_nid < 0)
 			continue;
@@ -426,10 +432,18 @@ int unregister_mem_sect_under_nodes(stru
 		return -ENOMEM;
 	nodes_clear(*unlinked_nodes);
 
-	sect_start_pfn = section_nr_to_pfn(phys_index);
-	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
+	sect_start_pfn = section_nr_to_pfn(mem_blk->start_section_nr);
+	sect_end_pfn = section_nr_to_pfn(mem_blk->end_section_nr);
+	sect_end_pfn += PAGES_PER_SECTION - 1;
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
-		int nid;
+		int nid, scn_nr;
+
+		scn_nr = pfn_to_section_nr(pfn);
+		if (!present_section_nr(scn_nr)) {
+			pfn = round_down(pfn + PAGES_PER_SECTION,
+					 PAGES_PER_SECTION) - 1;
+			continue;
+		}
 
 		nid = get_nid_for_pfn(pfn);
 		if (nid < 0)
_

Patches currently in -mm which might be from yinghai@kernel.org are

ocfs2-direct-write-will-call-ocfs2_rw_unlock-twice-when-doing-aiodio.patch
mm-check-if-section-present-during-memory-block-unregistering-v2.patch
lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel.patch
lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2.patch

