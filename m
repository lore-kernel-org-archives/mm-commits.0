Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24F20C433E2
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 04:44:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED02F206F2
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 04:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599194655;
	bh=Vb+jpY5LNu2msY75j5o3Q1LGcYzcmm9bgTMJASVNZ9Q=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=G1k5k+9PWUdceGxWSLbOOfkpAz+oKWeh7SwwqAyX+Xcx1CaYwRBHMx9oC+CY2n9fq
	 IkWlww1Do9+LWuIBok+KQT5Jxpv/hfBGtjIPbDnRRMVecQFQQs54QkryRlfKpW2hq3
	 Iq6RHuMtIjE6WKvRrkuWnEaxIk2vNp56uno6SPUQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgIDEoO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 00:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgIDEoO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 00:44:14 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87E76206CA;
        Fri,  4 Sep 2020 04:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599194653;
        bh=Vb+jpY5LNu2msY75j5o3Q1LGcYzcmm9bgTMJASVNZ9Q=;
        h=Date:From:To:Subject:From;
        b=mmq9QuN3eUKjxYpuXlmgenz5yLdb4485xZM9UzDH3dn7ZBnZHvT8HxNSFwuAOajLe
         bTul1JjU5AKybX1EsxcCcVIqN30qHrmVMwD3BrlHyvW1l1TTaYg8MDy/IeI6Y9c2QI
         iX/0WzyG0kIRfTf31lwYVE/xjb9qShRsUb507M7c=
Date:   Thu, 03 Sep 2020 21:44:13 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        hch@lst.de, christian.koenig@amd.com, jannh@google.com
Subject:  +
 mm-mmu_notifier-fix-mmget-assert-in-__mmu_interval_notifier_insert.patch
 added to -mm tree
Message-ID: <20200904044413.Fbnw_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmu_notifier: fix mmget() assert in __mmu_interval_notifie=
r_insert
has been added to the -mm tree.  Its filename is
     mm-mmu_notifier-fix-mmget-assert-in-__mmu_interval_notifier_insert.pat=
ch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmu_notifier-fix-mmget-ass=
ert-in-__mmu_interval_notifier_insert.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmu_notifier-fix-mmget-ass=
ert-in-__mmu_interval_notifier_insert.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
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

mm-mmu_notifier-fix-mmget-assert-in-__mmu_interval_notifier_insert.patch
binfmt_elf_fdpic-stop-using-dump_emit-on-user-pointers-on-mmu.patch
coredump-let-dump_emit-bail-out-on-short-writes.patch
coredump-refactor-page-range-dumping-into-common-helper.patch
coredump-rework-elf-elf_fdpic-vma_dump_size-into-common-helper.patch
binfmt_elf-binfmt_elf_fdpic-use-a-vma-list-snapshot.patch
mm-gup-take-mmap_lock-in-get_dump_page.patch
mm-remove-the-now-unnecessary-mmget_still_valid-hack.patch

