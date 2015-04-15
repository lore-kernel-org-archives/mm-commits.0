From: akpm@linux-foundation.org
Subject: [merged]
 memory-hotplug-use-macro-to-switch-between-section-and-pfn.patch removed
 from -mm tree
Date: Wed, 15 Apr 2015 12:09:18 -0700
Message-ID: <552eb75e.4Dl72Qn9AJMs1iQW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670AbbDOTJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:09:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shengyong1@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory hotplug: use macro to switch between section and pfn
has been removed from the -mm tree.  Its filename was
     memory-hotplug-use-macro-to-switch-between-section-and-pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sheng Yong <shengyong1@huawei.com>
Subject: memory hotplug: use macro to switch between section and pfn

Use macro section_nr_to_pfn() to switch between section and pfn, instead
of open-coding it.  No semantic changes.

Signed-off-by: Sheng Yong <shengyong1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    2 +-
 mm/memory_hotplug.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/base/memory.c~memory-hotplug-use-macro-to-switch-between-section-and-pfn drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-use-macro-to-switch-between-section-and-pfn
+++ a/drivers/base/memory.c
@@ -228,7 +228,7 @@ memory_block_action(unsigned long phys_i
 	struct page *first_page;
 	int ret;
 
-	start_pfn = phys_index << PFN_SECTION_SHIFT;
+	start_pfn = section_nr_to_pfn(phys_index);
 	first_page = pfn_to_page(start_pfn);
 
 	switch (action) {
diff -puN mm/memory_hotplug.c~memory-hotplug-use-macro-to-switch-between-section-and-pfn mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-use-macro-to-switch-between-section-and-pfn
+++ a/mm/memory_hotplug.c
@@ -502,7 +502,7 @@ int __ref __add_pages(int nid, struct zo
 	end_sec = pfn_to_section_nr(phys_start_pfn + nr_pages - 1);
 
 	for (i = start_sec; i <= end_sec; i++) {
-		err = __add_section(nid, zone, i << PFN_SECTION_SHIFT);
+		err = __add_section(nid, zone, section_nr_to_pfn(i));
 
 		/*
 		 * EEXIST is finally dealt with by ioresource collision
_

Patches currently in -mm which might be from shengyong1@huawei.com are

origin.patch
linux-next.patch

