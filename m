Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52E1C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DBB3610FB
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349849AbhICU7k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346630AbhICU7j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6693561107;
        Fri,  3 Sep 2021 20:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702719;
        bh=5MLiYakO7PbrL3sgt52wtcvWQys3e5xCXmJG1nOQbbQ=;
        h=Date:From:To:Subject:From;
        b=amNkkkYIuREDjPQcMQDzxgxFehkG0PzHwn109fXpzL4lklT3WkEp1NnnR36MVdzDp
         hSjUQPxy9NgFWQ75OH8Ok1AS5LbOJZhUen5iNYez4iRJh5+AAbeO0/pJsJuP0o7GP9
         jS6kTlUnVjn2eXncBvLI1geX7731NSmU2oUr+EOw=
Date:   Fri, 03 Sep 2021 13:58:39 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 remap_file_pages-use-vma_lookup-instead-of-find_vma.patch removed from -mm
 tree
Message-ID: <20210903205839._9k-EXlpQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: remap_file_pages: Use vma_lookup() instead of find_vma()
has been removed from the -mm tree.  Its filename was
     remap_file_pages-use-vma_lookup-instead-of-find_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


