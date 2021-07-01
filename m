Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AAA5C11F6A
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5617B61468
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238486AbhGAByr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:54:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238416AbhGAByr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:54:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D49261241;
        Thu,  1 Jul 2021 01:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104337;
        bh=bIYmOeWvPd5sLcxcaDg8HxtQCgr2Nz9dnoQh5TQY8A4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NsO0qq7+uob/APMCgAknMeDeOyPOO/pO7GLWDB/Ku5qyXNGVAGFf5GhtkNt5aPLDe
         fjn+g4EHbc2xKyfsUA9ACPRkciYWDX0h7q3wtpFC/pJ6aqklzclwbKFMpEpZAqqZgm
         dsk3jWGbtBPFs+D5sqXw6ZzlEtrJjBo+KhcUUhRc=
Date:   Wed, 30 Jun 2021 18:52:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 096/192] mm/nommu: unexport do_munmap()
Message-ID: <20210701015217.qU-VNmZsg%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/nommu: unexport do_munmap()

do_munmap() does not take the mmap_write_lock().  vm_munmap() should be
used instead.

Link: https://lkml.kernel.org/r/20210604194002.648037-1-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/nommu.c~mm-nommu-unexport-do_munmap
+++ a/mm/nommu.c
@@ -1501,7 +1501,6 @@ erase_whole_vma:
 	delete_vma(mm, vma);
 	return 0;
 }
-EXPORT_SYMBOL(do_munmap);
 
 int vm_munmap(unsigned long addr, size_t len)
 {
_
