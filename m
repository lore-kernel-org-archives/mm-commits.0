Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAEFCC43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ADB121655
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881404;
	bh=u6JdW1k48Iw+Z2EEKmWnyMrIreepadlxU8Z8DB416co=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=IH8436/0+BdNQPya92M8jI9Vy9ITEYkWJK2Wn+yuvdL0MrzzS8M6ukdAA4apIS7wO
	 YzjVa/HpukoeW8hIBoI06NuMT30A/9wKlSYeUpkbENPMISnXiNX9SamuIuIIIeuYf3
	 xT3I0ysKFCTEnoE3EKHeC6fH1d/hLvItu5i0PN1U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392733AbgJPUuE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392732AbgJPUuD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:50:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5A8820878;
        Fri, 16 Oct 2020 20:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881403;
        bh=u6JdW1k48Iw+Z2EEKmWnyMrIreepadlxU8Z8DB416co=;
        h=Date:From:To:Subject:From;
        b=yBZTbE6j+BZMx4qM9EzgnVEdDt1qj9rb7wQSzlgAZ9DRABkMkU3pPqgJben76gMnH
         xnyA8zE/sJ8pg1NzqI4Vo/Pj6G/t2Ea6sf+6WvyGHEVxA7k9kPskWZ4r6SIadR+7dw
         PEPCcb0Hf6UeINnyMYKIQwYagFgHM+R5Et/2Zs3E=
Date:   Fri, 16 Oct 2020 13:50:02 -0700
From:   akpm@linux-foundation.org
To:     christian.koenig@amd.com, hch@lst.de, jannh@google.com,
        jgg@nvidia.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-mmu_notifier-fix-mmget-assert-in-__mmu_interval_notifier_insert.patch
 removed from -mm tree
Message-ID: <20201016205002.M_-Z_htM8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmu_notifier: fix mmget() assert in __mmu_interval_notifie=
r_insert
has been removed from the -mm tree.  Its filename was
     mm-mmu_notifier-fix-mmget-assert-in-__mmu_interval_notifier_insert.pat=
ch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Jann Horn <jannh@google.com>
Subject: mm/mmu_notifier: fix mmget() assert in __mmu_interval_notifier_ins=
ert

The comment talks about having to hold mmget() (which means mm_users), but
the actual check is on mm_count (which would be mmgrab()).

Given that MMU notifiers are torn down in mmput() -> __mmput() ->
exit_mmap() -> mmu_notifier_release(), I believe that the comment is
correct and the check should be on mm->mm_users.  Fix it up accordingly.

Link: https://lkml.kernel.org/r/20200901000143.207585-1-jannh@google.com
Fixes: 99cb252f5e68 ("mm/mmu_notifier: add an interval tree notifier")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christian K=C3=B6nig <christian.koenig@amd.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmu_notifier.c~mm-mmu_notifier-fix-mmget-assert-in-__mmu_interval_=
notifier_insert
+++ a/mm/mmu_notifier.c
@@ -913,7 +913,7 @@ static int __mmu_interval_notifier_inser
 		return -EOVERFLOW;
=20
 	/* Must call with a mmget() held */
-	if (WARN_ON(atomic_read(&mm->mm_count) <=3D 0))
+	if (WARN_ON(atomic_read(&mm->mm_users) <=3D 0))
 		return -EINVAL;
=20
 	/* pairs with mmdrop in mmu_interval_notifier_remove() */
_

Patches currently in -mm which might be from jannh@google.com are

mm-gup_benchmark-take-the-mmap-lock-around-gup.patch
binfmt_elf-take-the-mmap-lock-around-find_extend_vma.patch
mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet.patch
mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages.patch

