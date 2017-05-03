From: akpm@linux-foundation.org
Subject: [folded-merged] mm-enable-page-poisoning-early-at-boot-v2.patch
 removed from -mm tree
Date: Wed, 03 May 2017 14:42:13 -0700
Message-ID: <590a4eb5.fGMokPhTejVtFhNG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45902 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbdECVmO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:42:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vinmenon@codeaurora.org, akinobu.mita@gmail.com, iamjoonsoo.kim@lge.com, labbott@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-enable-page-poisoning-early-at-boot-v2
has been removed from the -mm tree.  Its filename was
     mm-enable-page-poisoning-early-at-boot-v2.patch

This patch was dropped because it was folded into mm-enable-page-poisoning-early-at-boot.patch

------------------------------------------------------
From: Vinayak Menon <vinmenon@codeaurora.org>
Subject: mm-enable-page-poisoning-early-at-boot-v2

 (1) Removed "select PAGE_EXTENSION" on CONFIG_PAGE_POISONING
 (2) Removed CONFIG_PAGE_POISONING checks in page_ext.c

Link: http://lkml.kernel.org/r/1490878002-14423-1-git-send-email-vinmenon@codeaurora.org
Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |    1 -
 mm/page_ext.c    |   10 ++--------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff -puN mm/Kconfig.debug~mm-enable-page-poisoning-early-at-boot-v2 mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-enable-page-poisoning-early-at-boot-v2
+++ a/mm/Kconfig.debug
@@ -42,7 +42,6 @@ config DEBUG_PAGEALLOC_ENABLE_DEFAULT
 
 config PAGE_POISONING
 	bool "Poison pages after freeing"
-	select PAGE_EXTENSION
 	select PAGE_POISONING_NO_SANITY if HIBERNATION
 	---help---
 	  Fill the pages with poison patterns after free_pages() and verify
diff -puN mm/page_ext.c~mm-enable-page-poisoning-early-at-boot-v2 mm/page_ext.c
--- a/mm/page_ext.c~mm-enable-page-poisoning-early-at-boot-v2
+++ a/mm/page_ext.c
@@ -124,15 +124,12 @@ struct page_ext *lookup_page_ext(struct
 	struct page_ext *base;
 
 	base = NODE_DATA(page_to_nid(page))->node_page_ext;
-#if defined(CONFIG_DEBUG_VM) || defined(CONFIG_PAGE_POISONING)
+#if defined(CONFIG_DEBUG_VM)
 	/*
 	 * The sanity checks the page allocator does upon freeing a
 	 * page can reach here before the page_ext arrays are
 	 * allocated when feeding a range of pages to the allocator
 	 * for the first time during bootup or memory hotplug.
-	 *
-	 * This check is also necessary for ensuring page poisoning
-	 * works as expected when enabled
 	 */
 	if (unlikely(!base))
 		return NULL;
@@ -201,15 +198,12 @@ struct page_ext *lookup_page_ext(struct
 {
 	unsigned long pfn = page_to_pfn(page);
 	struct mem_section *section = __pfn_to_section(pfn);
-#if defined(CONFIG_DEBUG_VM) || defined(CONFIG_PAGE_POISONING)
+#if defined(CONFIG_DEBUG_VM)
 	/*
 	 * The sanity checks the page allocator does upon freeing a
 	 * page can reach here before the page_ext arrays are
 	 * allocated when feeding a range of pages to the allocator
 	 * for the first time during bootup or memory hotplug.
-	 *
-	 * This check is also necessary for ensuring page poisoning
-	 * works as expected when enabled
 	 */
 	if (!section->page_ext)
 		return NULL;
_

Patches currently in -mm which might be from vinmenon@codeaurora.org are

mm-enable-page-poisoning-early-at-boot.patch

