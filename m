Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE68AC46CA1
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344679AbjJRVg5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235243AbjJRVgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3260194
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66815C116AB;
        Wed, 18 Oct 2023 21:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664929;
        bh=F5H+p6n3vcjxzpeWH2djnFdquWuQqG/TkZztxOSDZc0=;
        h=Date:To:From:Subject:From;
        b=CATHuoig/s54okCKh7MiXMS4LDaU6PO1+uYwApxMXmrOGQD/1sQKzaHPV2jVD6KS4
         JaKowCiocLMCEs0sm6cBNUNB8Tza+bZH1AstpYeXSNfjogT8nKMyu/x3nefYrKPe5i
         NvHQ+sJ6c7YstWxiFCjwrcf9dV+vZtdIRq7vgrlM=
Date:   Wed, 18 Oct 2023 14:35:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, lstoakes@gmail.com, jannh@google.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmap-add-clarifying-comment-to-vma_merge-code.patch removed from -mm tree
Message-Id: <20231018213529.66815C116AB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmap: add clarifying comment to vma_merge() code
has been removed from the -mm tree.  Its filename was
     mmap-add-clarifying-comment-to-vma_merge-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
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


