From: akpm@linux-foundation.org
Subject: +
 memory-hotplug-use-macro-to-switch-between-section-and-pfn.patch added to
 -mm tree
Date: Wed, 18 Feb 2015 13:58:59 -0800
Message-ID: <54e50b23.9R/AK2DFN5I4c97m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbbBRV7A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 16:59:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shengyong1@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory hotplug: use macro to switch between section and pfn
has been added to the -mm tree.  Its filename is
     memory-hotplug-use-macro-to-switch-between-section-and-pfn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-hotplug-use-macro-to-switch-between-section-and-pfn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplug-use-macro-to-switch-between-section-and-pfn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memory-hotplug-use-macro-to-switch-between-section-and-pfn.patch

