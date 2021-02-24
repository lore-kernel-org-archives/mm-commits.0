Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20751C4332B
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 19:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9D4D64DA1
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 19:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235931AbhBXTJI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 14:09:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235936AbhBXTIw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 14:08:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B221564F0F;
        Wed, 24 Feb 2021 19:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614193261;
        bh=mLzGqabT8GUJYmslRIHUfaxJdHfEeSGJZcf6WUE4zDs=;
        h=Date:From:To:Subject:From;
        b=gld2K1tAblxmaclkMTv0UUtHdiWJEqu8syfDpHBhM0KtA5eHkv668FSks9+penuG0
         ZCIniDWaDHd3ZbwSFqwLORCABYa7U8k7+3zx1xZJW17Bj2UCiBs0EdBmC/FP5b+8El
         x6ntaIy2mcpv3d4qqeTbBJ1dMzM+ouUVd5ISyyfQ=
Date:   Wed, 24 Feb 2021 11:00:59 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, bgeffon@google.com,
        kirill.shutemov@linux.intel.com, lixinhai.lxh@gmail.com,
        lokeshgidra@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-mremap-unlink-anon=5Fvmas-when-mremap-with-mremap=5Fdo?=
 =?US-ASCII?Q?ntunmap-success-v2.patch?= removed from -mm tree
Message-ID: <20210224190059.Cz0DyPCZb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success
has been removed from the -mm tree.  Its filename was
     mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success-v2.patch

This patch was dropped because it was folded into mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success.patch

------------------------------------------------------
From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success

Need to consider the old vma just been partially moved, if so we must keep
the anon_vma links for remaining mapped pages in old vma.

Link: https://lkml.kernel.org/r/20210127083917.309264-2-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success-v2
+++ a/mm/mremap.c
@@ -600,7 +600,8 @@ static unsigned long move_vma(struct vm_
 		 * anon_vma links of the old vma is no longer needed after its page
 		 * table has been moved.
 		 */
-		if (new_vma != vma)
+		if (new_vma != vma && vma->vm_start == old_addr &&
+			vma->vm_end == (old_addr + old_len))
 			unlink_anon_vmas(vma);
 
 		/* Because we won't unmap we don't need to touch locked_vm */
_

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are

mm-rmap-explicitly-reset-vma-anon_vma-in-unlink_anon_vmas.patch
mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success.patch
mm-hugetlbc-fix-unnecessary-address-expansion-of-pmd-sharing.patch

