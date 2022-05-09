Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79AA8C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  9 May 2022 23:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbiEIXW6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 19:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbiEIXW5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 19:22:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264AD1F35E0
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 16:19:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF4976120C
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 23:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F15C385B3;
        Mon,  9 May 2022 23:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652138341;
        bh=wfxNo09T9DQs+oHumQ0YSh0hMJO1W/Gitknq+dLGEIw=;
        h=Date:To:From:Subject:From;
        b=1B3MovdxcQApVKfVH0yb9mp32P7cx9l1Ba2+UaPLXi8RY9dFFNVW8Sc48I9b2/d5k
         513Jj43W20ReQRgm+eblmcYpOC8wcWh++VFi3kPU08R5qzW7YrA9bnGd+0CLr9eZZh
         7p/Je73LhJMxYkduc8w8MGx2eqSDgGdESPM/eFGo=
Date:   Mon, 09 May 2022 16:19:00 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        pizhenwei@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-move-clear_hwpoisoned_pages.patch added to mm-unstable branch
Message-Id: <20220509231901.12F15C385B3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: move clear_hwpoisoned_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failurec-move-clear_hwpoisoned_pages.patch

This patch should soon appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -709,6 +709,9 @@ static inline int find_next_best_node(in
 }
 #endif
 
+/*
+ * mm/memory-failure.c
+ */
 extern int hwpoison_filter(struct page *p);
 
 extern u32 hwpoison_filter_dev_major;
@@ -718,6 +721,14 @@ extern u64 hwpoison_filter_flags_value;
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

mm-memory-failurec-move-clear_hwpoisoned_pages.patch
mm-memory-failurec-simplify-num_poisoned_pages_dec.patch
mm-memory-failurec-add-hwpoison_filter-for-soft-offline.patch
mm-hwpoison-disable-hwpoison-filter-during-removing.patch
mm-memory-failurec-simplify-num_poisoned_pages_inc-dec.patch

