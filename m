Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 909E7C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbjHKW0C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234276AbjHKW0C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:26:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9749CE
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:26:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 770E1651AA
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1634C433C7;
        Fri, 11 Aug 2023 22:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691792760;
        bh=Nz0KhUorPpU3G0QwF4Pk5JMx8SuL02md/0y3Tk/o12k=;
        h=Date:To:From:Subject:From;
        b=cAGx/2NnkSilsgJgzM1b2yIZte+TcH/hBYK0GziPUaalptrNssq1J/n76NgFiMbri
         iigjc6EPc0LC+X7AcDyfUIjODZueUio+BWBoYym9Q1gp1Zatf7HFnQqt2cjsPEGY3A
         pz3GmLyIF+TgncEIp11wxQPWd7K4PMKIl9W8j2ug=
Date:   Fri, 11 Aug 2023 15:26:00 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        ryan.roberts@arm.com, peterx@redhat.com, axelrasmussen@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-userfaultfd-check-for-start-len-overflow-in-validate_range-fix-2.patch removed from -mm tree
Message-Id: <20230811222600.D1634C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: userfaultfd: check for start + len overflow in validate_range: fix
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-check-for-start-len-overflow-in-validate_range-fix-2.patch

This patch was dropped because it was folded into mm-userfaultfd-check-for-start-len-overflow-in-validate_range.patch

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
mm-userfaultfd-extract-file-size-check-out-into-a-helper.patch
mm-userfaultfd-add-new-uffdio_poison-ioctl.patch
mm-userfaultfd-support-uffdio_poison-for-hugetlbfs.patch
mm-userfaultfd-document-and-enable-new-uffdio_poison-feature.patch
selftests-mm-refactor-uffd_poll_thread-to-allow-custom-fault-handlers.patch
selftests-mm-add-uffd-unit-test-for-uffdio_poison.patch

