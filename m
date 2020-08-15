Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B1AC433E1
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A453F20639
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529568;
	bh=MYBuGX4EM984KP5tjQJgHfB6kY6rpo2Rh3486ZUjLyw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=EG3Q0D2BZjEZ6eQR9kQggwECo4e3NmmCiN14TMQqmqU6pvzfUWP2XdSBDrGiGivk9
	 XK5gciRFflUMbBa0GvDAeUQRYdL92GYRcoTcbux/2UZ4qnoIko0n0VRp6VUpcJ3i9Q
	 poriQlwv5UrZ6gAxWJOYN3k6YaqPsjP9fw1sG/hs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgHOWMp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728617AbgHOWK1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E1D822D74;
        Sat, 15 Aug 2020 00:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451508;
        bh=MYBuGX4EM984KP5tjQJgHfB6kY6rpo2Rh3486ZUjLyw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Hpy694CpyGwpE0HntkfjHmzJUPbZai68poGopZxCn2pRHYmKWtDrTA/VDk6rfEWM7
         QDtArkFiw3DTj1vdn5KHhywDRjHZBl+s5E8POMe4GgIm8zpy0vtFMfG2EjRIfq1vu9
         JGQrelKFvLAqeNcXI7+lPE1elKoh6tWRr/DY22g8=
Date:   Fri, 14 Aug 2020 17:31:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, elver@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 30/39] mm/rmap: annotate a data race at
 tlb_flush_batched
Message-ID: <20200815003147.tvfApJQ2K%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Subject: mm/rmap: annotate a data race at tlb_flush_batched

mm->tlb_flush_batched could be accessed concurrently as noticed by
KCSAN,

 BUG: KCSAN: data-race in flush_tlb_batched_pending / try_to_unmap_one

 write to 0xffff93f754880bd0 of 1 bytes by task 822 on cpu 6:
  try_to_unmap_one+0x59a/0x1ab0
  set_tlb_ubc_flush_pending at mm/rmap.c:635
  (inlined by) try_to_unmap_one at mm/rmap.c:1538
  rmap_walk_anon+0x296/0x650
  rmap_walk+0xdf/0x100
  try_to_unmap+0x18a/0x2f0
  shrink_page_list+0xef6/0x2870
  shrink_inactive_list+0x316/0x880
  shrink_lruvec+0x8dc/0x1380
  shrink_node+0x317/0xd80
  balance_pgdat+0x652/0xd90
  kswapd+0x396/0x8d0
  kthread+0x1e0/0x200
  ret_from_fork+0x27/0x50

 read to 0xffff93f754880bd0 of 1 bytes by task 6364 on cpu 4:
  flush_tlb_batched_pending+0x29/0x90
  flush_tlb_batched_pending at mm/rmap.c:682
  change_p4d_range+0x5dd/0x1030
  change_pte_range at mm/mprotect.c:44
  (inlined by) change_pmd_range at mm/mprotect.c:212
  (inlined by) change_pud_range at mm/mprotect.c:240
  (inlined by) change_p4d_range at mm/mprotect.c:260
  change_protection+0x222/0x310
  change_prot_numa+0x3e/0x60
  task_numa_work+0x219/0x350
  task_work_run+0xed/0x140
  prepare_exit_to_usermode+0x2cc/0x2e0
  ret_from_intr+0x32/0x42

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 4 PID: 6364 Comm: mtest01 Tainted: G        W    L 5.5.0-next-20200210+ #5
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019

flush_tlb_batched_pending() is under PTL but the write is not, but
mm->tlb_flush_batched is only a bool type, so the value is unlikely to be
shattered.  Thus, mark it as an intentional data race by using the data
race macro.

Link: http://lkml.kernel.org/r/1581450783-8262-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-annotate-a-data-race-at-tlb_flush_batched
+++ a/mm/rmap.c
@@ -672,7 +672,7 @@ static bool should_defer_flush(struct mm
  */
 void flush_tlb_batched_pending(struct mm_struct *mm)
 {
-	if (mm->tlb_flush_batched) {
+	if (data_race(mm->tlb_flush_batched)) {
 		flush_tlb_mm(mm);
 
 		/*
_
