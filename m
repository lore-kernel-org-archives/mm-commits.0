Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B71DDC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B99A20721
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgLODVo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:21:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgLODLP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:11:15 -0500
Date:   Mon, 14 Dec 2020 19:08:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001740;
        bh=9uiPdRLVZJkkDatTBi0orKDJ2WyYqfzle2A9x9h+fQ4=;
        h=From:To:Subject:In-Reply-To:From;
        b=QAoFMctC6khPgDvL4iTtjWIV1w1GeA5/gOR+nTMnpWCVOUQODBjyoLnj4YQpNjQeH
         1GW5tKotbwWQl1syh9HlFCaQn+wSgVRkWs384RqqA2glvpiDdner8Bbt0no4/DEQiI
         lZ6xsMyPPtBgYmH4icGxaCeUPefAD7FnuSE4LS2w=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        longman@redhat.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, urezki@gmail.com,
        willy@infradead.org
Subject:  [patch 098/200] mm/vmalloc: Fix unlock order in s_stop()
Message-ID: <20201215030859.OyhgKMLgu%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
