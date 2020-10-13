Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D15FC43467
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 614D322203
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633224;
	bh=+wRMsrYLlrTmt59/Ivc8UkwV9Ocvq9YUI/+bYo5eeHQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=kcNloqExWC3c7jb2kjr3BEAnto9/r6eA7H+5rWUPa3Xafw7dUEugSBAFf3CdDQgIt
	 NtIrAdgTQe2ggWuRhiY5R4FXiIGnG+oL8EfadqRyYdteQS1laXAbKFZTmVJWkoYwud
	 bkZvI6OkB3d6VrIYXipr+CMY3vlOWKkQXKCDBJ+4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729726AbgJMXxn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388140AbgJMXxk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:53:40 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE23B221FF;
        Tue, 13 Oct 2020 23:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633220;
        bh=+wRMsrYLlrTmt59/Ivc8UkwV9Ocvq9YUI/+bYo5eeHQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Cz7XVU7G2TvW+RFNKUgF78Wy+jKygYSDd7fglV5Vc11iVdbtFwKGRMN2kp2WcE23G
         s1KnIPlYVzKV7m9Uwp0L4cSw/viZhCcmhAO1JvLU4XO5gj1gFY9mgbfH7Zvoncs9iE
         wBjcvpiLOLWOG+5tl4UU2NaKZM7gTvadk6i/MSa4=
Date:   Tue, 13 Oct 2020 16:53:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        chinwen.chang@mediatek.com, daniel.kiss@arm.com,
        daniel.m.jordan@oracle.com, dbueso@suse.de, jgg@ziepe.ca,
        jimmyassarsson@gmail.com, ldufour@linux.ibm.com,
        linux-mm@kvack.org, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, songliubraving@fb.com,
        steven.price@arm.com, torvalds@linux-foundation.org,
        vbabka@suse.cz, walken@google.com, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 097/181] mmap locking API: add
 mmap_lock_is_contended()
Message-ID: <20201013235339.gjj60nUOW%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Chinwen Chang <chinwen.chang@mediatek.com>
Subject: mmap locking API: add mmap_lock_is_contended()

Patch series "Try to release mmap_lock temporarily in smaps_rollup", v4.

Recently, we have observed some janky issues caused by unpleasantly long
contention on mmap_lock which is held by smaps_rollup when probing large
processes.  To address the problem, we let smaps_rollup detect if anyone
wants to acquire mmap_lock for write attempts.  If yes, just release the
lock temporarily to ease the contention.

smaps_rollup is a procfs interface which allows users to summarize the
process's memory usage without the overhead of seq_* calls.  Android uses
it to sample the memory usage of various processes to balance its memory
pool sizes.  If no one wants to take the lock for write requests,
smaps_rollup with this patch will behave like the original one.

Although there are on-going mmap_lock optimizations like range-based
locks, the lock applied to smaps_rollup would be the coarse one, which is
hard to avoid the occurrence of aforementioned issues.  So the detection
and temporary release for write attempts on mmap_lock in smaps_rollup is
still necessary.


This patch (of 3):

Add new API to query if someone wants to acquire mmap_lock for write
attempts.

Using this instead of rwsem_is_contended makes it more tolerant of future
changes to the lock type.

Link: http://lkml.kernel.org/r/1597715898-3854-1-git-send-email-chinwen.chang@mediatek.com
Link: http://lkml.kernel.org/r/1597715898-3854-2-git-send-email-chinwen.chang@mediatek.com
Signed-off-by: Chinwen Chang <chinwen.chang@mediatek.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Acked-by: Michel Lespinasse <walken@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Daniel Kiss <daniel.kiss@arm.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jimmy Assarsson <jimmyassarsson@gmail.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/mmap_lock.h~mmap-locking-api-add-mmap_lock_is_contended
+++ a/include/linux/mmap_lock.h
@@ -87,4 +87,9 @@ static inline void mmap_assert_write_loc
 	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_lock), mm);
 }
 
+static inline int mmap_lock_is_contended(struct mm_struct *mm)
+{
+	return rwsem_is_contended(&mm->mmap_lock);
+}
+
 #endif /* _LINUX_MMAP_LOCK_H */
_
