Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27FD2C04FE1
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbjHKXNH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbjHKXNB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144F83A9F
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A830767AD3
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEF6C433C7;
        Fri, 11 Aug 2023 23:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794961;
        bh=oaM7sP+1aMg1ic2I5ziw6AZd27Cku3u4sQ7wav7FuEY=;
        h=Date:To:From:Subject:From;
        b=WFzn+mMP2x5lKwEy7rVPyw+hwqf50VVl4lSMGf4OluYjR7pYczPRzu/BlFnS85cVl
         Hxqi2CoIseHsYjuPHmGFqg8pZxH/L9xWmbeCgky+YY7fNj06F5B4gJMAv8TPvTJ8nk
         3RKadY67FF1rBmbX7+HMZWalCvMWFH29qmgIcaf4=
Date:   Fri, 11 Aug 2023 16:02:40 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        surenb@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-prev-check-from-do_vmi_align_munmap.patch removed from -mm tree
Message-Id: <20230811230241.0AEF6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove prev check from do_vmi_align_munmap()
has been removed from the -mm tree.  Its filename was
     mm-remove-prev-check-from-do_vmi_align_munmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm: remove prev check from do_vmi_align_munmap()
Date: Mon, 24 Jul 2023 14:31:46 -0400

If the prev does not exist, the vma iterator will be set to MAS_NONE,
which will be treated as a MAS_START when the mas_next or mas_find is
used.  In this case, the next caller will be the vma iterator, which
uses mas_find() under the hood and will now do what the user expects.

Link: https://lkml.kernel.org/r/20230724183157.3939892-5-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/mmap.c~mm-remove-prev-check-from-do_vmi_align_munmap
+++ a/mm/mmap.c
@@ -2459,8 +2459,6 @@ do_vmi_align_munmap(struct vma_iterator
 	}
 
 	prev = vma_prev(vmi);
-	if (unlikely((!prev)))
-		vma_iter_set(vmi, start);
 
 	/*
 	 * Detach a range of VMAs from the mm. Using next as a temp variable as
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-add-hex-output-to-maple_arange64-dump.patch
maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch
maple_tree-introduce-mas_put_in_tree.patch
maple_tree-introduce-mas_tree_parent-definition.patch
maple_tree-change-mas_adopt_children-parent-usage.patch
maple_tree-replace-data-before-marking-dead-in-split-and-spanning-store.patch

