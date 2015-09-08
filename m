From: akpm@linux-foundation.org
Subject: [merged]
 mm-check-if-section-present-during-memory-block-registering.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 11:01:14 -0700
Message-ID: <55ef226a.8jdSwuX8s5L/e78J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbbIHSBP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:01:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, greg@kroah.com, mingo@elte.hu, rientjes@google.com, stable@vger.kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: check if section present during memory block registering
has been removed from the -mm tree.  Its filename was
     mm-check-if-section-present-during-memory-block-registering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: mm: check if section present during memory block registering

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

So skip the pfn range that belong to absent section.

[akpm@linux-foundation.org: simplification]
[rientjes@google.com: more simplification]
Fixes: bdee237c0343 ("x86: mm: Use 2GB memory block size on large memory x86-64 systems")
Fixes: 982792c782ef ("x86, mm: probe memory block size for generic x86 64bit")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Tony Luck <tony.luck@intel.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Tested-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[3.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/base/node.c~mm-check-if-section-present-during-memory-block-registering drivers/base/node.c
--- a/drivers/base/node.c~mm-check-if-section-present-during-memory-block-registering
+++ a/drivers/base/node.c
@@ -392,6 +392,16 @@ int register_mem_sect_under_node(struct
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
 		int page_nid;
 
+		/*
+		 * memory block could have several absent sections from start.
+		 * skip pfn range from absent section
+		 */
+		if (!pfn_present(pfn)) {
+			pfn = round_down(pfn + PAGES_PER_SECTION,
+					 PAGES_PER_SECTION) - 1;
+			continue;
+		}
+
 		page_nid = get_nid_for_pfn(pfn);
 		if (page_nid < 0)
 			continue;
_

Patches currently in -mm which might be from yinghai@kernel.org are

lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel.patch
lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2.patch

