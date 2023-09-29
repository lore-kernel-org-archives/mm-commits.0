Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9E4E728D6
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 18:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbjI2ShM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 14:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233373AbjI2ShL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 14:37:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9582C199
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 11:37:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA74C433C7;
        Fri, 29 Sep 2023 18:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696012629;
        bh=uuAgVmGv5iRDbTv8LQSVlD7Sgc7NizGoAXdw3YniEkU=;
        h=Date:To:From:Subject:From;
        b=XcNhVpkAXFDCNi5Dc+x5L4+OXnVoDDURnp5w5qF18F2AAKSFLCIJV3llwe4KvNZV+
         JedAXyDIMSurITccRaRl/DPcSWef+DzG9TJpIr4Jqz62GzWDN8D3TotJ2z37YpQEv4
         9HFgDINguPsqyLqJzSd2HMd7r597bjaDIpLZQdyA=
Date:   Fri, 29 Sep 2023 11:37:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, lstoakes@gmail.com, jannh@google.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmap-add-clarifying-comment-to-vma_merge-code.patch added to mm-unstable branch
Message-Id: <20230929183709.2BA74C433C7@smtp.kernel.org>
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
Date: Fri, 29 Sep 2023 14:30:41 -0400

When tracing through the code in vma_merge(), it was not completely
clear why the error return to a dup_anon_vma() call would not overwrite
a previous attempt to the same function.  This commit adds a comment
specifying why it is safe.

Link: https://lkml.kernel.org/r/20230929183041.2835469-4-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/linux-mm/CAG48ez3iDwFPR=Ed1BfrNuyUJPMK_=StjxhUsCkL6po1s7bONg@mail.gmail.com/
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/mmap.c~mmap-add-clarifying-comment-to-vma_merge-code
+++ a/mm/mmap.c
@@ -943,6 +943,11 @@ struct vm_area_struct *vma_merge(struct
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
mm-mempolicy-fix-set_mempolicy_home_node-previous-vma-pointer.patch
mmap-fix-vma_iterator-in-error-path-of-vma_merge.patch
mmap-fix-error-paths-with-dup_anon_vma.patch
mmap-add-clarifying-comment-to-vma_merge-code.patch

