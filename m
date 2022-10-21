Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A27DDC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 04:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiJUEe5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 00:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiJUEev (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 00:34:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504BA1BEAB
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:34:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9E6CACE2800
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 04:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C14C4347C;
        Fri, 21 Oct 2022 04:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666326881;
        bh=xMZ7ROs8UGOLXqpPeUqG8jtk4uiwDCmOSq0gaIC+Nco=;
        h=Date:To:From:Subject:From;
        b=it8khjHLZTtkcnheVOfxWnng+LfBZuzTZVrrUwZaKrEz8Ia3h6lSMbDsgyXUFzybj
         CCUlOIouPYDw2UMUv74cQhJHbH3npEc4rd34wP631iHH8+tdys95GM2PQstwHW0p0y
         WltxlsMOJPZ6x+fryZ/zMGC5lFk7twRdr2zi/hlk=
Date:   Thu, 20 Oct 2022 21:34:41 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        oliver.sang@intel.com, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mempolicy-fix-mbind_range-arguments-to-vma_merge.patch removed from -mm tree
Message-Id: <20221021043441.D3C14C4347C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mempolicy: fix mbind_range() arguments to vma_merge()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-mbind_range-arguments-to-vma_merge.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mempolicy: fix mbind_range() arguments to vma_merge()
Date: Sat, 15 Oct 2022 02:12:33 +0000

Fuzzing produced an invalid argument to vma_merge() which was caught by
the newly added verification of the number of VMAs being removed on
process exit.  Analyzing the failure eventually resulted in finding an
issue with the search of a VMA that started at address 0, which caused an
underflow and thus the loss of many VMAs being tracked in the tree.  Fix
the underflow by changing the search of the maple tree to use the start
address directly.

Link: https://lkml.kernel.org/r/20221015021135.2816178-1-Liam.Howlett@oracle.com
Fixes: 66850be55e8e ("mm/mempolicy: use vma iterator & maple state instead of vma linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
  Link: https://lore.kernel.org/r/202210052318.5ad10912-oliver.sang@intel.com
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-mbind_range-arguments-to-vma_merge
+++ a/mm/mempolicy.c
@@ -787,17 +787,22 @@ static int vma_replace_policy(struct vm_
 static int mbind_range(struct mm_struct *mm, unsigned long start,
 		       unsigned long end, struct mempolicy *new_pol)
 {
-	MA_STATE(mas, &mm->mm_mt, start - 1, start - 1);
+	MA_STATE(mas, &mm->mm_mt, start, start);
 	struct vm_area_struct *prev;
 	struct vm_area_struct *vma;
 	int err = 0;
 	pgoff_t pgoff;
 
-	prev = mas_find_rev(&mas, 0);
-	if (prev && (start < prev->vm_end))
-		vma = prev;
-	else
-		vma = mas_next(&mas, end - 1);
+	prev = mas_prev(&mas, 0);
+	if (unlikely(!prev))
+		mas_set(&mas, start);
+
+	vma = mas_find(&mas, end - 1);
+	if (WARN_ON(!vma))
+		return 0;
+
+	if (start > vma->vm_start)
+		prev = vma;
 
 	for (; vma; vma = mas_next(&mas, end - 1)) {
 		unsigned long vmstart = max(start, vma->vm_start);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


