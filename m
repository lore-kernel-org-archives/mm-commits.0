Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C26C388F9
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 878CA2245F
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408184;
	bh=PpFD+YJsfVRTpo4k1H+RRHO7/J421iMvedMxOrgwyg0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yS/FIsAWYV4jvPO4Ra7cLnRYbRAAaB7b4vt6l9CKEdP0M9camiGVNrTGN96FWgl86
	 Y7reU4F/vW1NsXMBJ7tX4sfaUb/bzOsXZAZriNLQgOoYRsDCUXKXp6pvrzNnV5VDHO
	 HRs2c4FBcF47QiHZ/8tqpkmtxpe5hjAT2SEy6mXU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373248AbgJVXJo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373127AbgJVXJn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:09:43 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C122E207EA;
        Thu, 22 Oct 2020 23:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408183;
        bh=PpFD+YJsfVRTpo4k1H+RRHO7/J421iMvedMxOrgwyg0=;
        h=Date:From:To:Subject:From;
        b=k5X35ZMsbHm7WLPsy/Y4FSFTtqH0b7fgPxkI7W73WUJ/Bh6FwcmrlvdLTGfdp0N0i
         u0sDm7jpdFVuStlgtiKeIG/MvcGMm5r9SS9hGFgUmWkE+SGxkWw6T2In5aVH+jLbpC
         OZKHSHlgcojKrCgB95bHvalLWTIM+g6TenFKq7CA=
Date:   Thu, 22 Oct 2020 16:09:42 -0700
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, jannh@google.com, jgg@nvidia.com,
        jhubbard@nvidia.com, mchehab@kernel.org,
        mm-commits@vger.kernel.org, sakari.ailus@linux.intel.com,
        walken@google.com
Subject:  [merged]
 binfmt_elf-take-the-mmap-lock-around-find_extend_vma.patch removed from -mm
 tree
Message-ID: <20201022230942.iqIRyPvvD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_elf: take the mmap lock around find_extend_vma()
has been removed from the -mm tree.  Its filename was
     binfmt_elf-take-the-mmap-lock-around-find_extend_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Michel Lespinasse <walken@google.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
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

mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages.patch
mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet.patch

