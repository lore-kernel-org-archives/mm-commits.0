Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4498EEE49AB
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbjHXXVs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235642AbjHXXVK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09285A1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EA3E64774
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD4AC433C8;
        Thu, 24 Aug 2023 23:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919267;
        bh=c4Yta9yq5ZLNfqTbAuCK8//KxiYhdUGKgNWDF1TSS8Q=;
        h=Date:To:From:Subject:From;
        b=Lx35Jq0cdoHz4qiDbdiRn0T6dp9dvaZnqrV/HAlw7Mwa+zgBJn2b27Scw+B4D7rk7
         VHvhx3sZdbfWbC+I7NMHU5o6pr2ph8SzqTB40Qe4q0uSjOpDA/i8rclV8w8yfMPfl8
         Tz7g4TJZCW2j5wTPeI6ksczL3GWDzX8SQUASaMAY=
Date:   Thu, 24 Aug 2023 16:21:06 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, punit.agrawal@bytedance.com, peterx@redhat.com,
        pasha.tatashin@soleen.com, minchan@google.com,
        michel@lespinasse.org, mhocko@suse.com, lstoakes@gmail.com,
        Liam.Howlett@oracle.com, ldufour@linux.ibm.com,
        josef@toxicpanda.com, jack@suse.cz, hughd@google.com,
        hdanton@sina.com, hch@lst.de, hannes@cmpxchg.org,
        dhowells@redhat.com, david@redhat.com, dave@stgolabs.net,
        brauner@kernel.org, apopple@nvidia.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-folio_lock_or_retry-to-use-vm_fault-directly.patch removed from -mm tree
Message-Id: <20230824232106.DAD4AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: change folio_lock_or_retry to use vm_fault directly
has been removed from the -mm tree.  Its filename was
     mm-change-folio_lock_or_retry-to-use-vm_fault-directly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: change folio_lock_or_retry to use vm_fault directly
Date: Fri, 30 Jun 2023 14:19:55 -0700

Change folio_lock_or_retry to accept vm_fault struct and return the
vm_fault_t directly.

Link: https://lkml.kernel.org/r/20230630211957.1341547-5-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Minchan Kim <minchan@google.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   11 ++++++-----
 mm/filemap.c            |   22 ++++++++++++----------
 mm/memory.c             |   14 ++++++--------
 3 files changed, 24 insertions(+), 23 deletions(-)

