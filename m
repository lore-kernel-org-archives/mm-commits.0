Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4550D1AA1EC
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 23:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744847568; cv=none; b=kRe/6LJ08D2CWvl/vH82+ve5DiuhWig1Rf8lgq8TTGxfB+XRAucr+wKM5/Vxri8lq8XXtB50otPzfONsIltgjjDHKCQk0a8FYpS0ADslfXmxvww2FHW7+2/Kh/LNT7Vdsel8z0S2+yym3Z5undBEjk99ZnBzuyypC8K+Q6yx1uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744847568; c=relaxed/simple;
	bh=01iKLo1/0tGUPfUzJJf+xEfboarmeXAmLyV8Ot7MI38=;
	h=Date:To:From:Subject:Message-Id; b=ur3x329Xpck/P6vafk3HJLjbZAPjsHQiYW+eo7Vby03KkjOBwwQQivk/91N78NaUOCs47qLzo7l7s3DQGTAT47CpPYtTDcwYEBxvMozoRaW/WrNpTBkGT/lLReMOM25+mIC4wdD635+j2dBJpCZUEnAIXqDbTvbCHwiV2w3oGVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WERb58JM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WERb58JM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99ABEC4CEE2;
	Wed, 16 Apr 2025 23:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744847567;
	bh=01iKLo1/0tGUPfUzJJf+xEfboarmeXAmLyV8Ot7MI38=;
	h=Date:To:From:Subject:From;
	b=WERb58JMUjHfdGO6Pl9tQrpZBG3r2JiAW7C6g9D/oC645Z2MweXrdN32qYVz/9G/P
	 kAu6EzrhVeDs356Ckz3rYhCko6Fiwobu34/57CtSoI+mYqfDMOLffp0kCjNPFCGgUo
	 iaI2tyhG4tB2KCudpa/mAtxAooxzQe7/zXdl2qUU=
Date: Wed, 16 Apr 2025 16:52:46 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-prcl-fix-a-comment-typo.patch added to mm-unstable branch
Message-Id: <20250416235247.99ABEC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/prcl: fix a comment typo
has been added to the -mm mm-unstable branch.  Its filename is
     samples-damon-prcl-fix-a-comment-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-prcl-fix-a-comment-typo.patch

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
From: Enze Li <lienze@kylinos.cn>
Subject: samples/damon/prcl: fix a comment typo
Date: Fri, 11 Apr 2025 15:38:00 +0800

This patch just fixes a typo in the comment.

Link: https://lkml.kernel.org/r/20250411073800.1444481-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/prcl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/samples/damon/prcl.c~samples-damon-prcl-fix-a-comment-typo
+++ a/samples/damon/prcl.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * proactive reclamation: monitor access pattern of a given process, find
- * regiosn that seems not accessed, and proactively page out the regions.
+ * regions that seems not accessed, and proactively page out the regions.
  */
 
 #define pr_fmt(fmt) "damon_sample_prcl: " fmt
_

Patches currently in -mm which might be from lienze@kylinos.cn are

selftests-damon-remove-the-remaining-test-scripts-for-damon-debugfs-interface.patch
samples-damon-prcl-fix-a-comment-typo.patch

