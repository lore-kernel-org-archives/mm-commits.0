Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9F12E8E09
	for <mm-commits@vger.kernel.org>; Sat, 25 Jul 2026 04:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784955014; cv=none; b=GHe/J+eP7wg1CvVOY9c53gBOID9Jar6kmAuGQr8Fyo5iRK4WxERL0aRly4MNdtHkGkKaGhDUmWOiP5wg9wv05q0apHXz6gARnsF6J+svC3RI42Y07N+uniXArvvqT/ISmsozr91K0p/7TdQ/wjMl/jvCXynZRMNw5kYLHRjhEl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784955014; c=relaxed/simple;
	bh=GkwgaHMdrBBjWmRTMeFHmaAKy+T6lkriYk/uV/48PkM=;
	h=Date:To:From:Subject:Message-Id; b=KbT/PbmiBLclHVoIJQV86H5CfFcaw23f1GDh6a/tE6rIn4I+AhOA/LDVShuzotlumkeLGqZLg1CTt+Kh9i5Msc0ImgSvNqp0A9P6+UszzPLGlRuujKzi+YT2BcatLmY81wW3I8DM/gSE/K0+PojUd9yO4xjoh6TSdwWqxtCv9GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lCEn4TI4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lCEn4TI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5353B1F000E9;
	Sat, 25 Jul 2026 04:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784955012;
	bh=6JQ2luIiRIUD5USAa78rO5itoj4XjsR62eDGcw8YmJE=;
	h=Date:To:From:Subject;
	b=lCEn4TI4u5zJLGVjI/zr4VnXWZ7/A9s/T+uQhfpvJXc8CulVTgJNIOWTLmyUr7B0j
	 6gt4MZbpgmoRgfIeO+2VuFcX+5SZANu8/O6e+pfEp8xGGLgiLx0x0rccDIUYMhBIuD
	 LaR1Ec2xc2cWYu5Uu1IjPj9Cmk1dhIGaT7QNUFCU=
Date: Fri, 24 Jul 2026 21:50:11 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sarthak.sharma@arm.com,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,dev.jain@arm.com,david@kernel.org,zhaozhengzhuo@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-gup_longterm-einval-error-message.patch added to mm-new branch
Message-Id: <20260725045012.5353B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix gup_longterm EINVAL error message
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-gup_longterm-einval-error-message.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-gup_longterm-einval-error-message.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: selftests/mm: fix gup_longterm EINVAL error message
Date: Fri, 24 Jul 2026 15:46:03 +0800

The gup_longterm test prints a literal "n" when PIN_LONGTERM_TEST_START
fails with EINVAL because the string is missing the newline escape
sequence.

Print a newline instead.

Link: https://lore.kernel.org/23557F4CB8CF36FF+20260724074603.1479243-1-zhaozhengzhuo@uniontech.com
Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-fix-gup_longterm-einval-error-message
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -196,7 +196,7 @@ static void do_test(int fd, size_t size,
 		args.flags |= rw ? PIN_LONGTERM_TEST_FLAG_USE_WRITE : 0;
 		ret = ioctl(gup_fd, PIN_LONGTERM_TEST_START, &args);
 		if (ret && errno == EINVAL) {
-			ksft_print_msg("PIN_LONGTERM_TEST_START failed (EINVAL)n");
+			ksft_print_msg("PIN_LONGTERM_TEST_START failed (EINVAL)\n");
 			result = KSFT_SKIP;
 			break;
 		} else if (ret && errno == EFAULT) {
_

Patches currently in -mm which might be from zhaozhengzhuo@uniontech.com are

selftests-mm-fix-gup_longterm-einval-error-message.patch