--- a/include/linux/pagemap.h~mm-change-folio_lock_or_retry-to-use-vm_fault-directly
+++ a/include/linux/pagemap.h
@@ -916,8 +916,7 @@ static inline bool wake_page_match(struc
 
 void __folio_lock(struct folio *folio);
 int __folio_lock_killable(struct folio *folio);
-bool __folio_lock_or_retry(struct folio *folio, struct mm_struct *mm,
-				unsigned int flags);
+vm_fault_t __folio_lock_or_retry(struct folio *folio, struct vm_fault *vmf);
 void unlock_page(struct page *page);
 void folio_unlock(struct folio *folio);
 
@@ -1021,11 +1020,13 @@ static inline int folio_lock_killable(st
  * Return value and mmap_lock implications depend on flags; see
  * __folio_lock_or_retry().
  */
-static inline bool folio_lock_or_retry(struct folio *folio,
-		struct mm_struct *mm, unsigned int flags)
+static inline vm_fault_t folio_lock_or_retry(struct folio *folio,
+					     struct vm_fault *vmf)
 {
 	might_sleep();
-	return folio_trylock(folio) || __folio_lock_or_retry(folio, mm, flags);
+	if (!folio_trylock(folio))
+		return __folio_lock_or_retry(folio, vmf);
+	return 0;
 }
 
 /*
--- a/mm/filemap.c~mm-change-folio_lock_or_retry-to-use-vm_fault-directly
+++ a/mm/filemap.c
@@ -1669,32 +1669,34 @@ static int __folio_lock_async(struct fol
 
 /*
  * Return values:
- * true - folio is locked; mmap_lock is still held.
- * false - folio is not locked.
+ * 0 - folio is locked.
+ * non-zero - folio is not locked.
  *     mmap_lock has been released (mmap_read_unlock(), unless flags had both
  *     FAULT_FLAG_ALLOW_RETRY and FAULT_FLAG_RETRY_NOWAIT set, in
  *     which case mmap_lock is still held.
  *
- * If neither ALLOW_RETRY nor KILLABLE are set, will always return true
+ * If neither ALLOW_RETRY nor KILLABLE are set, will always return 0
  * with the folio locked and the mmap_lock unperturbed.
  */
-bool __folio_lock_or_retry(struct folio *folio, struct mm_struct *mm,
-			 unsigned int flags)
+vm_fault_t __folio_lock_or_retry(struct folio *folio, struct vm_fault *vmf)
 {
+	struct mm_struct *mm = vmf->vma->vm_mm;
+	unsigned int flags = vmf->flags;
+
 	if (fault_flag_allow_retry_first(flags)) {
 		/*
 		 * CAUTION! In this case, mmap_lock is not released
-		 * even though return 0.
+		 * even though return VM_FAULT_RETRY.
 		 */
 		if (flags & FAULT_FLAG_RETRY_NOWAIT)
-			return false;
+			return VM_FAULT_RETRY;
 
 		mmap_read_unlock(mm);
 		if (flags & FAULT_FLAG_KILLABLE)
 			folio_wait_locked_killable(folio);
 		else
 			folio_wait_locked(folio);
-		return false;
+		return VM_FAULT_RETRY;
 	}
 	if (flags & FAULT_FLAG_KILLABLE) {
 		bool ret;
@@ -1702,13 +1704,13 @@ bool __folio_lock_or_retry(struct folio
 		ret = __folio_lock_killable(folio);
 		if (ret) {
 			mmap_read_unlock(mm);
-			return false;
+			return VM_FAULT_RETRY;
 		}
 	} else {
 		__folio_lock(folio);
 	}
 
-	return true;
+	return 0;
 }
 
 /**
--- a/mm/memory.c~mm-change-folio_lock_or_retry-to-use-vm_fault-directly
+++ a/mm/memory.c
@@ -3599,6 +3599,7 @@ static vm_fault_t remove_device_exclusiv
 	struct folio *folio = page_folio(vmf->page);
 	struct vm_area_struct *vma = vmf->vma;
 	struct mmu_notifier_range range;
+	vm_fault_t ret;
 
 	/*
 	 * We need a reference to lock the folio because we don't hold
@@ -3611,9 +3612,10 @@ static vm_fault_t remove_device_exclusiv
 	if (!folio_try_get(folio))
 		return 0;
 
-	if (!folio_lock_or_retry(folio, vma->vm_mm, vmf->flags)) {
+	ret = folio_lock_or_retry(folio, vmf);
+	if (ret) {
 		folio_put(folio);
-		return VM_FAULT_RETRY;
+		return ret;
 	}
 	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0,
 				vma->vm_mm, vmf->address & PAGE_MASK,
@@ -3738,7 +3740,6 @@ vm_fault_t do_swap_page(struct vm_fault
 	bool exclusive = false;
 	swp_entry_t entry;
 	pte_t pte;
-	int locked;
 	vm_fault_t ret = 0;
 	void *shadow = NULL;
 
@@ -3861,12 +3862,9 @@ vm_fault_t do_swap_page(struct vm_fault
 		goto out_release;
 	}
 
-	locked = folio_lock_or_retry(folio, vma->vm_mm, vmf->flags);
-
-	if (!locked) {
-		ret |= VM_FAULT_RETRY;
+	ret |= folio_lock_or_retry(folio, vmf);
+	if (ret & VM_FAULT_RETRY)
 		goto out_release;
-	}
 
 	if (swapcache) {
 		/*
_

Patches currently in -mm which might be from surenb@google.com are


