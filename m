Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30B5EC433E1
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ABE820674
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790468;
	bh=v00CXhPoa8n87djpW36OUfFt76rTCckjkGfYEEUXyik=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Mg4BAZ/2hitEymNcghVz63+azdyhUaMMH96z1UZhSJMxmhcRGGaC8ONfP3R1lLvR1
	 2TyACxi5fOvoFVtK6z8hfah9SEGO1FcMJV4i7sAv0itv+P7DsyPIYFSEWhTDv6r34J
	 JYY+0fkTRdDAofO+Ozzoq8RfaMUCj6kF0OZKydP0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgHRWlH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbgHRWlG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:41:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68ECA20786;
        Tue, 18 Aug 2020 22:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790465;
        bh=v00CXhPoa8n87djpW36OUfFt76rTCckjkGfYEEUXyik=;
        h=Date:From:To:Subject:From;
        b=HtayFH6BPyMRyyirlaYAwM7WzWY4JztpAFVgPvDFdFk1hWsSQN1Nv6FUGtv6IrT0S
         kvGJvJaibhHlI68doAwwrbIWQKRCkP53MtC8UNC0TLR9WZvd3ctPPZtcZlNjfobc9b
         KhDCgFUvgEhBqK25crFbhZdxEotdFbAevqJb5+Ls=
Date:   Tue, 18 Aug 2020 15:41:05 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, elver@google.com, mm-commits@vger.kernel.org,
        oleg@redhat.com, tj@kernel.org
Subject:  [merged] mm-mempool-fix-a-data-race-in-mempool_free.patch
 removed from -mm tree
Message-ID: <20200818224105.AY-Tzt6ym%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempool: fix a data race in mempool_free()
has been removed from the -mm tree.  Its filename was
     mm-mempool-fix-a-data-race-in-mempool_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/mempool: fix a data race in mempool_free()

mempool_t pool.curr_nr could be accessed concurrently as noticed by
KCSAN,

 BUG: KCSAN: data-race in mempool_free / remove_element

 write to 0xffffffffa937638c of 4 bytes by task 6359 on cpu 113:
  remove_element+0x4a/0x1c0
  remove_element at mm/mempool.c:132
  mempool_alloc+0x102/0x210
  (inlined by) mempool_alloc at mm/mempool.c:399
  bio_alloc_bioset+0x106/0x2c0
  get_swap_bio+0x49/0x230
  __swap_writepage+0x680/0xc30
  swap_writepage+0x9c/0xf0
  pageout+0x33e/0xae0
  shrink_page_list+0x1f57/0x2870
  shrink_inactive_list+0x316/0x880
  shrink_lruvec+0x8dc/0x1380
  shrink_node+0x317/0xd80
  do_try_to_free_pages+0x1f7/0xa10
  try_to_free_pages+0x26c/0x5e0
  __alloc_pages_slowpath+0x458/0x1290
  <snip>

 read to 0xffffffffa937638c of 4 bytes by interrupt on cpu 64:
  mempool_free+0x3e/0x150
  mempool_free at mm/mempool.c:492
  bio_free+0x192/0x280
  bio_put+0x91/0xd0
  end_swap_bio_write+0x1d8/0x280
  bio_endio+0x2c2/0x5b0
  dec_pending+0x22b/0x440 [dm_mod]
  clone_endio+0xe4/0x2c0 [dm_mod]
  bio_endio+0x2c2/0x5b0
  blk_update_request+0x217/0x940
  scsi_end_request+0x6b/0x4d0
  scsi_io_completion+0xb7/0x7e0
  scsi_finish_command+0x223/0x310
  scsi_softirq_done+0x1d5/0x210
  blk_mq_complete_request+0x224/0x250
  scsi_mq_done+0xc2/0x250
  pqi_raid_io_complete+0x5a/0x70 [smartpqi]
  pqi_irq_handler+0x150/0x1410 [smartpqi]
  __handle_irq_event_percpu+0x90/0x540
  handle_irq_event_percpu+0x49/0xd0
  handle_irq_event+0x85/0xca
  handle_edge_irq+0x13f/0x3e0
  do_IRQ+0x86/0x190
  <snip>

Since the write is under pool->lock but the read is done as lockless.
Even though the commit 5b990546e334 ("mempool: fix and document
synchronization and memory barrier usage") introduced the smp_wmb() and
smp_rmb() pair to improve the situation, it is adequate to protect it
from data races which could lead to a logic bug, so fix it by adding
READ_ONCE() for the read.

Link: http://lkml.kernel.org/r/1581446384-2131-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempool.c~mm-mempool-fix-a-data-race-in-mempool_free
+++ a/mm/mempool.c
@@ -489,7 +489,7 @@ void mempool_free(void *element, mempool
 	 * ensures that there will be frees which return elements to the
 	 * pool waking up the waiters.
 	 */
-	if (unlikely(pool->curr_nr < pool->min_nr)) {
+	if (unlikely(READ_ONCE(pool->curr_nr) < pool->min_nr)) {
 		spin_lock_irqsave(&pool->lock, flags);
 		if (likely(pool->curr_nr < pool->min_nr)) {
 			add_element(pool, element);
_

Patches currently in -mm which might be from cai@lca.pw are

fork-silence-a-false-postive-warning-in-__mmdrop.patch

