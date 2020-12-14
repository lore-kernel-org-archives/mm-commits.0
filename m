Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE2F5C4361B
	for <mm-commits@archiver.kernel.org>; Mon, 14 Dec 2020 23:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57CB822518
	for <mm-commits@archiver.kernel.org>; Mon, 14 Dec 2020 23:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgLNXXC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 18:23:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730210AbgLNXWz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 18:22:55 -0500
Date:   Mon, 14 Dec 2020 15:22:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607988135;
        bh=UHFy/JwoQ80ZtyONeG5FsMXSYvNgC3SCZRxFOaumoKY=;
        h=From:To:Subject:From;
        b=z/0xDErSK+sipV23umNl0dCq64qMOfDprnyx8H7aQu84DIn0C0c6Xc3PzRTbAq8gl
         E7hyI3wEUi9GxsD/sAmU00Beip+Iwf/TjSoqUwS4PuTgTLpTuiAijmLvYj7fX5HhtD
         DKCpejKHPNylrTzGC5jqI5ti7csGIJE2OsIlgeS8=
From:   akpm@linux-foundation.org
To:     david@redhat.com, longman@redhat.com, mm-commits@vger.kernel.org,
        urezki@gmail.com, willy@infradead.org
Subject:  + mm-vmalloc-fix-unlock-order-in-s_stop.patch added to
 -mm tree
Message-ID: <20201214232214.jHwkjUbuw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: Fix unlock order in s_stop()
has been added to the -mm tree.  Its filename is
     mm-vmalloc-fix-unlock-order-in-s_stop.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-fix-unlock-order-in-s_stop.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-fix-unlock-order-in-s_stop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/vmalloc: Fix unlock order in s_stop()

When multiple locks are acquired, they should be released in reverse
order. For s_start() and s_stop() in mm/vmalloc.c, that is not the
case.

  s_start: mutex_lock(&vmap_purge_lock); spin_lock(&vmap_area_lock);
  s_stop : mutex_unlock(&vmap_purge_lock); spin_unlock(&vmap_area_lock);

This unlock sequence, though allowed, is not optimal. If a waiter is
present, mutex_unlock() will need to go through the slowpath of waking
up the waiter with preemption disabled. Fix that by releasing the
spinlock first before the mutex.

Link: https://lkml.kernel.org/r/20201213180843.16938-1-longman@redhat.com
Fixes: e36176be1c39 ("mm/vmalloc: rework vmap_area_lock")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-unlock-order-in-s_stop
+++ a/mm/vmalloc.c
@@ -3465,11 +3465,11 @@ static void *s_next(struct seq_file *m,
 }
 
 static void s_stop(struct seq_file *m, void *p)
-	__releases(&vmap_purge_lock)
 	__releases(&vmap_area_lock)
+	__releases(&vmap_purge_lock)
 {
-	mutex_unlock(&vmap_purge_lock);
 	spin_unlock(&vmap_area_lock);
+	mutex_unlock(&vmap_purge_lock);
 }
 
 static void show_numa_info(struct seq_file *m, struct vm_struct *v)
_

Patches currently in -mm which might be from longman@redhat.com are

mm-vmalloc-fix-unlock-order-in-s_stop.patch

