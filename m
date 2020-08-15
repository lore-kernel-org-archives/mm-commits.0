Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 099A9C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB83120658
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529493;
	bh=aqws28JJVcpKMu9AjldogCr+vnx1tTc5ASzbWJZLHdY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=0wj+2j496e2PEWju8eCM0sr+8381nSKwDLtLPaPHq0ocvWX0l3xju6GQzDN1FYDk0
	 4myvC7IABDVJ+nxDQjYJlhPOzSFhx993Y2bXgHwInZxXYMnpSKekMWiPK599J6b2qd
	 YiJ2VreGA3oEE1PhObZuig75XLtVSUYzr6Fh39AA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgHOWLT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:11:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729444AbgHOWKa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48A5A22D73;
        Sat, 15 Aug 2020 00:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451511;
        bh=aqws28JJVcpKMu9AjldogCr+vnx1tTc5ASzbWJZLHdY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eYu9GZMkWxaYlYne6CO8EJ+VMT2phN3TRSzMmp2NRDY90mkxJAx6JMvG2cYgQFvFh
         nS2MSBqaSRfdP1SqPaAnRzMkaCI+ztloJ1bhGtWCU9MSnz5Bxj0etCvm63e6aDan2T
         1RgWNC1EadiosgLhCrm8WsX8AqzwGOnVqQfo0Vr4=
Date:   Fri, 14 Aug 2020 17:31:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, elver@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 31/39] mm/swap.c: annotate data races for
 lru_rotate_pvecs
Message-ID: <20200815003150.-aDiYh9vd%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Subject: mm/swap.c: annotate data races for lru_rotate_pvecs

Read to lru_add_pvec->nr could be interrupted and then write to the same
variable.  The write has local interrupt disabled, but the plain reads
result in data races.  However, it is unlikely the compilers could do much
damage here given that lru_add_pvec->nr is a "unsigned char" and there is
an existing compiler barrier.  Thus, annotate the reads using the
data_race() macro.  The data races were reported by KCSAN,

 BUG: KCSAN: data-race in lru_add_drain_cpu / rotate_reclaimable_page

 write to 0xffff9291ebcb8a40 of 1 bytes by interrupt on cpu 23:
  rotate_reclaimable_page+0x2df/0x490
  pagevec_add at include/linux/pagevec.h:81
  (inlined by) rotate_reclaimable_page at mm/swap.c:259
  end_page_writeback+0x1b5/0x2b0
  end_swap_bio_write+0x1d0/0x280
  bio_endio+0x297/0x560
  dec_pending+0x218/0x430 [dm_mod]
  clone_endio+0xe4/0x2c0 [dm_mod]
  bio_endio+0x297/0x560
  blk_update_request+0x201/0x920
  scsi_end_request+0x6b/0x4a0
  scsi_io_completion+0xb7/0x7e0
  scsi_finish_command+0x1ed/0x2a0
  scsi_softirq_done+0x1c9/0x1d0
  blk_done_softirq+0x181/0x1d0
  __do_softirq+0xd9/0x57c
  irq_exit+0xa2/0xc0
  do_IRQ+0x8b/0x190
  ret_from_intr+0x0/0x42
  delay_tsc+0x46/0x80
  __const_udelay+0x3c/0x40
  __udelay+0x10/0x20
  kcsan_setup_watchpoint+0x202/0x3a0
  __tsan_read1+0xc2/0x100
  lru_add_drain_cpu+0xb8/0x3f0
  lru_add_drain+0x25/0x40
  shrink_active_list+0xe1/0xc80
  shrink_lruvec+0x766/0xb70
  shrink_node+0x2d6/0xca0
  do_try_to_free_pages+0x1f7/0x9a0
  try_to_free_pages+0x252/0x5b0
  __alloc_pages_slowpath+0x458/0x1290
  __alloc_pages_nodemask+0x3bb/0x450
  alloc_pages_vma+0x8a/0x2c0
  do_anonymous_page+0x16e/0x6f0
  __handle_mm_fault+0xcd5/0xd40
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 read to 0xffff9291ebcb8a40 of 1 bytes by task 37761 on cpu 23:
  lru_add_drain_cpu+0xb8/0x3f0
  lru_add_drain_cpu at mm/swap.c:602
  lru_add_drain+0x25/0x40
  shrink_active_list+0xe1/0xc80
  shrink_lruvec+0x766/0xb70
  shrink_node+0x2d6/0xca0
  do_try_to_free_pages+0x1f7/0x9a0
  try_to_free_pages+0x252/0x5b0
  __alloc_pages_slowpath+0x458/0x1290
  __alloc_pages_nodemask+0x3bb/0x450
  alloc_pages_vma+0x8a/0x2c0
  do_anonymous_page+0x16e/0x6f0
  __handle_mm_fault+0xcd5/0xd40
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 2 locks held by oom02/37761:
  #0: ffff9281e5928808 (&mm->mmap_sem#2){++++}, at: do_page_fault
  #1: ffffffffb3ade380 (fs_reclaim){+.+.}, at: fs_reclaim_acquire.part
 irq event stamp: 1949217
 trace_hardirqs_on_thunk+0x1a/0x1c
 __do_softirq+0x2e7/0x57c
 __do_softirq+0x34c/0x57c
 irq_exit+0xa2/0xc0

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 23 PID: 37761 Comm: oom02 Not tainted 5.6.0-rc3-next-20200226+ #6
 Hardware name: HP ProLiant BL660c Gen9, BIOS I38 10/17/2018

Link: http://lkml.kernel.org/r/20200228044018.1263-1-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/swap.c~mm-swap-annotate-data-races-for-lru_rotate_pvecs
+++ a/mm/swap.c
@@ -632,7 +632,8 @@ void lru_add_drain_cpu(int cpu)
 		__pagevec_lru_add(pvec);
 
 	pvec = &per_cpu(lru_rotate.pvec, cpu);
-	if (pagevec_count(pvec)) {
+	/* Disabling interrupts below acts as a compiler barrier. */
+	if (data_race(pagevec_count(pvec))) {
 		unsigned long flags;
 
 		/* No harm done if a racing interrupt already did this */
@@ -793,7 +794,7 @@ void lru_add_drain_all(void)
 		struct work_struct *work = &per_cpu(lru_add_drain_work, cpu);
 
 		if (pagevec_count(&per_cpu(lru_pvecs.lru_add, cpu)) ||
-		    pagevec_count(&per_cpu(lru_rotate.pvec, cpu)) ||
+		    data_race(pagevec_count(&per_cpu(lru_rotate.pvec, cpu))) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_deactivate_file, cpu)) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_deactivate, cpu)) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_lazyfree, cpu)) ||
_
