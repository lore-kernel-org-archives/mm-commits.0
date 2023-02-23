Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 621A1C61DA4
	for <mm-commits@archiver.kernel.org>; Thu, 23 Feb 2023 20:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjBWUGv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 15:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjBWUGu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 15:06:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8612E0C9
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 12:06:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C91C1CE210B
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 20:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF988C433EF;
        Thu, 23 Feb 2023 20:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677182806;
        bh=3gn+AXo0nvjUkoNWci+epPjiaO4E2z/ZoJgB3UdAjlY=;
        h=Date:To:From:Subject:From;
        b=Zou9yM7vQYK/IauHl49gQe+oZ9CVq6Iz7/BibIpuNVQcLeRh72gGgLTz7lQ6kGulZ
         UuIOqXqr/tDksts6yYEEGE8VO/NyBpKW6fYw/+k6GKzd+j7eQFxAAwprX99NeXEUI9
         hqctN1EJd84Zt5jz0QBbIrAplLSe+9i3js7MYaB8=
Date:   Thu, 23 Feb 2023 12:06:45 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        vbabka@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-fix-dup_anon_vma-in-vma_merge-case-4.patch added to mm-unstable branch
Message-Id: <20230223200645.DF988C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: fix dup_anon_vma() in vma_merge() case 4
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-fix-dup_anon_vma-in-vma_merge-case-4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-fix-dup_anon_vma-in-vma_merge-case-4.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/mremap: fix dup_anon_vma() in vma_merge() case 4

In case 4, we are shrinking 'prev' (PPPP in the comment) and expanding
'mid' (NNNN).  So we need to make sure 'mid' clones the anon_vma from
'prev', if it doesn't have any.  After commit 0503ea8f5ba7 ("mm/mmap:
remove __vma_adjust()") we can fail to do that due to wrong parameters for
dup_anon_vma().  The call is a no-op because res == next, adjust == mid
and mid == next.  Fix it.

Link: https://lkml.kernel.org/r/ad91d62b-37eb-4b73-707a-3c45c9e16256@suse.cz
Fixes: 0503ea8f5ba7 ("mm/mmap: remove __vma_adjust()")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mremap-fix-dup_anon_vma-in-vma_merge-case-4
+++ a/mm/mmap.c
@@ -973,7 +973,7 @@ struct vm_area_struct *vma_merge(struct
 			vma_end = addr;
 			adjust = mid;
 			adj_next = -(vma->vm_end - addr);
-			err = dup_anon_vma(res, adjust);
+			err = dup_anon_vma(adjust, prev);
 		} else {
 			vma = next;			/* case 3 */
 			vma_start = addr;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-mremap-fix-dup_anon_vma-in-vma_merge-case-4.patch

