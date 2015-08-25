From: akpm@linux-foundation.org
Subject: +
 mm-check-if-section-present-during-memory-block-unregistering.patch added
 to -mm tree
Date: Tue, 25 Aug 2015 16:09:27 -0700
Message-ID: <55dcf5a7.0+dzCqzpyX5lEltE%akpm__32065.4722898782$1440544184$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbbHYXJ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Aug 2015 19:09:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, greg@kroah.com, stable@vger.kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: check if section present during memory block (un)registering
has been added to the -mm tree.  Its filename is
     mm-check-if-section-present-during-memory-block-unregistering.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-check-if-section-present-during-memory-block-unregistering.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-check-if-section-present-during-memory-block-unregistering.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reported-by: Tony Luck <tony.luck@intel.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@vger.kernel.org>
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

mm-check-if-section-present-during-memory-block-unregistering.patch
lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel.patch
lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2.patch

