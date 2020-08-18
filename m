Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6425C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4B2E20786
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790464;
	bh=O4lXj3gIZwLn8fZZM7PLn6cqkTOvdHj91MfS/6MLsKg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dSqYFWzyKOZmoGPPAFT/KuKGa0ZztQDSNHtuQYVFi3EkSbkVMTL97FYDdQKViUkqz
	 MTZFPbjOdqsJHvbc3zk71vJ16QgTCAhdebqdOgkSR+S+R71qZECmk+IqRGA1EgvfqP
	 44XCSKB7AKet/i59kURgShvCGEoQaIGz2nh7lAow=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgHRWlE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:41:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbgHRWlD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:41:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 978FC20674;
        Tue, 18 Aug 2020 22:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790462;
        bh=O4lXj3gIZwLn8fZZM7PLn6cqkTOvdHj91MfS/6MLsKg=;
        h=Date:From:To:Subject:From;
        b=TIWb7gLYwNLEpQJ21WVitQbSEArqR/hoIfvUqb7JxfJxHAiYkERirMSTLPRTNC8HB
         P+l65/LrNnTL3DJql2euuoLNAJy0Q2SUnaDOBnapixzmh5O5QJh5cbegrYAVH1Os4c
         wFdshGeMjMrEhs+tYfOnMdmRWqcCgmyVCbOklHbI=
Date:   Tue, 18 Aug 2020 15:41:02 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, elver@google.com, konrad.wilk@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch removed from -mm
 tree
Message-ID: <20200818224102.1uEinGcP1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/list_lru: fix a data race in list_lru_count_one
has been removed from the -mm tree.  Its filename was
     mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/list_lru: fix a data race in list_lru_count_one

struct list_lru_one l.nr_items could be accessed concurrently as noticed
by KCSAN,

 BUG: KCSAN: data-race in list_lru_count_one / list_lru_isolate_move

 write to 0xffffa102789c4510 of 8 bytes by task 823 on cpu 39:
  list_lru_isolate_move+0xf9/0x130
  list_lru_isolate_move at mm/list_lru.c:180
  inode_lru_isolate+0x12b/0x2a0
  __list_lru_walk_one+0x122/0x3d0
  list_lru_walk_one+0x75/0xa0
  prune_icache_sb+0x8b/0xc0
  super_cache_scan+0x1b8/0x250
  do_shrink_slab+0x256/0x6d0
  shrink_slab+0x41b/0x4a0
  shrink_node+0x35c/0xd80
  balance_pgdat+0x652/0xd90
  kswapd+0x396/0x8d0
  kthread+0x1e0/0x200
  ret_from_fork+0x27/0x50

 read to 0xffffa102789c4510 of 8 bytes by task 6345 on cpu 56:
  list_lru_count_one+0x116/0x2f0
  list_lru_count_one at mm/list_lru.c:193
  super_cache_count+0xe8/0x170
  do_shrink_slab+0x95/0x6d0
  shrink_slab+0x41b/0x4a0
  shrink_node+0x35c/0xd80
  do_try_to_free_pages+0x1f7/0xa10
  try_to_free_pages+0x26c/0x5e0
  __alloc_pages_slowpath+0x458/0x1290
  __alloc_pages_nodemask+0x3bb/0x450
  alloc_pages_vma+0x8a/0x2c0
  do_anonymous_page+0x170/0x700
  __handle_mm_fault+0xc9f/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 56 PID: 6345 Comm: oom01 Tainted: G        W    L 5.5.0-next-20200205+ #4
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019

A shattered l.nr_items could affect the shrinker behaviour due to a data
race. Fix it by adding READ_ONCE() for the read. Since the writes are
aligned and up to word-size, assume those are safe from data races to
avoid readability issues of writing WRITE_ONCE(var, var + val).

Link: http://lkml.kernel.org/r/1581114679-5488-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/list_lru.c~mm-list_lru-fix-a-data-race-in-list_lru_count_one
+++ a/mm/list_lru.c
@@ -180,7 +180,7 @@ unsigned long list_lru_count_one(struct
 
 	rcu_read_lock();
 	l = list_lru_from_memcg_idx(nlru, memcg_cache_id(memcg));
-	count = l->nr_items;
+	count = READ_ONCE(l->nr_items);
 	rcu_read_unlock();
 
 	return count;
_

Patches currently in -mm which might be from cai@lca.pw are

fork-silence-a-false-postive-warning-in-__mmdrop.patch

