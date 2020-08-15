Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86AA6C433E1
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FF7020639
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529428;
	bh=300TX3BW4JF/M1NtlqVfgh+XcTDpipSoIUZnqUY+JhY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=YXLTEoduVK/K05JNdP5z0M7/Jz/XH2Ni36XWvtAMUnjlvxdRqTH25HaIUUHztx9zY
	 NoBxmi2Bsqun3/9+EWzCF2lTmm93Y6k7ijfgR/7dUFF0DKv4t/H2Tlc7UtWsosjFJY
	 JSG7zZ4c9948H/CtGKgPlP9grMTlg+2PLnE7/bbQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgHOWK1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728577AbgHOWKZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AF6422D03;
        Sat, 15 Aug 2020 00:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451477;
        bh=300TX3BW4JF/M1NtlqVfgh+XcTDpipSoIUZnqUY+JhY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MTnxfXEoIKhSxTe3Krd02jzeSen+V6fq++ugrdGJCuTNZKWILJU53VOvkskWhzP6z
         cPWHMde5LPMxwntqfzCx260GbeZWpZUV/C+n3AUTDlpxz61tJBibeIPUEcFfQWYhMp
         W0VftYaQ554H3t5DGJIggp8/RQQ/ouP1LkLy85xk=
Date:   Fri, 14 Aug 2020 17:31:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, elver@google.com,
        konrad.wilk@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 21/39] mm/frontswap: mark various intentional data
 races
Message-ID: <20200815003117.BucP58b9F%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Subject: mm/frontswap: mark various intentional data races

There are a few information counters that are intentionally not protected
against increment races, so just annotate them using the data_race()
macro.

 BUG: KCSAN: data-race in __frontswap_store / __frontswap_store

 write to 0xffffffff8b7174d8 of 8 bytes by task 6396 on cpu 103:
  __frontswap_store+0x2d0/0x344
  inc_frontswap_failed_stores at mm/frontswap.c:70
  (inlined by) __frontswap_store at mm/frontswap.c:280
  swap_writepage+0x83/0xf0
  pageout+0x33e/0xae0
  shrink_page_list+0x1f57/0x2870
  shrink_inactive_list+0x316/0x880
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

 read to 0xffffffff8b7174d8 of 8 bytes by task 6405 on cpu 47:
  __frontswap_store+0x2b9/0x344
  inc_frontswap_failed_stores at mm/frontswap.c:70
  (inlined by) __frontswap_store at mm/frontswap.c:280
  swap_writepage+0x83/0xf0
  pageout+0x33e/0xae0
  shrink_page_list+0x1f57/0x2870
  shrink_inactive_list+0x316/0x880
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

Link: http://lkml.kernel.org/r/1581114499-5042-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frontswap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/frontswap.c~mm-frontswap-mark-various-intentional-data-races
+++ a/mm/frontswap.c
@@ -61,16 +61,16 @@ static u64 frontswap_failed_stores;
 static u64 frontswap_invalidates;
 
 static inline void inc_frontswap_loads(void) {
-	frontswap_loads++;
+	data_race(frontswap_loads++);
 }
 static inline void inc_frontswap_succ_stores(void) {
-	frontswap_succ_stores++;
+	data_race(frontswap_succ_stores++);
 }
 static inline void inc_frontswap_failed_stores(void) {
-	frontswap_failed_stores++;
+	data_race(frontswap_failed_stores++);
 }
 static inline void inc_frontswap_invalidates(void) {
-	frontswap_invalidates++;
+	data_race(frontswap_invalidates++);
 }
 #else
 static inline void inc_frontswap_loads(void) { }
_
