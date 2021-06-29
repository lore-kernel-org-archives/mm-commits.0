Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A9FC11F69
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8BAC61D0E
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhF2ClM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231799AbhF2ClL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:41:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26E7F61D08;
        Tue, 29 Jun 2021 02:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934325;
        bh=NEMFESVlv2JJ8Yx2N/qXYXAn4JTb7arqsL99zzcaj4Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JKFZwD96zwpBcADkgrBUUagfvhbP8IQLruB0G9qqXxUPa5eSDJcneSSiVf4LP4b9x
         IfAmWrUPh6dIHSoE0UDYgWki7uLgVv0YjKCU4ILa0Njwwt3JI8HaGdnic6AOP/QAsg
         Hwgrp5bMcmtsShR446eX1ry0Iy3jgDfYGVriaT3c=
Date:   Mon, 28 Jun 2021 19:38:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, Liam.Howlett@Oracle.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 103/192] mm/mmap: use find_vma_intersection() in
 do_mmap() for overlap
Message-ID: <20210629023844.DMnemX3qz%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mmap: use find_vma_intersection() in do_mmap() for overlap

Using find_vma_intersection() avoids the need for a temporary variable and
makes the code cleaner.

Link: https://lkml.kernel.org/r/20210511014328.2902782-1-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-find_vma_intersection-in-do_mmap-for-overlap
+++ a/mm/mmap.c
@@ -1457,9 +1457,7 @@ unsigned long do_mmap(struct file *file,
 		return addr;
 
 	if (flags & MAP_FIXED_NOREPLACE) {
-		struct vm_area_struct *vma = find_vma(mm, addr);
-
-		if (vma && vma->vm_start < addr + len)
+		if (find_vma_intersection(mm, addr, addr + len))
 			return -EEXIST;
 	}
 
_
