Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F28C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1FE7208B6
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602975863;
	bh=Ib9y7tjPbFxtInX6ycQJ63i4eUK1eW5gCSOIMN3M9AM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=IdEl52687DLrlPJO3Up++glsEBIOQ5/w9cXvINndlB0fj3S4OdDTjFQummAszQahT
	 El4D8+xCc3UYr/ZjScDWbzxHBCkxCJVhQznupSQMqNhyLSqOwPI3SRutDf/W1vPBhp
	 WlC0gQpuKQxJfpYk2r7RqEi1OEHjZ17iQ6YvBZG4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439840AbgJQXEX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438235AbgJQXEX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:04:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E47E20897;
        Sat, 17 Oct 2020 23:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602975862;
        bh=Ib9y7tjPbFxtInX6ycQJ63i4eUK1eW5gCSOIMN3M9AM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ovPIn6Ag8hdREAWXlU+TYokgNWN+Q1OgNp5bHrFPeX7J1j687ny8SSRtlsfxfnjrC
         EHIfPKXDW1fQeMomZhdt4g9suMqbKd0ueTveSNOpM5JalDFGS6WHWjpak8Vfxu8Y6v
         emfMtqZXjKGY6Vk2tHTM2dbTq1RTZHVEC1qSfj1U=
Date:   Sat, 17 Oct 2020 16:04:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     hch@infradead.org, minchan@kernel.org, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?US-ASCII?Q?memory-hinting-api-fix-fix-fix-fix-fix-fix-fix.patch?=
 removed from -mm tree
Message-ID: <20201017230422.53Ri5fGpV%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not use helper functions for process_madvise
has been removed from the -mm tree.  Its filename was
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix.patch

This patch was dropped because it was folded into mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch

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
@@ -1171,37 +1171,40 @@ SYSCALL_DEFINE3(madvise, unsigned long,
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
@@ -1221,43 +1224,29 @@ static ssize_t do_process_madvise(int pi
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

mm-madvise-pass-mm-to-do_madvise.patch
pid-move-pidfd_get_pid-to-pidc.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch

