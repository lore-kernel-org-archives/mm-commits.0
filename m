Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B0F8C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 01:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26A586113C
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 01:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348988AbhIIBLY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 21:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232144AbhIIBLX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Sep 2021 21:11:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D43C06115B;
        Thu,  9 Sep 2021 01:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631149815;
        bh=/9pv/r9BWGmiBey+HnWkIU5WStMqrGIXoJe6gr4uRTY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2hRaMkqVD8GZSV6IZefBP2HJLZimclhC6lcj0PmmudZi4r2TG5QWYZKyUJO30zGV7
         /8lOWJqgcDOiCpxNHoBRL8sgJWquEUuEaNvg7zutnHf9XzTTfLTpYJAEORJghRizYp
         rHvwrOuaftXH+E/9hn9aPSa58b/mrQxMXdu+93a4=
Date:   Wed, 08 Sep 2021 18:10:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, Liam.Howlett@oracle.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org, vbabka@suse.cz,
        walken.cr@gmail.com, willy@infradead.org
Subject:  [patch 5/8] mmap_lock: change trace and locking order
Message-ID: <20210909011014.JJu-mAZB6%akpm@linux-foundation.org>
In-Reply-To: <20210908180859.d523d4bb4ad8eec11c61500d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
