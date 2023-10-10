Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F55FCD8CAC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Oct 2023 18:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbjJJSSB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Oct 2023 14:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbjJJSR7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2023 14:17:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B02F99
        for <mm-commits@vger.kernel.org>; Tue, 10 Oct 2023 11:17:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33ACC433C7;
        Tue, 10 Oct 2023 18:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696961876;
        bh=ScO7NzRcqdOHhiIdRWWABRrK16iMPziJ0C2+1tIxyaw=;
        h=Date:To:From:Subject:From;
        b=1GnPKL5TRyD1UZrRcNQ91dEEq0TnCojtFqexB8Q6wZyA+5ij4Yr4jbBoXc2lF1a/O
         9ndRjEbVsXe0VsQfsamvij6gJE64/xizp+XLo/Bxf0WjYcnD/f/SdL52WrwN7FrX7Q
         PczE06iOkdjjGqLSxs5/M4uWJrubMtt2hvkU6xJ4=
Date:   Tue, 10 Oct 2023 11:17:46 -0700
To:     mm-commits@vger.kernel.org, vschneid@redhat.com,
        vincent.guittot@linaro.org, sclaibin@gmail.com,
        rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com,
        mingo@kernel.org, mgorman@suse.de, juri.lelli@redhat.com,
        dietmar.eggemann@arm.com, bsegall@google.com, bristot@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-remove-use-of-wait-bookmarks.patch added to mm-unstable branch
Message-Id: <20231010181753.A33ACC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: remove use of wait bookmarks
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-remove-use-of-wait-bookmarks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-remove-use-of-wait-bookmarks.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: filemap: remove use of wait bookmarks
Date: Tue, 10 Oct 2023 04:58:28 +0100

The original problem of the overly long list of waiters on a locked page
was solved properly by commit 9a1ea439b16b ("mm:
put_and_wait_on_page_locked() while page is migrated").  In the meantime,
using bookmarks for the writeback bit can cause livelocks, so we need to
stop using them.

Link: https://lkml.kernel.org/r/20231010035829.544242-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Bin Lai <sclaibin@gmail.com>
Cc: Benjamin Segall <bsegall@google.com>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>

Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

--- a/mm/filemap.c~filemap-remove-use-of-wait-bookmarks
+++ a/mm/filemap.c
@@ -1133,32 +1133,13 @@ static void folio_wake_bit(struct folio
 	wait_queue_head_t *q = folio_waitqueue(folio);
 	struct wait_page_key key;
 	unsigned long flags;
-	wait_queue_entry_t bookmark;
 
 	key.folio = folio;
 	key.bit_nr = bit_nr;
 	key.page_match = 0;
 
-	bookmark.flags = 0;
-	bookmark.private = NULL;
-	bookmark.func = NULL;
-	INIT_LIST_HEAD(&bookmark.entry);
-
 	spin_lock_irqsave(&q->lock, flags);
-	__wake_up_locked_key_bookmark(q, TASK_NORMAL, &key, &bookmark);
-
-	while (bookmark.flags & WQ_FLAG_BOOKMARK) {
-		/*
-		 * Take a breather from holding the lock,
-		 * allow pages that finish wake up asynchronously
-		 * to acquire the lock and remove themselves
-		 * from wait queue
-		 */
-		spin_unlock_irqrestore(&q->lock, flags);
-		cpu_relax();
-		spin_lock_irqsave(&q->lock, flags);
-		__wake_up_locked_key_bookmark(q, TASK_NORMAL, &key, &bookmark);
-	}
+	__wake_up_locked_key(q, TASK_NORMAL, &key);
 
 	/*
 	 * It's possible to miss clearing waiters here, when we woke our page
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch
iomap-hold-state_lock-over-call-to-ifs_set_range_uptodate.patch
iomap-protect-read_bytes_pending-with-the-state_lock.patch
mm-add-folio_end_read.patch
ext4-use-folio_end_read.patch
buffer-use-folio_end_read.patch
iomap-use-folio_end_read.patch
bitops-add-xor_unlock_is_negative_byte.patch
alpha-implement-xor_unlock_is_negative_byte.patch
m68k-implement-xor_unlock_is_negative_byte.patch
mips-implement-xor_unlock_is_negative_byte.patch
powerpc-implement-arch_xor_unlock_is_negative_byte-on-32-bit.patch
riscv-implement-xor_unlock_is_negative_byte.patch
s390-implement-arch_xor_unlock_is_negative_byte.patch
mm-delete-checks-for-xor_unlock_is_negative_byte.patch
mm-add-folio_xor_flags_has_waiters.patch
mm-make-__end_folio_writeback-return-void.patch
mm-use-folio_xor_flags_has_waiters-in-folio_end_writeback.patch
filemap-remove-use-of-wait-bookmarks.patch
sched-remove-wait-bookmarks.patch

