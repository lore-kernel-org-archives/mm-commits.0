Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE190C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B94F207DE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790450;
	bh=HAte+QC2L/2iMc9KkeHBrn8UPyDVHnep69zLRrSW0qg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=hO/1JE71ATpojV7DpliY/becHMAx3PRhmtyh6USUUvRAqYqPXlD+CEL/JYhL+45v7
	 in15GZCfgpe//MiHsICdiO+bcLtQ1U3QgvUm+5lCtk/s8eY1YchhTaOJC0dti9blZ0
	 0/j3AaVedh9gIDxGeWyXUNZ54mK7RUcS91OiRz0M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgHRWku (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgHRWkq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:40:46 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CF2D207BB;
        Tue, 18 Aug 2020 22:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790445;
        bh=HAte+QC2L/2iMc9KkeHBrn8UPyDVHnep69zLRrSW0qg=;
        h=Date:From:To:Subject:From;
        b=I0kH4JTUFLdiIzn25uJgDnQu/jiLfrQKNb/n0l356U8ZZazlSMI/GGTsPdP+4yYsI
         YtPSjflDDzazAxY9rYul+H4xYGNQR3TqeWvH++s3BRuNP5IEOvEQab5uE2rJLIvYke
         0F7lHe5c34qd+4euQpmPVQXuQfIwq9FOCU+s9+SM=
Date:   Tue, 18 Aug 2020 15:40:45 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, elver@google.com, konrad.wilk@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-frontswap-mark-various-intentional-data-races.patch removed from -mm
 tree
Message-ID: <20200818224045.TpfKiUg7V%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/frontswap: mark various intentional data races
has been removed from the -mm tree.  Its filename was
     mm-frontswap-mark-various-intentional-data-races.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from cai@lca.pw are

fork-silence-a-false-postive-warning-in-__mmdrop.patch

