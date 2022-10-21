Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDEBC43219
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 04:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiJUEfP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 00:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiJUEe5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 00:34:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B8713EB3
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:34:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9137B826C4
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 04:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB5CC433C1;
        Fri, 21 Oct 2022 04:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666326889;
        bh=5v7A2zcV3W+OV/yeXIO72NvhA6UA8xJtikuaXoyIm1c=;
        h=Date:To:From:Subject:From;
        b=hboC9sZ+a0nob1wQ1gmTflzYXOzccFd1b1oa/zZ7AvCaNxJjqiuu8p12OnLuyQUo2
         ojFDYuE2OGhpeYAFP9Ukuqkn9hKF46Uy00lC1C2g0iAY7DT/VhkTzYUV+BBfci0dqZ
         2CgVyjA5fc5egeSG9zNJKjw1JgftmWKebQUCtE6Q=
Date:   Thu, 20 Oct 2022 21:34:48 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        lukas.bulwahn@gmail.com, Liam.Howlett@oracle.com,
        cmllamas@google.com, catalin.marinas@arm.com, andrii@kernel.org,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mmap-undo-mmap-when-mas_preallocate-fails.patch removed from -mm tree
Message-Id: <20221021043449.4DB5CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: undo ->mmap() when mas_preallocate() fails
has been removed from the -mm tree.  Its filename was
     mm-mmap-undo-mmap-when-mas_preallocate-fails.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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

hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

