Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FE01F463E;
	Thu, 24 Apr 2025 23:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745537502; cv=none; b=upTYuizbHne7q0tUmNIBKfe+FJFz3Fv7RfAi5CJiF6xu0jhFY6azPcMe3qfKZolLi0hsnlgD6Dlrc+0bULaO7c4yNs5QsPCVVbupIcoz7TCLtypeNgV4d9/LMp5hPxxDffCs52605PByNeQaBWY0yri1VWYcfsrLCr7lZXUa0RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745537502; c=relaxed/simple;
	bh=F2DfGTNOpazmkXxfgSOS3NQXZG4kg09MJr4FMkVqhpA=;
	h=Date:To:From:Subject:Message-Id; b=j5dyNDzCuclD53q+ZUUSt42eGhc8Qy5Z/U8BWtadE6MBRVGfjCf39WArSyEyc1aWZ4PoMubSv+TFdPMwU6ptAEGKR3kqzd9sMarkzIrIQrT3SCjpRA8J6OGb2w7U3GJXM719PBnCM1OpBGuLpbYzEuV2uzSL6cs5gTuCnMbaGS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r57LybEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r57LybEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF1EC4CEE3;
	Thu, 24 Apr 2025 23:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745537500;
	bh=F2DfGTNOpazmkXxfgSOS3NQXZG4kg09MJr4FMkVqhpA=;
	h=Date:To:From:Subject:From;
	b=r57LybECudiFKsDZmFfLkAAk3IiML3wi1zC7PxAqeQEzMQBw8IzDyrQqPSpTXqzMb
	 yJoC3dki24KcMNZXgQ39ibH7eP+8Sg6oZhhag5maa2vEO8bw5hNJyzWgbkCoYfboF+
	 uW+hTIVL5JBbpV+pYwPcUBDsW9GoNLfJKyaXhUYg=
Date: Thu, 24 Apr 2025 16:31:39 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,axelrasmussen@google.com,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-fix-uninitialized-output-field-for-eagain-race.patch added to mm-hotfixes-unstable branch
Message-Id: <20250424233139.DEF1EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/userfaultfd: fix uninitialized output field for -EAGAIN race
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-userfaultfd-fix-uninitialized-output-field-for-eagain-race.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-fix-uninitialized-output-field-for-eagain-race.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Peter Xu <peterx@redhat.com>
Subject: mm/userfaultfd: fix uninitialized output field for -EAGAIN race
Date: Thu, 24 Apr 2025 17:57:28 -0400

While discussing some userfaultfd relevant issues recently, Andrea noticed
a potential ABI breakage with -EAGAIN on almost all userfaultfd ioctl()s.

Quote from Andrea, explaining how -EAGAIN was processed, and how this
should fix it (taking example of UFFDIO_COPY ioctl):

  The "mmap_changing" and "stale pmd" conditions are already reported as
  -EAGAIN written in the copy field, this does not change it. This change
  removes the subnormal case that left copy.copy uninitialized and required
  apps to explicitly set the copy field to get deterministic
  behavior (which is a requirement contrary to the documentation in both
  the manpage and source code). In turn there's no alteration to backwards
  compatibility as result of this change because userland will find the
  copy field consistently set to -EAGAIN, and not anymore sometime -EAGAIN
  and sometime uninitialized.

  Even then the change only can make a difference to non cooperative users
  of userfaultfd, so when UFFD_FEATURE_EVENT_* is enabled, which is not
  true for the vast majority of apps using userfaultfd or this unintended
  uninitialized field may have been noticed sooner.

Meanwhile, since this bug existed for years, it also almost affects all
ioctl()s that was introduced later.  Besides UFFDIO_ZEROPAGE, these also
get affected in the same way:

  - UFFDIO_CONTINUE
  - UFFDIO_POISON
  - UFFDIO_MOVE

This patch should have fixed all of them.

Link: https://lkml.kernel.org/r/20250424215729.194656-2-peterx@redhat.com
Fixes: df2cc96e7701 ("userfaultfd: prevent non-cooperative events vs mcopy_atomic races")
Fixes: f619147104c8 ("userfaultfd: add UFFDIO_CONTINUE ioctl")
Fixes: fc71884a5f59 ("mm: userfaultfd: add new UFFDIO_POISON ioctl")
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/fs/userfaultfd.c~mm-userfaultfd-fix-uninitialized-output-field-for-eagain-race
+++ a/fs/userfaultfd.c
@@ -1585,8 +1585,11 @@ static int userfaultfd_copy(struct userf
 	user_uffdio_copy = (struct uffdio_copy __user *) arg;
 
 	ret = -EAGAIN;
-	if (atomic_read(&ctx->mmap_changing))
+	if (unlikely(atomic_read(&ctx->mmap_changing))) {
+		if (unlikely(put_user(ret, &user_uffdio_copy->copy)))
+			return -EFAULT;
 		goto out;
+	}
 
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_copy, user_uffdio_copy,
@@ -1641,8 +1644,11 @@ static int userfaultfd_zeropage(struct u
 	user_uffdio_zeropage = (struct uffdio_zeropage __user *) arg;
 
 	ret = -EAGAIN;
-	if (atomic_read(&ctx->mmap_changing))
+	if (unlikely(atomic_read(&ctx->mmap_changing))) {
+		if (unlikely(put_user(ret, &user_uffdio_zeropage->zeropage)))
+			return -EFAULT;
 		goto out;
+	}
 
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_zeropage, user_uffdio_zeropage,
@@ -1744,8 +1750,11 @@ static int userfaultfd_continue(struct u
 	user_uffdio_continue = (struct uffdio_continue __user *)arg;
 
 	ret = -EAGAIN;
-	if (atomic_read(&ctx->mmap_changing))
+	if (unlikely(atomic_read(&ctx->mmap_changing))) {
+		if (unlikely(put_user(ret, &user_uffdio_continue->mapped)))
+			return -EFAULT;
 		goto out;
+	}
 
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_continue, user_uffdio_continue,
@@ -1801,8 +1810,11 @@ static inline int userfaultfd_poison(str
 	user_uffdio_poison = (struct uffdio_poison __user *)arg;
 
 	ret = -EAGAIN;
-	if (atomic_read(&ctx->mmap_changing))
+	if (unlikely(atomic_read(&ctx->mmap_changing))) {
+		if (unlikely(put_user(ret, &user_uffdio_poison->updated)))
+			return -EFAULT;
 		goto out;
+	}
 
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_poison, user_uffdio_poison,
@@ -1870,8 +1882,12 @@ static int userfaultfd_move(struct userf
 
 	user_uffdio_move = (struct uffdio_move __user *) arg;
 
-	if (atomic_read(&ctx->mmap_changing))
-		return -EAGAIN;
+	ret = -EAGAIN;
+	if (unlikely(atomic_read(&ctx->mmap_changing))) {
+		if (unlikely(put_user(ret, &user_uffdio_move->move)))
+			return -EFAULT;
+		goto out;
+	}
 
 	if (copy_from_user(&uffdio_move, user_uffdio_move,
 			   /* don't copy "move" last field */
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-fix-uninitialized-output-field-for-eagain-race.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain.patch

