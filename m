Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9442C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 03:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiJRDRq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 23:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiJRDRM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 23:17:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10D19C7F9
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 20:15:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62A51B81C63
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 03:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F385CC433D6;
        Tue, 18 Oct 2022 03:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666062800;
        bh=9EAfVdjcSxEspU59Yi9dI1ZotRitPODBth0MIvuw6Cw=;
        h=Date:To:From:Subject:From;
        b=UtOVibp+k3x9mJp22KsFrY6SZRXYh2lOooQR1R2meYXFt8ri8yMh4y83OnFJxCp31
         zcYmXDAB6xYGdwVZcxqeyn4k1RFfI6Sh0qf7FcFNk5QM7+ogDj1fFd0euFZ65XAfEU
         MTDgQ8ivIydtN1/VER2gi/iTLOffG9WFW0HxDnQ4=
Date:   Mon, 17 Oct 2022 20:13:19 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        lukas.bulwahn@gmail.com, liam.howlett@oracle.com,
        cmllamas@google.com, catalin.marinas@arm.com, andrii@kernel.org,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-undo-mmap-when-mas_preallocate-fails.patch added to mm-hotfixes-unstable branch
Message-Id: <20221018031319.F385CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: undo ->mmap() when mas_preallocate() fails
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mmap-undo-mmap-when-mas_preallocate-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-undo-mmap-when-mas_preallocate-fails.patch

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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/mmap: undo ->mmap() when mas_preallocate() fails
Date: Mon, 17 Oct 2022 19:49:45 -0700

A memory leak in hugetlb_reserve_pages was reported in [1].  The root
cause was traced to an error path in mmap_region when mas_preallocate()
fails.  In this case, the vma is freed after a successful call to
filesystem specific mmap.  The hugetlbfs mmap routine may allocate data
structures pointed to by m_private_data.  These need to be cleaned up by
the hugetlb vm_ops->close() routine.

The same issue was addressed by commit deb0f6562884 ("mm/mmap: undo
->mmap() when arch_validate_flags() fails") for the arch_validate_flags()
test.  Go to the same close_and_free_vma label if mas_preallocate() fails.

[1] https://lore.kernel.org/linux-mm/CAKXUXMxf7OiCwbxib7MwfR4M1b5+b3cNTU7n5NV9Zm4967=FPQ@mail.gmail.com/

Link: https://lkml.kernel.org/r/20221018024945.415036-1-mike.kravetz@oracle.com
Fixes: d4af56c5c7c6 ("mm: start tracking VMAs with maple tree")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-undo-mmap-when-mas_preallocate-fails
+++ a/mm/mmap.c
@@ -2681,7 +2681,7 @@ cannot_expand:
 	if (mas_preallocate(&mas, vma, GFP_KERNEL)) {
 		error = -ENOMEM;
 		if (file)
-			goto unmap_and_free_vma;
+			goto close_and_free_vma;
 		else
 			goto free_vma;
 	}
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-mmap-undo-mmap-when-mas_preallocate-fails.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

