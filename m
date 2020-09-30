Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05DAC4363D
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A53362072E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601505684;
	bh=XFLgLFw0ekykcewAWMMfl0VJx/mNRqS11v53Fdjq1vU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=WcArr0C1au+obv3IBPDzqkka41Y4W/1T6CZ75mT8GJ/owo9jWy1lVVklFsRfPQE+l
	 3MwMkj3LDTBaLxywi1PdF5joz4bznyKWQylQA1f8zd/V8aMe1Y7SfXmYj6Yer/jL96
	 TkowJgshd97+1uHG7lw2fcV2NU5EwOesR16ovyIM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbgI3WlY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 18:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730640AbgI3WlR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 18:41:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03A732075F;
        Wed, 30 Sep 2020 22:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601505676;
        bh=XFLgLFw0ekykcewAWMMfl0VJx/mNRqS11v53Fdjq1vU=;
        h=Date:From:To:Subject:From;
        b=eFm3bypAruJnZx7BKCp8isySrA7D02gwXl7sNDDVoJVnXgEd4N1w7OoXY5cK0N2+Z
         dMcf1qcDFn5YEJtwAHBBFhVIr5oLVX0wTHMZS0ccH7+PHFlBa40v2WcQJi1rBk9VtG
         2KmjFSBniVQi59nq4BBFbwjvp5BIX5PePcNi2aCM=
Date:   Wed, 30 Sep 2020 15:41:15 -0700
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, jannh@google.com, jgg@nvidia.com,
        jhubbard@nvidia.com, mchehab@kernel.org,
        mm-commits@vger.kernel.org, sakari.ailus@linux.intel.com,
        walken@google.com
Subject:  +
 mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages.patch added to
 -mm tree
Message-ID: <20200930224115.PVA64nQaE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: assert that the mmap lock is held in __get_user_pages()
has been added to the -mm tree.  Its filename is
     mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm/gup: assert that the mmap lock is held in __get_user_pages()

After having cleaned up all GUP callers (except for the atomisp staging
driver, which currently gets mmap locking completely wrong [1]) to always
ensure that they hold the mmap lock when calling into GUP (unless the mm
is not yet globally visible), add an assertion to make sure it stays that
way going forward.

[1] https://lore.kernel.org/lkml/CAG48ez3tZAb9JVhw4T5e-i=h2_DUZxfNRTDsagSRCVazNXx5qA@mail.gmail.com/

Link: https://lkml.kernel.org/r/CAG48ez1GM==OnHpS=ghqZNJPn02FCDUEHc7GQmGRMXUD_aKudg@mail.gmail.com
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/gup.c~mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages
+++ a/mm/gup.c
@@ -1027,6 +1027,8 @@ static long __get_user_pages(struct mm_s
 	struct vm_area_struct *vma = NULL;
 	struct follow_page_context ctx = { NULL };
 
+	mmap_assert_locked(mm);
+
 	if (!nr_pages)
 		return 0;
 
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
mm-gup_benchmark-take-the-mmap-lock-around-gup.patch
binfmt_elf-take-the-mmap-lock-around-find_extend_vma.patch
mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet.patch
mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages.patch

