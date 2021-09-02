Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B51C5C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C496610E6
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347977AbhIBWB7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347666AbhIBWB7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:01:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9852E60724;
        Thu,  2 Sep 2021 22:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630620060;
        bh=CLtFb++Mu/z8fbion96dPJZGKntclMGAvH3hOSDlFxk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=D50K3tlQb4n1q9Ha7n9b1TSSqTUM8q6qMNJytqhva+mQGRwnNxr6kTvpUmbI942m9
         iEcc99zZo1oqTsV1o2wvLiY39IG4kDVBo+Gaowy5tzXwQIM+3dBb5oCO1Wd8IjPVwf
         VH9HPMbPPvvvQ7FWRkt7R1t4zhj585wG6D0IuwGY=
Date:   Thu, 02 Sep 2021 15:01:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jingxiangfeng@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 208/212] mm/percpu,c: remove obsolete comments of
 pcpu_chunk_populated()
Message-ID: <20210902220100.eH80X7Pbd%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>
Subject: mm/percpu,c: remove obsolete comments of pcpu_chunk_populated()

Commit b239f7daf553 ("percpu: set PCPU_BITMAP_BLOCK_SIZE to PAGE_SIZE")
removed the parameter 'for_alloc', so remove this comment.

Link: https://lkml.kernel.org/r/1630576043-21367-1-git-send-email-jingxiangfeng@huawei.com
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/percpu.c~percpu-remove-obsolete-comments-of-pcpu_chunk_populated
+++ a/mm/percpu.c
@@ -1520,9 +1520,6 @@ static void pcpu_free_chunk(struct pcpu_
  * Pages in [@page_start,@page_end) have been populated to @chunk.  Update
  * the bookkeeping information accordingly.  Must be called after each
  * successful population.
- *
- * If this is @for_alloc, do not increment pcpu_nr_empty_pop_pages because it
- * is to serve an allocation in that area.
  */
 static void pcpu_chunk_populated(struct pcpu_chunk *chunk, int page_start,
 				 int page_end)
_
