Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322D3C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1001E6101A
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239024AbhICVtr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:49:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235948AbhICVtr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:49:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5DAE60FD7;
        Fri,  3 Sep 2021 21:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630705726;
        bh=JI+jrUBSAiSlVfPfdtdkEwySi4ElILwanMPzLVFSlvQ=;
        h=Date:From:To:Subject:From;
        b=YMUmENcpZSMonvGilXT8GxVjXReJvLg//rzNuzjKQyNDgj+mYRFYDjI0qDi/pZkFQ
         CtDFXu4SR978ISh4gx1oa82iHF8sfCYXpIfeSYnLqyiW9j4EgGWsUa5MGDxzHAObQX
         6t2eveUs/DD2dQzDAB0vRSTnk74hHI8h1f1h6ZLw=
Date:   Fri, 03 Sep 2021 14:48:46 -0700
From:   akpm@linux-foundation.org
To:     Liam.Howlett@oracle.com, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, vbabka@suse.cz, walken.cr@gmail.com,
        willy@infradead.org
Subject:  + mmap_lock-change-trace-and-locking-order.patch added to
 -mm tree
Message-ID: <20210903214846.ZFlM5NTib%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap_lock: change trace and locking order
has been added to the -mm tree.  Its filename is
     mmap_lock-change-trace-and-locking-order.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmap_lock-change-trace-and-locking-order.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmap_lock-change-trace-and-locking-order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mmap_lock: change trace and locking order

Print to the trace log before releasing the lock to avoid racing with
other trace log printers of the same lock type.

Link: https://lkml.kernel.org/r/20210903022041.1843024-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michel Lespinasse <walken.cr@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/mmap_lock.h~mmap_lock-change-trace-and-locking-order
+++ a/include/linux/mmap_lock.h
@@ -101,14 +101,14 @@ static inline bool mmap_write_trylock(st
 
 static inline void mmap_write_unlock(struct mm_struct *mm)
 {
-	up_write(&mm->mmap_lock);
 	__mmap_lock_trace_released(mm, true);
+	up_write(&mm->mmap_lock);
 }
 
 static inline void mmap_write_downgrade(struct mm_struct *mm)
 {
-	downgrade_write(&mm->mmap_lock);
 	__mmap_lock_trace_acquire_returned(mm, false, true);
+	downgrade_write(&mm->mmap_lock);
 }
 
 static inline void mmap_read_lock(struct mm_struct *mm)
@@ -140,8 +140,8 @@ static inline bool mmap_read_trylock(str
 
 static inline void mmap_read_unlock(struct mm_struct *mm)
 {
-	up_read(&mm->mmap_lock);
 	__mmap_lock_trace_released(mm, false);
+	up_read(&mm->mmap_lock);
 }
 
 static inline bool mmap_read_trylock_non_owner(struct mm_struct *mm)
@@ -155,8 +155,8 @@ static inline bool mmap_read_trylock_non
 
 static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
 {
-	up_read_non_owner(&mm->mmap_lock);
 	__mmap_lock_trace_released(mm, false);
+	up_read_non_owner(&mm->mmap_lock);
 }
 
 static inline void mmap_assert_locked(struct mm_struct *mm)
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

mmap_lock-change-trace-and-locking-order.patch

