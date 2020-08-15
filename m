Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B74AC433E5
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E095520658
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529538;
	bh=yAdLEsYwmjmM0lcfPp3ukmdIBItN0Dwd1O3rQZ9YJoY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ABkTLPtatIZwWPDFtLwCmij75yWVAgF0Nv0es1Ci4FtldEdV5qShTRnQ23R+MHkwx
	 3FbUzaDuzn0VYaDHncf2CacJE2J10JdT0jRaeiZu/wOuWfBOyGq4eEZOW/wTFsUNML
	 FsN/DkLB+eLJbzjn/BF4xcE+O5xea6LSbkdMDVNU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgHOWMM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729160AbgHOWK2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0564D22CF7;
        Sat, 15 Aug 2020 00:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451485;
        bh=yAdLEsYwmjmM0lcfPp3ukmdIBItN0Dwd1O3rQZ9YJoY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QTgazgYm6GPcpwfPX6QMP807aitoRBU+1tAS8QFZCacElDpvgvhNIxpLilImkaRrr
         5Q+oQa1T76TDoLccbbMifg/fFnck7/RPsJv3lMMcLxuD4mqYBZ1tgHuVxm5PtpYkj/
         Nt2afhatoI/4y10beGcf3hIB1FnkE7VWUjYu0qfw=
Date:   Fri, 14 Aug 2020 17:31:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, elver@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 23/39] mm/swap_state: mark various intentional
 data races
Message-ID: <20200815003124.3RbdiMBNy%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Subject: mm/swap_state: mark various intentional data races

swap_cache_info.* could be accessed concurrently as noticed by
KCSAN,

 BUG: KCSAN: data-race in lookup_swap_cache / lookup_swap_cache

 write to 0xffffffff85517318 of 8 bytes by task 94138 on cpu 101:
  lookup_swap_cache+0x12e/0x460
  lookup_swap_cache at mm/swap_state.c:322
  do_swap_page+0x112/0xeb0
  __handle_mm_fault+0xc7a/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 read to 0xffffffff85517318 of 8 bytes by task 91655 on cpu 100:
  lookup_swap_cache+0x117/0x460
  lookup_swap_cache at mm/swap_state.c:322
  shmem_swapin_page+0xc7/0x9e0
  shmem_getpage_gfp+0x2ca/0x16c0
  shmem_fault+0xef/0x3c0
  __do_fault+0x9e/0x220
  do_fault+0x4a0/0x920
  __handle_mm_fault+0xc69/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 100 PID: 91655 Comm: systemd-journal Tainted: G        W  O L 5.5.0-next-20200204+ #6
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019

 write to 0xffffffff8d717308 of 8 bytes by task 11365 on cpu 87:
   __delete_from_swap_cache+0x681/0x8b0
   __delete_from_swap_cache at mm/swap_state.c:178

 read to 0xffffffff8d717308 of 8 bytes by task 11275 on cpu 53:
   __delete_from_swap_cache+0x66e/0x8b0
   __delete_from_swap_cache at mm/swap_state.c:178

Both the read and write are done as lockless. Since swap_cache_info.*
are only used to print out counter information, even if any of them
missed a few incremental due to data races, it will be harmless, so just
mark it as an intentional data race using the data_race() macro.

While at it, fix a checkpatch.pl warning,

WARNING: Single statement macros should not use a do {} while (0) loop

Link: http://lkml.kernel.org/r/20200207003715.1578-1-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swap_state.c~mm-swap_state-mark-various-intentional-data-races
+++ a/mm/swap_state.c
@@ -57,8 +57,8 @@ static bool enable_vma_readahead __read_
 #define GET_SWAP_RA_VAL(vma)					\
 	(atomic_long_read(&(vma)->swap_readahead_info) ? : 4)
 
-#define INC_CACHE_INFO(x)	do { swap_cache_info.x++; } while (0)
-#define ADD_CACHE_INFO(x, nr)	do { swap_cache_info.x += (nr); } while (0)
+#define INC_CACHE_INFO(x)	data_race(swap_cache_info.x++)
+#define ADD_CACHE_INFO(x, nr)	data_race(swap_cache_info.x += (nr))
 
 static struct {
 	unsigned long add_total;
_
