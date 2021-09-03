Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 476A2C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32AD1610E9
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349675AbhICVCm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350231AbhICVCk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:02:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C40A610CC;
        Fri,  3 Sep 2021 21:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702900;
        bh=fdhn/TOjWRSEK3pDEPHHufT+XoL9z0eEzEL+1lGj6dU=;
        h=Date:From:To:Subject:From;
        b=MfguJ3ImWN5lSfZHgzkUtqS01M79BMajjcVlVdY9XqvcE0QILVqQh7IDyz0Ean309
         LZfRsgVnTg7LUq2lc3h66Ns9zzU8Du3n+20hJzjcplmbXcInD41gSx5C1JuMInGtDF
         PLWDODVMq0hKqKDKp2kbP/r9LMh5S2Prg08xwRIE=
Date:   Fri, 03 Sep 2021 14:01:40 -0700
From:   akpm@linux-foundation.org
To:     jingxiangfeng@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 percpu-remove-obsolete-comments-of-pcpu_chunk_populated.patch removed from
 -mm tree
Message-ID: <20210903210140.iYEJikNzJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/percpu,c: remove obsolete comments of pcpu_chunk_populated()
has been removed from the -mm tree.  Its filename was
     percpu-remove-obsolete-comments-of-pcpu_chunk_populated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from jingxiangfeng@huawei.com are


