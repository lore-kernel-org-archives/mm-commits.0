Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB869C43381
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA2A464F32
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhBZBSc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:18:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:50454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230037AbhBZBSb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:18:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86AD564EFA;
        Fri, 26 Feb 2021 01:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302270;
        bh=v/poSp92orn9KHI9WuRgQy6e4fk6nUHJhVynuIVRwWw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FrfkHd5rsJjAVHRSc7mnxShsQpUKklSKWlysZ6E9dkYoE9QHTXpB0uo8fSPxMGxpR
         U4cP/ImhOrlgF7v+t85Zlqqj31jVs2SYqLD2jrsiknK2pvVyJ23ULQAavV1jLQIucr
         NR2xmGG7Bn/3RvTQGNBTVIxhlPXTcJ0CqlQyW7sA=
Date:   Thu, 25 Feb 2021 17:17:49 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 039/118] mm/mlock: stop counting mlocked pages
 when none vma is found
Message-ID: <20210226011749.qhl2IJCLc%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mlock: stop counting mlocked pages when none vma is found

There will be no vma satisfies addr < vm_end when find_vma() returns NULL.
Thus it's meaningless to traverse the vma list below because we can't
find any vma to count mlocked pages.  Stop counting mlocked pages in this
case to save some vma list traversal cycles.

Link: https://lkml.kernel.org/r/20210204110705.17586-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mlock.c~mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found
+++ a/mm/mlock.c
@@ -622,7 +622,7 @@ static unsigned long count_mm_mlocked_pa
 
 	vma = find_vma(mm, start);
 	if (vma == NULL)
-		vma = mm->mmap;
+		return 0;
 
 	for (; vma ; vma = vma->vm_next) {
 		if (start >= vma->vm_end)
_
