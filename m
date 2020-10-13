Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D91C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24D1821D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633260;
	bh=Ebx2L2Y1HRRczpeCt9Wwu004i3fJgufpzEt0qa0b3L0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=b/I41CkbnkVUP37dHYYABLy26qdSi1Mx5CAPy595iuVV2+W9+nMsinxmZkb3I27YQ
	 RYIzt0jBe977/9ZDt/jyzXqLeTDym9RB+upSGcNUOClIDlPOGUFWxFvBTwOjtOezA9
	 /vqmXNvSI8hYK5dyaQ88awhfMbeYxVqD2w+kVFUk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729850AbgJMXyT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729795AbgJMXyT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:54:19 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 786E3221FF;
        Tue, 13 Oct 2020 23:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633258;
        bh=Ebx2L2Y1HRRczpeCt9Wwu004i3fJgufpzEt0qa0b3L0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=X2BsWT+IeCcYRAcCgGQP8i4J95U8gjif9v9S0pSIsLnvQzlN4zMDr7IOSC4ZDi37c
         ewZkWLRTYOXxJftCY836A4qKdYJVuaFvm5vTJpwLe2wEXpoa8qt/80ZRY3ujTtlxlJ
         R1HJSMxCh2JEP+XGdXsmGzC7u5oopTPRtlLtvsKg=
Date:   Tue, 13 Oct 2020 16:54:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, liao.pingfang@zte.com.cn,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, wang.yi59@zte.com.cn
Subject:  [patch 108/181] mm/mmap.c: replace do_brk with
 do_brk_flags in comment of insert_vm_struct()
Message-ID: <20201013235418.vYvVoCkei%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liao Pingfang <liao.pingfang@zte.com.cn>
Subject: mm/mmap.c: replace do_brk with do_brk_flags in comment of insert_vm_struct()

Replace do_brk with do_brk_flags in comment of insert_vm_struct(), since
do_brk was removed in following commit.

Link: https://lkml.kernel.org/r/1600650778-43230-1-git-send-email-wang.yi59@zte.com.cn
Fixes: bb177a732c4369 ("mm: do not bug_on on incorrect length in __mm_populate()")
Signed-off-by: Liao Pingfang <liao.pingfang@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmapc-replace-do_brk-with-do_brk_flags-in-comment-of-insert_vm_struct
+++ a/mm/mmap.c
@@ -3233,7 +3233,7 @@ int insert_vm_struct(struct mm_struct *m
 	 * By setting it to reflect the virtual start address of the
 	 * vma, merges and splits can happen in a seamless way, just
 	 * using the existing file pgoff checks and manipulations.
-	 * Similarly in do_mmap and in do_brk.
+	 * Similarly in do_mmap and in do_brk_flags.
 	 */
 	if (vma_is_anonymous(vma)) {
 		BUG_ON(vma->anon_vma);
_
