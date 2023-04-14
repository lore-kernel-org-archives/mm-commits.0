Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0301DC77B72
	for <mm-commits@archiver.kernel.org>; Fri, 14 Apr 2023 19:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjDNT6e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Apr 2023 15:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjDNT6d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Apr 2023 15:58:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B65F72A5
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 12:58:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9912F616A1
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 19:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDE9C433D2;
        Fri, 14 Apr 2023 19:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681502303;
        bh=pAQ1WFi+6zHKGCc+fzfVCLbUGd9kRrKrqrbxTmBw01k=;
        h=Date:To:From:Subject:From;
        b=nUQ04ybNxaYW6sZMOIA8qAdB7/aH5C3zjHtyyCmgiay5Oq1EaIaAwU6QQGq63wPZ0
         /ixvQS5Q2CtScU/aBC3rqhBJGPkkmqojF1m4Do9tbeCOqsWuQyA0St4FlHN3qgrt8d
         0ESAzqBlu+bKC6w7gWezbJDJDVYbLcLdp1Zo+WXQ=
Date:   Fri, 14 Apr 2023 12:58:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        punit.agrawal@bytedance.com, minchan@google.com,
        michel@lespinasse.org, mhocko@suse.com, lstoakes@gmail.com,
        Liam.Howlett@Oracle.com, ldufour@linux.ibm.com,
        josef@toxicpanda.com, jack@suse.cz, hannes@cmpxchg.org,
        dave@stgolabs.net, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-swap-page-faults-if-the-faulting-page-can-be-locked.patch added to mm-unstable branch
Message-Id: <20230414195822.EEDE9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: handle swap page faults if the faulting page can be locked
has been added to the -mm mm-unstable branch.  Its filename is
     mm-handle-swap-page-faults-if-the-faulting-page-can-be-locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-handle-swap-page-faults-if-the-faulting-page-can-be-locked.patch

This patch will later appear in the mm-unstable branch at
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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: handle swap page faults if the faulting page can be locked
Date: Fri, 14 Apr 2023 11:00:43 -0700

When page fault is handled under VMA lock protection, all swap page faults
are retried with mmap_lock because folio_lock_or_retry implementation has
to drop and reacquire mmap_lock if folio could not be immediately locked.

Instead of retrying all swapped page faults, retry only when folio locking
fails.

Link: https://lkml.kernel.org/r/20230414180043.1839745-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Minchan Kim <minchan@google.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 ++++++
 mm/memory.c  |    5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/mm/filemap.c~mm-handle-swap-page-faults-if-the-faulting-page-can-be-locked
+++ a/mm/filemap.c
@@ -1706,6 +1706,8 @@ static int __folio_lock_async(struct fol
  *     mmap_lock has been released (mmap_read_unlock(), unless flags had both
  *     FAULT_FLAG_ALLOW_RETRY and FAULT_FLAG_RETRY_NOWAIT set, in
  *     which case mmap_lock is still held.
+ *     If flags had FAULT_FLAG_VMA_LOCK set, meaning the operation is performed
+ *     with VMA lock only, the VMA lock is still held.
  *
  * If neither ALLOW_RETRY nor KILLABLE are set, will always return true
  * with the folio locked and the mmap_lock unperturbed.
@@ -1713,6 +1715,10 @@ static int __folio_lock_async(struct fol
 bool __folio_lock_or_retry(struct folio *folio, struct mm_struct *mm,
 			 unsigned int flags)
 {
+	/* Can't do this if not holding mmap_lock */
+	if (flags & FAULT_FLAG_VMA_LOCK)
+		return false;
+
 	if (fault_flag_allow_retry_first(flags)) {
 		/*
 		 * CAUTION! In this case, mmap_lock is not released
--- a/mm/memory.c~mm-handle-swap-page-faults-if-the-faulting-page-can-be-locked
+++ a/mm/memory.c
@@ -3700,11 +3700,6 @@ vm_fault_t do_swap_page(struct vm_fault
 	if (!pte_unmap_same(vmf))
 		goto out;
 
-	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-		ret = VM_FAULT_RETRY;
-		goto out;
-	}
-
 	entry = pte_to_swp_entry(vmf->orig_pte);
 	if (unlikely(non_swap_entry(entry))) {
 		if (is_migration_entry(entry)) {
_

Patches currently in -mm which might be from surenb@google.com are

mm-do-not-increment-pgfault-stats-when-page-fault-handler-retries.patch
mm-handle-swap-page-faults-if-the-faulting-page-can-be-locked.patch

