Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE073C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBBC161D0C
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhF2CmL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231332AbhF2CmJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:42:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96ED961D0B;
        Tue, 29 Jun 2021 02:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934381;
        bh=+aCj5/RM4lkIJrL2GwwRVolQVoQvXDwSN1R9UFrYHZk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rjftJrd8M/zLSU9adDRKcNGENVelWeqzjHDJ8j+atml0GDRcRNpBdlgUc3h/2GlU3
         c5Z634hO5h/Osy+OuMfk8nr9HsLd9Pcgtdbp7GLqaMsn+teog5EafZ8u7XCHpcIVAf
         xAR01a9rKfLfijCECdZME7i7+Nd7Vj5ZeMG+Do8A=
Date:   Mon, 28 Jun 2021 19:39:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 122/192] mm/ksm: use vma_lookup() in
 find_mergeable_vma()
Message-ID: <20210629023941.qnRzcMWbt%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/ksm: use vma_lookup() in find_mergeable_vma()

Use vma_lookup() to find the VMA at a specific address.  As vma_lookup()
will return NULL if the address is not within any VMA, the start address
no longer needs to be validated.

Link: https://lkml.kernel.org/r/20210521174745.2219620-19-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/ksm.c~mm-ksm-use-vma_lookup-in-find_mergeable_vma
+++ a/mm/ksm.c
@@ -521,10 +521,8 @@ static struct vm_area_struct *find_merge
 	struct vm_area_struct *vma;
 	if (ksm_test_exit(mm))
 		return NULL;
-	vma = find_vma(mm, addr);
-	if (!vma || vma->vm_start > addr)
-		return NULL;
-	if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
+	vma = vma_lookup(mm, addr);
+	if (!vma || !(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 		return NULL;
 	return vma;
 }
_
