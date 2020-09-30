Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB4CC47420
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B6AD20C09
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601505685;
	bh=5NUPSmfrQGHLG65f1huxcPT7NWUkqdro3kOCzqgWyww=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=a7+hGpp8UIpnLAHzbDGx7+5m/p3s8nBiillnrFp5S+WPs15FmLdzZBmIWOy0hAo3n
	 eg05WE17tuR6ax78wUg+rxEi37UhlVnGqswRxTi2+YY0sQOKe5ElVifgr57yfvrj2V
	 wzP9ajspOiQEpfVcQO0GGuyrct2EpNjk/+2gei3s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730613AbgI3WlY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 18:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730548AbgI3WlJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 18:41:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E026B2071E;
        Wed, 30 Sep 2020 22:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601505669;
        bh=5NUPSmfrQGHLG65f1huxcPT7NWUkqdro3kOCzqgWyww=;
        h=Date:From:To:Subject:From;
        b=eohUqEpPzFInDZYvysDg4ijbqjUpPc4ybwQe3dLvEJp9Lh5qD2R8akHfYt89vkios
         s4a1kZO+jMPKB2+l/YGToUhQsquB47MzTv02iT8rnjcLz/0RBT4PQihiAY5989odrH
         E54TtLhuugynF2m7iTP6g8ayaygm1+9KqvoARf10=
Date:   Wed, 30 Sep 2020 15:41:08 -0700
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, jannh@google.com, jgg@nvidia.com,
        jhubbard@nvidia.com, mchehab@kernel.org,
        mm-commits@vger.kernel.org, sakari.ailus@linux.intel.com,
        walken@google.com
Subject:  +
 binfmt_elf-take-the-mmap-lock-around-find_extend_vma.patch added to -mm
 tree
Message-ID: <20200930224108.l6OxgJJOn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_elf: take the mmap lock around find_extend_vma()
has been added to the -mm tree.  Its filename is
     binfmt_elf-take-the-mmap-lock-around-find_extend_vma.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/binfmt_elf-take-the-mmap-lock-around-find_extend_vma.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/binfmt_elf-take-the-mmap-lock-around-find_extend_vma.patch

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
Subject: binfmt_elf: take the mmap lock around find_extend_vma()

create_elf_tables() runs after setup_new_exec(), so other tasks can
already access our new mm and do things like process_madvise() on it.  (At
the time I'm writing this commit, process_madvise() is not in mainline
yet, but has been in akpm's tree for some time.)

While I believe that there are currently no APIs that would actually allow
another process to mess up our VMA tree (process_madvise() is limited to
MADV_COLD and MADV_PAGEOUT, and uring and userfaultfd cannot reach an mm
under which no syscalls have been executed yet), this seems like an
accident waiting to happen.

Let's make sure that we always take the mmap lock around GUP paths as long
as another process might be able to see the mm.

(Yes, this diff looks suspicious because we drop the lock before doing
anything with `vma`, but that's because we actually don't do anything with
it apart from the NULL check.)

Link: https://lkml.kernel.org/r/CAG48ez1-PBCdv3y8pn-Ty-b+FmBSLwDuVKFSt8h7wARLy0dF-Q@mail.gmail.com
Signed-off-by: Jann Horn <jannh@google.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/binfmt_elf.c~binfmt_elf-take-the-mmap-lock-around-find_extend_vma
+++ a/fs/binfmt_elf.c
@@ -310,7 +310,10 @@ create_elf_tables(struct linux_binprm *b
 	 * Grow the stack manually; some architectures have a limit on how
 	 * far ahead a user-space access may be in order to grow the stack.
 	 */
+	if (mmap_read_lock_killable(mm))
+		return -EINTR;
 	vma = find_extend_vma(mm, bprm->p);
+	mmap_read_unlock(mm);
 	if (!vma)
 		return -EFAULT;
 
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

