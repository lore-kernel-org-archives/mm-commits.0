Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B2ECC76196
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 21:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjDFVyA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 17:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238786AbjDFVx6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 17:53:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD6DA5C5;
        Thu,  6 Apr 2023 14:53:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A00664C94;
        Thu,  6 Apr 2023 21:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F221C433D2;
        Thu,  6 Apr 2023 21:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680818035;
        bh=4INow3tdEomBOYxIu10fjikTXlBW7xZ0Hd/ma1P01PI=;
        h=Date:To:From:Subject:From;
        b=yXlKh2KkvLSQio1jesb7bOfcIVBzv63VM5iP/LCspzpHp25NJvpmQc0akrAQA/b2k
         RbdA2ANIlnp5NVlgDYA5wiAkpTXqhLGWRHkG7a+GFcbfSr1YMR/vX8SqLEmySlCX30
         A4j0ptCSnFj2wQUrokWax+LaRE7YecjmJ/aCGaBY=
Date:   Thu, 06 Apr 2023 14:53:54 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-fix-do_mprotect_pkey-return-on-error.patch added to mm-hotfixes-unstable branch
Message-Id: <20230406215355.5F221C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect: fix do_mprotect_pkey() return on error
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mprotect-fix-do_mprotect_pkey-return-on-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-fix-do_mprotect_pkey-return-on-error.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/mprotect: fix do_mprotect_pkey() return on error
Date: Thu, 6 Apr 2023 15:30:50 -0400

When the loop over the VMA is terminated early due to an error, the return
code could be overwritten with ENOMEM.  Fix the return code by only
setting the error on early loop termination when the error is not set.

User-visible effects include: attempts to run mprotect() against a special
mapping or with a poorly-aligned hugetlb address should return -EINVAL,
but they presently return -ENOMEM.

Link: https://lkml.kernel.org/r/20230406193050.1363476-1-Liam.Howlett@oracle.com
Fixes: 2286a6914c77 ("mm: change mprotect_fixup to vma iterator")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mprotect.c~mm-mprotect-fix-do_mprotect_pkey-return-on-error
+++ a/mm/mprotect.c
@@ -838,7 +838,7 @@ static int do_mprotect_pkey(unsigned lon
 	}
 	tlb_finish_mmu(&tlb);
 
-	if (vma_iter_end(&vmi) < end)
+	if (!error && vma_iter_end(&vmi) < end)
 		error = -ENOMEM;
 
 out:
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mprotect-fix-do_mprotect_pkey-return-on-error.patch

