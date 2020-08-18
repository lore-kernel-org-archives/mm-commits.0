Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB114C433E4
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CADE7207BB
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790450;
	bh=w1+Gc0kQQr+jVln/PJh7NgUA2LCpwZXRergCsZBe9u0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=nZvqNlftqro0lzIGetYcbRyf9K2PDxgOFVF9Pt7qsoShSYPt+rDpk8JozU+kJWJIi
	 pU1PzCINqHEIKDsczmSrLacawse8dQEfPnSKGWSdubbd8V/ik6s02EUJhLPVctyZFM
	 RviZTBEneKsm4rm3oHADB0ZDELrcvVgeycw+5b0Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgHRWku (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbgHRWks (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:40:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9922E20786;
        Tue, 18 Aug 2020 22:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790447;
        bh=w1+Gc0kQQr+jVln/PJh7NgUA2LCpwZXRergCsZBe9u0=;
        h=Date:From:To:Subject:From;
        b=af78BosqgOUygthGo/HPr0+JXxoct0kks8IV2C7kqeIHavWdzruTB39bPd8PVHZ+o
         MzxPGqICJCvsSM4ElOxhN+QbwD03BZstpIlCGbU6inR/bYwFFJQTWsrjDMsxNB/fOn
         Q2dNaacXmLsN6M8fXAIlqpdsuvBSnKCpm/zkGKvU=
Date:   Tue, 18 Aug 2020 15:40:47 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, elver@google.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-page_io-mark-various-intentional-data-races.patch removed from -mm tree
Message-ID: <20200818224047.Ds6b19P7p%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io: mark various intentional data races
has been removed from the -mm tree.  Its filename was
     mm-page_io-mark-various-intentional-data-races.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/page_io: mark various intentional data races

struct swap_info_struct si.flags could be accessed concurrently as noticed
by KCSAN,

 BUG: KCSAN: data-race in scan_swap_map_slots / swap_readpage

 write to 0xffff9c77b80ac400 of 8 bytes by task 91325 on cpu 16:
  scan_swap_map_slots+0x6fe/0xb50
  scan_swap_map_slots at mm/swapfile.c:887
  get_swap_pages+0x39d/0x5c0
  get_swap_page+0x377/0x524
  add_to_swap+0xe4/0x1c0
  shrink_page_list+0x1740/0x2820
  shrink_inactive_list+0x316/0x8b0
  shrink_lruvec+0x8dc/0x1380
  shrink_node+0x317/0xd80
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

 read to 0xffff9c77b80ac400 of 8 bytes by task 5422 on cpu 7:
  swap_readpage+0x204/0x6a0
  swap_readpage at mm/page_io.c:380
  read_swap_cache_async+0xa2/0xb0
  swapin_readahead+0x6a0/0x890
  do_swap_page+0x465/0xeb0
  __handle_mm_fault+0xc7a/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 7 PID: 5422 Comm: gmain Tainted: G        W  O L 5.5.0-next-20200204+ #6
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019

Other reads,

 read to 0xffff91ea33eac400 of 8 bytes by task 11276 on cpu 120:
  __swap_writepage+0x140/0xc20
  __swap_writepage at mm/page_io.c:289

 read to 0xffff91ea33eac400 of 8 bytes by task 11264 on cpu 16:
  swap_set_page_dirty+0x44/0x1f4
  swap_set_page_dirty at mm/page_io.c:442

The write is under &si->lock, but the reads are done as lockless.  Since
the reads only check for a specific bit in the flag, it is harmless even
if load tearing happens.  Thus, just mark them as intentional data races
using the data_race() macro.

[cai@lca.pw: add a missing annotation]
  Link: http://lkml.kernel.org/r/1581612585-5812-1-git-send-email-cai@lca.pw
Link: http://lkml.kernel.org/r/20200207003601.1526-1-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_io.c~mm-page_io-mark-various-intentional-data-races
+++ a/mm/page_io.c
@@ -85,7 +85,7 @@ static void swap_slot_free_notify(struct
 		return;
 
 	sis = page_swap_info(page);
-	if (!(sis->flags & SWP_BLKDEV))
+	if (data_race(!(sis->flags & SWP_BLKDEV)))
 		return;
 
 	/*
@@ -302,7 +302,7 @@ int __swap_writepage(struct page *page,
 	struct swap_info_struct *sis = page_swap_info(page);
 
 	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
-	if (sis->flags & SWP_FS) {
+	if (data_race(sis->flags & SWP_FS)) {
 		struct kiocb kiocb;
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
@@ -393,7 +393,7 @@ int swap_readpage(struct page *page, boo
 		goto out;
 	}
 
-	if (sis->flags & SWP_FS) {
+	if (data_race(sis->flags & SWP_FS)) {
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
 
@@ -455,7 +455,7 @@ int swap_set_page_dirty(struct page *pag
 {
 	struct swap_info_struct *sis = page_swap_info(page);
 
-	if (sis->flags & SWP_FS) {
+	if (data_race(sis->flags & SWP_FS)) {
 		struct address_space *mapping = sis->swap_file->f_mapping;
 
 		VM_BUG_ON_PAGE(!PageSwapCache(page), page);
_

Patches currently in -mm which might be from cai@lca.pw are

fork-silence-a-false-postive-warning-in-__mmdrop.patch

