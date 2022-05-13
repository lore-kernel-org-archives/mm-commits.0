Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C97C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383807AbiEMTZd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383888AbiEMTYN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:24:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B432E9DE
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C36E460ADA
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23656C34117;
        Fri, 13 May 2022 19:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469749;
        bh=ll01mSko/XRUbkUV6u/P3vIlD5IyJVDhVgx+TywTARU=;
        h=Date:To:From:Subject:From;
        b=xbUSLaWtg2eCey3nbbz7z6tycF5NXyj9If8xlGiCyEnTZsgdlszB+IO8+p8dCe/D5
         bru2NZ66OPMrSnDzTriq+QuAhk68YNxtV5se2aZRJv6bM4FIffHj0/OfQrU5uV0QvX
         xHthA+8NNxv+m0DFnZ+n4x97Qn7SjbhUOyDah+N8=
Date:   Fri, 13 May 2022 12:22:28 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        pizhenwei@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failurec-move-clear_hwpoisoned_pages.patch removed from -mm tree
Message-Id: <20220513192229.23656C34117@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure.c: move clear_hwpoisoned_pages
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-move-clear_hwpoisoned_pages.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zhenwei pi <pizhenwei@bytedance.com>
Subject: mm/memory-failure.c: move clear_hwpoisoned_pages

Patch series "memory-failure: fix hwpoison_filter", v2.

As well known, the memory failure mechanism handles memory corrupted
event, and try to send SIGBUS to the user process which uses this
corrupted page.

For the virtualization case, QEMU catches SIGBUS and tries to inject MCE
into the guest, and the guest handles memory failure again.  Thus the
guest gets the minimal effect from hardware memory corruption.

The further step I'm working on:

1, try to modify code to decrease poisoned pages in a single place
   (mm/memofy-failure.c: simplify num_poisoned_pages_dec in this series).

2, try to use page_handle_poison() to handle SetPageHWPoison() and
   num_poisoned_pages_inc() together.  It would be best to call
   num_poisoned_pages_inc() in a single place too.

3, introduce memory failure notifier list in memory-failure.c: notify
   the corrupted PFN to someone who registers this list.  If I can
   complete [1] and [2] part, [3] will be quite easy(just call notifier
   list after increasing poisoned page).

4, introduce memory recover VQ for memory balloon device, and registers
   memory failure notifier list.  During the guest kernel handles memory
   failure, balloon device gets notified by memory failure notifier list,
   and tells the host to recover the corrupted PFN(GPA) by the new VQ.

5, host side remaps the corrupted page(HVA), and tells the guest side
   to unpoison the PFN(GPA).  Then the guest fixes the corrupted page(GPA)
   dynamically.


This patch (of 5):

clear_hwpoisoned_pages() clears HWPoison flag and decreases the number of
poisoned pages, this actually works as part of memory failure.

Move this function from sparse.c to memory-failure.c, finally there is no
CONFIG_MEMORY_FAILURE in sparse.c.

Link: https://lkml.kernel.org/r/20220509105641.491313-1-pizhenwei@bytedance.com
Link: https://lkml.kernel.org/r/20220509105641.491313-2-pizhenwei@bytedance.com
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h       |   11 +++++++++++
 mm/memory-failure.c |   21 +++++++++++++++++++++
 mm/sparse.c         |   27 ---------------------------
 3 files changed, 32 insertions(+), 27 deletions(-)

--- a/mm/internal.h~mm-memory-failurec-move-clear_hwpoisoned_pages
+++ a/mm/internal.h
@@ -711,6 +711,9 @@ static inline int find_next_best_node(in
 }
 #endif
 
+/*
+ * mm/memory-failure.c
+ */
 extern int hwpoison_filter(struct page *p);
 
 extern u32 hwpoison_filter_dev_major;
@@ -720,6 +723,14 @@ extern u64 hwpoison_filter_flags_value;
 extern u64 hwpoison_filter_memcg;
 extern u32 hwpoison_filter_enable;
 
+#ifdef CONFIG_MEMORY_FAILURE
+void clear_hwpoisoned_pages(struct page *memmap, int nr_pages);
+#else
+static inline void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
+{
+}
+#endif
+
 extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
--- a/mm/memory-failure.c~mm-memory-failurec-move-clear_hwpoisoned_pages
+++ a/mm/memory-failure.c
@@ -2379,3 +2379,24 @@ retry:
 
 	return ret;
 }
+
+void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
+{
+	int i;
+
+	/*
+	 * A further optimization is to have per section refcounted
+	 * num_poisoned_pages.  But that would need more space per memmap, so
+	 * for now just do a quick global check to speed up this routine in the
+	 * absence of bad pages.
+	 */
+	if (atomic_long_read(&num_poisoned_pages) == 0)
+		return;
+
+	for (i = 0; i < nr_pages; i++) {
+		if (PageHWPoison(&memmap[i])) {
+			num_poisoned_pages_dec();
+			ClearPageHWPoison(&memmap[i]);
+		}
+	}
+}
--- a/mm/sparse.c~mm-memory-failurec-move-clear_hwpoisoned_pages
+++ a/mm/sparse.c
@@ -922,33 +922,6 @@ int __meminit sparse_add_section(int nid
 	return 0;
 }
 
-#ifdef CONFIG_MEMORY_FAILURE
-static void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
-{
-	int i;
-
-	/*
-	 * A further optimization is to have per section refcounted
-	 * num_poisoned_pages.  But that would need more space per memmap, so
-	 * for now just do a quick global check to speed up this routine in the
-	 * absence of bad pages.
-	 */
-	if (atomic_long_read(&num_poisoned_pages) == 0)
-		return;
-
-	for (i = 0; i < nr_pages; i++) {
-		if (PageHWPoison(&memmap[i])) {
-			num_poisoned_pages_dec();
-			ClearPageHWPoison(&memmap[i]);
-		}
-	}
-}
-#else
-static inline void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
-{
-}
-#endif
-
 void sparse_remove_section(struct mem_section *ms, unsigned long pfn,
 		unsigned long nr_pages, unsigned long map_offset,
 		struct vmem_altmap *altmap)
_

Patches currently in -mm which might be from pizhenwei@bytedance.com are


