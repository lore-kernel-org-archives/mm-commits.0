Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3183AEB64DD
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 17:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236927AbjHKRpD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 13:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236911AbjHKRo5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 13:44:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD6EEA
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 10:44:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73DF567879
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 17:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1DAC433C8;
        Fri, 11 Aug 2023 17:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691775895;
        bh=HtWrNoWomGAdzjWYUrzZLd6A0/AbSOoTbXySkzS64fc=;
        h=Date:To:From:Subject:From;
        b=SsdrLJ37cgKVS86mjwf8oGXs/BYWy+IU8okOBLCkw97xwI9x/eYJNHshtVn/HdP+8
         exoaecPNMqluPNuX3gCX4GlIsmQQ5Y3Yqjwz/+lWYXrjNwSZlFfpNGRGvnAqo/A0qH
         VdC+B3uv5+8ssucx8deEeNVeLlfzPZzZ3Wg5wlSA=
Date:   Fri, 11 Aug 2023 10:44:55 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        ryan.roberts@arm.com, peterx@redhat.com, axelrasmussen@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-check-for-start-len-overflow-in-validate_range-fix-2.patch added to mm-unstable branch
Message-Id: <20230811174455.CA1DAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: userfaultfd: check for start + len overflow in validate_range: fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-userfaultfd-check-for-start-len-overflow-in-validate_range-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-check-for-start-len-overflow-in-validate_range-fix-2.patch

This patch will later appear in the mm-unstable branch at
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
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: mm: userfaultfd: check for start + len overflow in validate_range: fix
Date: Thu, 10 Aug 2023 12:21:28 -0700

A previous fixup to this commit fixed one issue, but introduced another:
we're now overly strict when validating the src address for UFFDIO_COPY.

Most of the validation in validate_range is useful to apply to src as
well as dst, but page alignment is only a requirement for dst, not src.
So, split the function up so src can use an "unaligned" variant, while
still allowing us to share the majority of the code between the
different cases.

Link: https://lkml.kernel.org/r/20230810192128.1855570-1-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Closes: https://lore.kernel.org/linux-mm/8fbb5965-28f7-4e9a-ac04-1406ed8fc2d4@arm.com/T/#t
Reviewed-by: Yu Zhao <yuzhao@google.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/fs/userfaultfd.c~mm-userfaultfd-check-for-start-len-overflow-in-validate_range-fix-2
+++ a/fs/userfaultfd.c
@@ -1283,13 +1283,11 @@ static __always_inline void wake_userfau
 		__wake_userfault(ctx, range);
 }
 
-static __always_inline int validate_range(struct mm_struct *mm,
-					  __u64 start, __u64 len)
+static __always_inline int validate_unaligned_range(
+	struct mm_struct *mm, __u64 start, __u64 len)
 {
 	__u64 task_size = mm->task_size;
 
-	if (start & ~PAGE_MASK)
-		return -EINVAL;
 	if (len & ~PAGE_MASK)
 		return -EINVAL;
 	if (!len)
@@ -1305,6 +1303,15 @@ static __always_inline int validate_rang
 	return 0;
 }
 
+static __always_inline int validate_range(struct mm_struct *mm,
+					  __u64 start, __u64 len)
+{
+	if (start & ~PAGE_MASK)
+		return -EINVAL;
+
+	return validate_unaligned_range(mm, start, len);
+}
+
 static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 				unsigned long arg)
 {
@@ -1753,7 +1760,8 @@ static int userfaultfd_copy(struct userf
 			   sizeof(uffdio_copy)-sizeof(__s64)))
 		goto out;
 
-	ret = validate_range(ctx->mm, uffdio_copy.src, uffdio_copy.len);
+	ret = validate_unaligned_range(ctx->mm, uffdio_copy.src,
+				       uffdio_copy.len);
 	if (ret)
 		goto out;
 	ret = validate_range(ctx->mm, uffdio_copy.dst, uffdio_copy.len);
_

Patches currently in -mm which might be from axelrasmussen@google.com are

mm-make-pte_marker_swapin_error-more-general.patch
mm-userfaultfd-check-for-start-len-overflow-in-validate_range.patch
mm-userfaultfd-check-for-start-len-overflow-in-validate_range-fix.patch
mm-userfaultfd-check-for-start-len-overflow-in-validate_range-fix-2.patch
mm-userfaultfd-extract-file-size-check-out-into-a-helper.patch
mm-userfaultfd-add-new-uffdio_poison-ioctl.patch
mm-userfaultfd-support-uffdio_poison-for-hugetlbfs.patch
mm-userfaultfd-document-and-enable-new-uffdio_poison-feature.patch
selftests-mm-refactor-uffd_poll_thread-to-allow-custom-fault-handlers.patch
selftests-mm-add-uffd-unit-test-for-uffdio_poison.patch

