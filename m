Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43292C4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 18:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04F5E23787
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 18:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600797910;
	bh=RRpCdJ4OIOzjLvo+c5qhg3H41paHXV/Iv156VEyN3F4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=sbF0oPdcrVCG5VnOMofERZ9pBvBw3eHJL/ZfLiXF5jlFJ9KU/DwY4M7idrBz2aLT0
	 HfVTg/M4In39bH5CFRgu4KXWvyE9s9wfNcoButee1OLXHt0HoEqfxrigw4pZZU1gEK
	 CGpGHeWh7Guet1MEB20ZjObt4Ng/p/DKedcEXrVI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgIVSFJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 14:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgIVSFI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 14:05:08 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1622C2376F;
        Tue, 22 Sep 2020 18:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600797908;
        bh=RRpCdJ4OIOzjLvo+c5qhg3H41paHXV/Iv156VEyN3F4=;
        h=Date:From:To:Subject:From;
        b=qFeLCTmEyV/7Wy0Z9l/1csczR7Jk1uLpYxFrUVpCa8HRIW6+FjrcaTQ9jUlttBW6f
         0zD0kvk0LvSyeBl9aakJB4oQrHNfGMl7tIN2uHvp70JR74GB4ZOeJFdQEQqjKZ2KEy
         RTHLf4wszJvQSBsd6xkOlX5Y1BTQgyd1rcizCka4=
Date:   Tue, 22 Sep 2020 11:05:07 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hch@infradead.org, minchan@kernel.org
Subject:  +
 =?us-ascii?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?us-ascii?Q?memory-hinting-api-fix-fix-fix-fix-fix-fix-fix.patch?= added
 to -mm tree
Message-ID: <20200922180507.RK_ff%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not use helper functions for process_madvise
has been added to the -mm tree.  Its filename is
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: do not use helper functions for process_madvise

This patch removes helper functions process_madvise_vec,
do_process_madvise and madv_import_iovec and use them inline.

Link: https://lkml.kernel.org/r/20200921175539.GB387368@google.com
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   97 +++++++++++++++++++++----------------------------
 1 file changed, 43 insertions(+), 54 deletions(-)

--- a/mm/madvise.c~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix
+++ a/mm/madvise.c
@@ -1166,37 +1166,40 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 	return do_madvise(current->mm, start, len_in, behavior);
 }
 
-static int process_madvise_vec(struct mm_struct *mm, struct iov_iter *iter, int behavior)
-{
-	struct iovec iovec;
-	int ret = 0;
-
-	while (iov_iter_count(iter)) {
-		iovec = iov_iter_iovec(iter);
-		ret = do_madvise(mm, (unsigned long)iovec.iov_base, iovec.iov_len, behavior);
-		if (ret < 0)
-			break;
-		iov_iter_advance(iter, iovec.iov_len);
-	}
-
-	return ret;
-}
-
-static ssize_t do_process_madvise(int pidfd, struct iov_iter *iter,
-				int behavior, unsigned int flags)
+SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
+		size_t, vlen, int, behavior, unsigned int, flags)
 {
 	ssize_t ret;
+	struct iovec iovstack[UIO_FASTIOV], iovec;
+	struct iovec *iov = iovstack;
+	struct iov_iter iter;
 	struct pid *pid;
 	struct task_struct *task;
 	struct mm_struct *mm;
-	size_t total_len = iov_iter_count(iter);
+	size_t total_len;
+
+	if (flags != 0) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	if (flags != 0)
-		return -EINVAL;
+#ifdef CONFIG_COMPAT
+	if (in_compat_syscall())
+		ret = compat_import_iovec(READ,
+				(struct compat_iovec __user *)vec, vlen,
+				ARRAY_SIZE(iovstack), &iov, &iter);
+	else
+#endif
+		ret = import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack),
+				&iov, &iter);
+	if (ret < 0)
+		goto out;
 
 	pid = pidfd_get_pid(pidfd);
-	if (IS_ERR(pid))
-		return PTR_ERR(pid);
+	if (IS_ERR(pid)) {
+		ret = PTR_ERR(pid);
+		goto free_iov;
+	}
 
 	task = get_pid_task(pid, PIDTYPE_PID);
 	if (!task) {
@@ -1216,43 +1219,29 @@ static ssize_t do_process_madvise(int pi
 		goto release_task;
 	}
 
-	ret = process_madvise_vec(mm, iter, behavior);
-	if (ret >= 0)
-		ret = total_len - iov_iter_count(iter);
+	total_len = iov_iter_count(&iter);
+
+	while (iov_iter_count(&iter)) {
+		iovec = iov_iter_iovec(&iter);
+		ret = do_madvise(mm, (unsigned long)iovec.iov_base,
+					iovec.iov_len, behavior);
+		if (ret < 0)
+			break;
+		iov_iter_advance(&iter, iovec.iov_len);
+	}
+
+	if (ret == 0)
+		ret = total_len - iov_iter_count(&iter);
 
 	mmput(mm);
+	return ret;
+
 release_task:
 	put_task_struct(task);
 put_pid:
 	put_pid(pid);
-	return ret;
-}
-
-static inline int madv_import_iovec(int type, const struct iovec __user *uvec, size_t nr_segs,
-		unsigned int fast_segs, struct iovec **iov, struct iov_iter *i)
-{
-#ifdef CONFIG_COMPAT
-	if (in_compat_syscall())
-		return compat_import_iovec(type, (struct compat_iovec __user *)uvec, nr_segs,
-				fast_segs, iov, i);
-#endif
-
-	return import_iovec(type, uvec, nr_segs, fast_segs, iov, i);
-}
-
-SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
-		size_t, vlen, int, behavior, unsigned int, flags)
-{
-	ssize_t ret;
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
-	struct iov_iter iter;
-
-	ret = madv_import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
-	if (ret < 0)
-		return ret;
-
-	ret = do_process_madvise(pidfd, &iter, behavior, flags);
+free_iov:
 	kfree(iov);
+out:
 	return ret;
 }
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-validate-pmd-after-splitting.patch
mm-madvise-pass-mm-to-do_madvise.patch
pid-move-pidfd_get_pid-to-pidc.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix.patch

