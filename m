Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E5A2192FE;
	Thu,  8 May 2025 06:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686453; cv=none; b=ao/aK3N0NP9SLGBuyrEkjlv4MM+xbRnfnRXwn3e9o7GzGPLsb1Q5ZTQgqYfdYF9mkAiC01X31hQ4EbEQZPMonOJN/bZIm4egV2KIUgEl+zBUZsrjIwlNOHDu8U/U5dOR1U9SbY/kGEQtCSjfSPEiGVHcm88HJfPEoagUioj3j8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686453; c=relaxed/simple;
	bh=ok0xFlPIvbQHdOPm7/c/w8IHaQYXEapH12SeUM9LuU0=;
	h=Date:To:From:Subject:Message-Id; b=OhGX90MvWstOBXr8G7O0NDs05bjdn8mOEtInijA9SrqHwOmCU6R0uYO5roCUOAjQHuru5JM5TaOkGAr4roLF1FCxHl/LsKhVa5IMXpki8Apo+0MwYgBtBCt8YZX5Uul0j+Sx2JDjxEkmV+z/IZD0+ncy60Vv8n0nZ6GjzqRarac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ih8IenlU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ih8IenlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A10C4CEEB;
	Thu,  8 May 2025 06:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746686452;
	bh=ok0xFlPIvbQHdOPm7/c/w8IHaQYXEapH12SeUM9LuU0=;
	h=Date:To:From:Subject:From;
	b=Ih8IenlUsTfJWKF4MSDMMH65vuFCVyQlIBqlm1DWHzAFp/Vp0vhTMm0336eYgmvzt
	 adJHOyxLZ0YV5IHadVGiHVbdrjGxpz3WCG6nK8Mmd9ldcQlROmNOCXtpQw58x4ffV1
	 0pOXuikwL6Fzk3b9SfguRUor/ymFol3Ts2S3PpAI=
Date: Wed, 07 May 2025 23:40:52 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,david@redhat.com,axelrasmussen@google.com,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-userfaultfd-fix-uninitialized-output-field-for-eagain-race.patch removed from -mm tree
Message-Id: <20250508064052.B6A10C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/userfaultfd: fix uninitialized output field for -EAGAIN race
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-fix-uninitialized-output-field-for-eagain-race.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: David Hildenbrand <david@redhat.com>
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

mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain.patch

