Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16CBBC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C444F64F26
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbhBXUG2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:06:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:56868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235292AbhBXUFv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BF1C64F14;
        Wed, 24 Feb 2021 20:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197070;
        bh=GpUPPlkFhzr/eMBBQFJLDCF7K0yl2WxELSQlNxSfFuA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nYb66waLHLpFS9yg5VkpYOdoB+sm/HmP+cKOlotu4OFiV1OLyBh4FOT9oP04QPKTC
         VYDqiT3Kr1xqZEne7IteqjZKTzpjDYKAkCLkRZZwi0XLBz9EtQ5cxhU909Q2x2HpCw
         gTfZ26v+kzmj7qsK7Rj+p4L3R5+qatVx45XEfx+A=
Date:   Wed, 24 Feb 2021 12:04:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     ahuang12@lenovo.com, akpm@linux-foundation.org, david@redhat.com,
        jrdr.linux@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 076/173] mm/mmap.c: remove unnecessary local
 variable
Message-ID: <20210224200429.srHZRhLS0%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Adrian Huang <ahuang12@lenovo.com>
Subject: mm/mmap.c: remove unnecessary local variable

The local variable 'retval' is assigned just for once in __do_sys_brk(),
and the function returns the value of the local variable right after the
assignment.  Remove unnecessary assignment and local variable declaration.

Link: https://lkml.kernel.org/r/20201222103249.30683-1-adrianhuang0701@gmail.com
Signed-off-by: Adrian Huang <ahuang12@lenovo.com>
Acked-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mmap.c~mm-mmap-remove-unnecessary-local-variable
+++ a/mm/mmap.c
@@ -189,7 +189,6 @@ static int do_brk_flags(unsigned long ad
 		struct list_head *uf);
 SYSCALL_DEFINE1(brk, unsigned long, brk)
 {
-	unsigned long retval;
 	unsigned long newbrk, oldbrk, origbrk;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *next;
@@ -281,9 +280,8 @@ success:
 	return brk;
 
 out:
-	retval = origbrk;
 	mmap_write_unlock(mm);
-	return retval;
+	return origbrk;
 }
 
 static inline unsigned long vma_compute_gap(struct vm_area_struct *vma)
_
