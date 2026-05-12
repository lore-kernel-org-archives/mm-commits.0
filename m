Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424D9382385
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 21:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778621273; cv=none; b=k1CVn8Df4dkdMvnFpAdl6yZ/mSBwOnuhaVvHwIMJs/9w21AQbKK+QN39g623xvJEnN5McgHGFf53FKAaJyPlogS/54BlbBmf2XxU9tvw6gEr07KLaXkakToHQAJ0K7xZFlOUqtF0DL0x00fKO2gKENlxbMuQC5/eVznt4X+pvMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778621273; c=relaxed/simple;
	bh=EzC1QzJgEiyn9oEqV+2Bb1c7PUawxAb9XJ4h5Xn1Evw=;
	h=Date:To:From:Subject:Message-Id; b=sokL2sRe5O670vuFzpabNXv/0ABolg5X6Z68LxKK8kxZZazaz/2V5+exFTvYRxhUCVQZYb48HSEWAmu123erk0ZE5nqbDM3wLJVwC6MyHqPWL2Qbc2bzPnwmeOwtjsy03I0A8LqWYi5XNhSZP5QYxsG5oWfSLhey7yYwdMImbEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RxoGg2Md; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RxoGg2Md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63CAC2BCB0;
	Tue, 12 May 2026 21:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778621273;
	bh=EzC1QzJgEiyn9oEqV+2Bb1c7PUawxAb9XJ4h5Xn1Evw=;
	h=Date:To:From:Subject:From;
	b=RxoGg2Md/Xd+wq6UPEouNt5KKrXmh45egnSSN2mEYWcPLfMiFP+B3ghVcrKwZeTlf
	 n03nyDP0V/+EIm06eA0ErMzMUPOPnYUyb0QQD8ZvRLvpJsSxIZ0ws5tTV7pJeajZuQ
	 HjmIkMdUadoR7uxhp0X+h6wJnfD6t9MGjkZVaCGc=
Date: Tue, 12 May 2026 14:27:52 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,david@kernel.org,agarwal.vineet2006@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix.patch added to mm-new branch
Message-Id: <20260512212752.E63CAC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix
Date: Tue May 12 02:26:23 PM PDT 2026

remove unneeded local, per David

Cc: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -610,10 +610,7 @@ static int create_pagecache_thp_and_fd(c
 	for (i = 0; i < sizeof(buf); i++)
 		buf[i] = (unsigned char)i;
 	for (i = 0; i < fd_size; i += sizeof(buf)) {
-		ssize_t written;
-
-		written = write(*fd, buf, sizeof(buf));
-		if (written != sizeof(buf)) {
+		if (write(*fd, buf, sizeof(buf)) != sizeof(buf)) {
 			ksft_perror("write testfile");
 			close(*fd);
 			goto err_out_unlink;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix.patch
proc-rewrite-next_tgid-fix.patch

