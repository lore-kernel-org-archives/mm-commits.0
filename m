Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80ACDC61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbjBJAz0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbjBJAyh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:54:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0051F721F7
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88BE461B7A
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4103C433D2;
        Fri, 10 Feb 2023 00:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990415;
        bh=ugbgBUzZ3hG4HQ1z58wvSA6QwqyPZc99KmPXUfTMhhs=;
        h=Date:To:From:Subject:From;
        b=fXfJoS0BXsk2h6IGRli9Acj6AGYEubn/xVvFNY1Wb6norh/M2Lkc7nt1K5jfetmFu
         khBjTo+9DC9jiSj0RgnMiy/IIcBjdym4/P9KMQ9AR/5oA07Yt6UKJR7sZDvLdeZl1l
         xuAKeifl29DBXb+mrwjiJCqultQWZsfUEOwztF/U=
Date:   Thu, 09 Feb 2023 16:53:34 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vma_merge-set-vma-iterator-to-correct-position.patch removed from -mm tree
Message-Id: <20230210005334.E4103C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: vma_merge: set vma iterator to correct position.
has been removed from the -mm tree.  Its filename was
     vma_merge-set-vma-iterator-to-correct-position.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: vma_merge: set vma iterator to correct position.
Date: Fri, 20 Jan 2023 11:26:50 -0500

When merging the previous value, set the vma iterator to the previous
slot.  Don't use the vma iterator to get the next/prev so that it is in
the correct position for a write.

Link: https://lkml.kernel.org/r/20230120162650.984577-50-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mmap.c~vma_merge-set-vma-iterator-to-correct-position
+++ a/mm/mmap.c
@@ -932,6 +932,7 @@ struct vm_area_struct *vma_merge(struct
 		    && can_vma_merge_after(prev, vm_flags, anon_vma, file,
 				   pgoff, vm_userfaultfd_ctx, anon_name)) {
 			merge_prev = true;
+			vma_prev(vmi);
 		}
 	}
 	/* Can we merge the successor? */
@@ -1023,9 +1024,6 @@ struct vm_area_struct *vma_merge(struct
 	validate_mm(mm);
 	khugepaged_enter_vma(res, vm_flags);
 
-	if (res)
-		vma_iter_set(vmi, end);
-
 	return res;
 }
 
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


