Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BF9C7EE2E
	for <mm-commits@archiver.kernel.org>; Tue, 28 Feb 2023 01:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjB1BAv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 20:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjB1BAu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 20:00:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB782943C
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 17:00:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBECE60F05
        for <mm-commits@vger.kernel.org>; Tue, 28 Feb 2023 01:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3470EC433D2;
        Tue, 28 Feb 2023 01:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677546048;
        bh=cy1pBvw3knL/mOyLrqXKGgIvAYmmnN0aLAvkIPpcTk8=;
        h=Date:To:From:Subject:From;
        b=aPb5Mg9J3ar/Zq7X9562CzGaRukI228n89lbtTUFT1wHol00TaH2hyrO1MCfDKSp8
         gttD4PRdgoi9tUwde+gcJkqnUgC+cQDV8j0dh7TmvxBokG82pRZj1K8RB3Lgwj9qYn
         V08ZT0k51zDWqgrBOGrDMMjcW9QyH/srVp6sSZnM=
Date:   Mon, 27 Feb 2023 17:00:47 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        vbabka@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mremap-fix-dup_anon_vma-in-vma_merge-case-4.patch removed from -mm tree
Message-Id: <20230228010048.3470EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mremap: fix dup_anon_vma() in vma_merge() case 4
has been removed from the -mm tree.  Its filename was
     mm-mremap-fix-dup_anon_vma-in-vma_merge-case-4.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-page_alloc-reduce-page-alloc-free-sanity-checks.patch

