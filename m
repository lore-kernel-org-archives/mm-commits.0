Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C5DE82CB3
	for <mm-commits@archiver.kernel.org>; Wed, 27 Sep 2023 17:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjI0RQ1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Sep 2023 13:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjI0RQX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2023 13:16:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DC7B4
        for <mm-commits@vger.kernel.org>; Wed, 27 Sep 2023 10:16:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7933AC433C7;
        Wed, 27 Sep 2023 17:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695834982;
        bh=ANCYQVT7wc/qoN10OzmaBvVB4ewRNaLmsv/RZfKZkAk=;
        h=Date:To:From:Subject:From;
        b=V2y/QnHF22M1FIrpcmR6iq78jKjtS2bQ3uypZHKsX1U+pXYhFMy7Zbuiv7RX9gGeA
         C9gGPIA+4c94RlUvlCgancOQrdVYxXi9l1oaEfLo/+hFMd9Myyss0v6BRc25O38QR0
         T9OMBfJfXbD8HhFhQDOZe+sux9TJHe5wBRL6gq8o=
Date:   Wed, 27 Sep 2023 10:16:21 -0700
To:     mm-commits@vger.kernel.org, jannh@google.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmap-add-clarifying-comment-to-vma_merge-code.patch added to mm-unstable branch
Message-Id: <20230927171622.7933AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: add clarifying comment to vma_merge() code
has been added to the -mm mm-unstable branch.  Its filename is
     mmap-add-clarifying-comment-to-vma_merge-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmap-add-clarifying-comment-to-vma_merge-code.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mmap: add clarifying comment to vma_merge() code
Date: Wed, 27 Sep 2023 12:07:46 -0400

When tracing through the code in vma_merge(), it was not completely clear
why the error return to a dup_anon_vma() call would not overwrite a
previous attempt to the same function.  This commit adds a comment
specifying why it is safe.

Link: https://lkml.kernel.org/r/20230927160746.1928098-4-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/linux-mm/CAG48ez3iDwFPR=Ed1BfrNuyUJPMK_=StjxhUsCkL6po1s7bONg@mail.gmail.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/mmap.c~mmap-add-clarifying-comment-to-vma_merge-code
+++ a/mm/mmap.c
@@ -937,6 +937,11 @@ struct vm_area_struct *vma_merge(struct
 			vma_start_write(curr);
 			remove = curr;
 			remove2 = next;
+			/*
+			 * Note that the dup_anon_vma below cannot overwrite err
+			 * since the first caller would do nothing unless next
+			 * has an anon_vma.
+			 */
 			if (!next->anon_vma)
 				err = dup_anon_vma(prev, curr, &anon_dup);
 		}
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-add-mas_active-to-detect-in-tree-walks.patch
maple_tree-add-mas_underflow-and-mas_overflow-states.patch
mmap-fix-vma_iterator-in-error-path-of-vma_merge.patch
mmap-fix-error-paths-with-dup_anon_vma.patch
mmap-add-clarifying-comment-to-vma_merge-code.patch

