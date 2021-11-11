Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1952BC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01F8760F46
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbhKKCpt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:45:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234183AbhKKCpr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:45:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C5C36113B;
        Thu, 11 Nov 2021 02:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598579;
        bh=AqNjxVKfDTkGU7RYrzQcxoG58TyGj4xslLTgKt+r8uM=;
        h=Date:From:To:Subject:From;
        b=z1Bf8R6lBvMfGsqQUMyWNnZlVyDvDb+NnyCK2fR2q6sQiVuAqVy7gfdBFCGlBSuAb
         JvWJ1Ri2Itys44TbJa7zLvUan8XvaraXdovjM80d0gCaypuBWa8VNFDZI9V2o8DTJg
         XUItpJooq+exnsqtqevgdt+fupda7VPvkPKlg1AA=
Date:   Wed, 10 Nov 2021 18:42:59 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, liu.song11@zte.com.cn,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-mprotectc-avoid-repeated-assignment-in-do_mprotect_pkey.patch removed
 from -mm tree
Message-ID: <20211111024259.Qkb7iquB5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect.c: avoid repeated assignment in do_mprotect_pkey()
has been removed from the -mm tree.  Its filename was
     mm-mprotectc-avoid-repeated-assignment-in-do_mprotect_pkey.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liu Song <liu.song11@zte.com.cn>
Subject: mm/mprotect.c: avoid repeated assignment in do_mprotect_pkey()

After adjustment, the repeated assignment of "prev" is avoided, and the
readability of the code is improved.

Link: https://lkml.kernel.org/r/20211012152444.4127-1-fishland@aliyun.com
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Liu Song <liu.song11@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/mprotect.c~mm-mprotectc-avoid-repeated-assignment-in-do_mprotect_pkey
+++ a/mm/mprotect.c
@@ -563,7 +563,7 @@ static int do_mprotect_pkey(unsigned lon
 	error = -ENOMEM;
 	if (!vma)
 		goto out;
-	prev = vma->vm_prev;
+
 	if (unlikely(grows & PROT_GROWSDOWN)) {
 		if (vma->vm_start >= end)
 			goto out;
@@ -581,8 +581,11 @@ static int do_mprotect_pkey(unsigned lon
 				goto out;
 		}
 	}
+
 	if (start > vma->vm_start)
 		prev = vma;
+	else
+		prev = vma->vm_prev;
 
 	for (nstart = start ; ; ) {
 		unsigned long mask_off_old_flags;
_

Patches currently in -mm which might be from liu.song11@zte.com.cn are


