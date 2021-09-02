Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5454C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 18:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DBB1610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 18:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347090AbhIBSxP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 14:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230204AbhIBSxN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 14:53:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C62F8610A2;
        Thu,  2 Sep 2021 18:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630608734;
        bh=4TyNDtBMDyYJXjeRSlkqzwQ/alsO9eA+9GJG4KRYYEM=;
        h=Date:From:To:Subject:From;
        b=P1jUj9ou87IAf4fKjTyVj8HWju9pggV6rnC0MUH6evLsPny5yzM5sutqZXPj2MAd/
         axfOIbOJ01WUFO/Dn9GiQ9o5xwCLdkSCNqIm5Cd9l1GSjudlGjWCOj1DcXz2UQ2anR
         oMTu9BO2F9wXpVMunZDbH3J/q+VbaEX1JwG9xyQY=
Date:   Thu, 02 Sep 2021 11:52:14 -0700
From:   akpm@linux-foundation.org
To:     jingxiangfeng@huawei.com, mm-commits@vger.kernel.org
Subject:  +
 percpu-remove-obsolete-comments-of-pcpu_chunk_populated.patch added to -mm
 tree
Message-ID: <20210902185214.oe5yE6woL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/percpu,c: remove obsolete comments of pcpu_chunk_populated()
has been added to the -mm tree.  Its filename is
     percpu-remove-obsolete-comments-of-pcpu_chunk_populated.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/percpu-remove-obsolete-comments-of-pcpu_chunk_populated.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/percpu-remove-obsolete-comments-of-pcpu_chunk_populated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

percpu-remove-obsolete-comments-of-pcpu_chunk_populated.patch

