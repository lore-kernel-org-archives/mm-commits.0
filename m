Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC2EC11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D66661C71
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhF2CmH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231881AbhF2CmF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:42:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AC2B61C71;
        Tue, 29 Jun 2021 02:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934378;
        bh=95ovmkka8/jbMdzv4x+QbDL3d0RxKOT+mJpLJp7VGJU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FZ6dvBEFNVxOjWfGivxsu9frGOhR1QKJJbvwqb+W/awqLdoEnovBItvNJ4Vgr1xwY
         nsiuxl6HfvDdLzF5EBOQ5ofECBKe+vZDwxY+4vsbWfta+W5U4OT4h6mdAWhoib0jv4
         xkMw1dC+92/ZhP7CP5pBQ+ODFjCvBIX2MGg+MZXg=
Date:   Mon, 28 Jun 2021 19:39:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 121/192] lib/test_hmm: use vma_lookup() in
 dmirror_migrate()
Message-ID: <20210629023938.uGvDX_wr2%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: lib/test_hmm: use vma_lookup() in dmirror_migrate()

Use vma_lookup() to find the VMA at a specific address.  As vma_lookup()
will return NULL if the address is not within any VMA, the start address
no longer needs to be validated.

Link: https://lkml.kernel.org/r/20210521174745.2219620-18-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-use-vma_lookup-in-dmirror_migrate
+++ a/lib/test_hmm.c
@@ -686,9 +686,8 @@ static int dmirror_migrate(struct dmirro
 
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
-		vma = find_vma(mm, addr);
-		if (!vma || addr < vma->vm_start ||
-		    !(vma->vm_flags & VM_READ)) {
+		vma = vma_lookup(mm, addr);
+		if (!vma || !(vma->vm_flags & VM_READ)) {
 			ret = -EINVAL;
 			goto out;
 		}
_
