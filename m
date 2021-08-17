Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5737C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 19:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2076600CC
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 19:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhHQT00 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Aug 2021 15:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229905AbhHQT00 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 17 Aug 2021 15:26:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8139F61008;
        Tue, 17 Aug 2021 19:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629228352;
        bh=tKuiQ4cV7JgrYDIZwj4efHr+SfQqUaOpVkB8oAKWuKo=;
        h=Date:From:To:Subject:From;
        b=c5v9C06Oe08zvjZ+SCxdNyOXfzKpGJiB7x7CtBoXc39zpSioAmrpMBa90oDjr9VwC
         RkY3hQv0C3xYVin52mZQbQMsh+YHubUKU7izUtPwTihNmK2C59mrV48HzBqrH6XaQ8
         73aFvNTPU34vjecqqm4r5VWaiK+YsEZKKUf8ZAYA=
Date:   Tue, 17 Aug 2021 12:25:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, david@redhat.com,
        Liam.Howlett@Oracle.com
Subject:  + remap_file_pages-use-vma_lookup-instead-of-find_vma.patch
 added to -mm tree
Message-ID: <20210817192552.rX2JQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: remap_file_pages: Use vma_lookup() instead of find_vma()
has been added to the -mm tree.  Its filename is
     remap_file_pages-use-vma_lookup-instead-of-find_vma.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/remap_file_pages-use-vma_lookup-instead-of-find_vma.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/remap_file_pages-use-vma_lookup-instead-of-find_vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: remap_file_pages: Use vma_lookup() instead of find_vma()

Using vma_lookup() verifies the start address is contained in the found vma.
This results in easier to read code.

Link: https://lkml.kernel.org/r/20210817135234.1550204-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/mmap.c~remap_file_pages-use-vma_lookup-instead-of-find_vma
+++ a/mm/mmap.c
@@ -2994,14 +2994,11 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
-	vma = find_vma(mm, start);
+	vma = vma_lookup(mm, start);
 
 	if (!vma || !(vma->vm_flags & VM_SHARED))
 		goto out;
 
-	if (start < vma->vm_start)
-		goto out;
-
 	if (start + size > vma->vm_end) {
 		struct vm_area_struct *next;
 
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

remap_file_pages-use-vma_lookup-instead-of-find_vma.patch

