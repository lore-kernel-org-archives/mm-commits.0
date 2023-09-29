Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC1FE728CF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 18:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbjI2Sdr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 14:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbjI2Sdr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 14:33:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD84199
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 11:33:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443B1C433C8;
        Fri, 29 Sep 2023 18:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696012425;
        bh=iyc1E+vt3XrsKW2pK0xhCMpj9uxN+C2GmvWDph7m9Mg=;
        h=Date:To:From:Subject:From;
        b=FbfrORHONr5lL+e6gd368iup04Va3j58UJ4QHwqvOPafg688Nj1Rjuu1Q09DvmTZ1
         RV0yjMPsMQ/ouVcn+ETDnD95wIJu4R6LZZSNhAg176N59ZyKBA1LF0r98FRHvEUewY
         kEin1Oqw4YEt/gTOclfuwniIWVWj1Ao1MELKFPOU=
Date:   Fri, 29 Sep 2023 11:33:44 -0700
To:     mm-commits@vger.kernel.org, jannh@google.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mmap-add-clarifying-comment-to-vma_merge-code.patch removed from -mm tree
Message-Id: <20230929183345.443B1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmap: add clarifying comment to vma_merge() code
has been removed from the -mm tree.  Its filename was
     mmap-add-clarifying-comment-to-vma_merge-code.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mmap: add clarifying comment to vma_merge() code
Date: Thu, 28 Sep 2023 13:16:34 -0400

When tracing through the code in vma_merge(), it was not completely clear
why the error return to a dup_anon_vma() call would not overwrite a
previous attempt to the same function.  This commit adds a comment
specifying why it is safe.

Link: https://lkml.kernel.org/r/20230928171634.2245042-4-Liam.Howlett@oracle.com
Link: https://lore.kernel.org/linux-mm/CAG48ez3iDwFPR=Ed1BfrNuyUJPMK_=StjxhUsCkL6po1s7bONg@mail.gmail.com/
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Jann Horn <jannh@google.com>
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
mm-mempolicy-fix-set_mempolicy_home_node-previous-vma-pointer.patch

