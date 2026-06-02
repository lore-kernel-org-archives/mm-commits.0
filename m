Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1525B21A434
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 00:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780361494; cv=none; b=T0etvx3O537m3ccuZHy5M6VEhT8uvfb3TMy5WMhrN4uLmCf+LBTzmNG/RQUaUcxlo6jIYI9PLTeYUs19ioiyKFbpxTAzqX+FzCFhXgXJo3L/nz0cHxW/jKOO100hMjqATptb8wEoFk9KepCNho5hAR8eSmMB7DS09186CfIzVPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780361494; c=relaxed/simple;
	bh=DSpjMTFE44DygygGi0tAbieLd0ZMgbV5VA+6jGE9Dqk=;
	h=Date:To:From:Subject:Message-Id; b=HOumxHzvvjNFDy8e8MwNI9OEqQEiW2XCKjOtykTwwsqShJ2I62n7HMjAG3ekNy0ge0NMhUZSHy7uwI7AUE5x3Bb2breUNUY4I5bXuwUB0j0mOqkRC0zpnmOq5f8DQizkpt0UOyNqiMdG3YaCk82p9mLaS3UGv6WA3gdyTd1ohmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0XEpUOZm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0XEpUOZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC381F00893;
	Tue,  2 Jun 2026 00:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780361491;
	bh=dgGL/Mufl2Jro6k12RqBQxF64I9JCFUxEp1gaY9c+EA=;
	h=Date:To:From:Subject;
	b=0XEpUOZmqH8hOOFf2YAaunotduOwqpk6+h8MsBOq4amDsqO7qgdzwaeC/abMh2QGY
	 oeBYpP0isbfrGgQRVlLv8f1XcWbPi80h5NQvWLoLRIWNUJPRRrXyYhNDVCStJu10L7
	 kT6rXTF3wGT+yUFbNBt1kAeChcSaEpT78S2E4UMw=
Date: Mon, 01 Jun 2026 17:51:30 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,liuqiang@kylinos.cn,leon@kernel.org,jgg@ziepe.ca,apopple@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix.patch added to mm-unstable branch
Message-Id: <20260602005131.3CC381F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix
Date: Mon Jun  1 05:49:07 PM PDT 2026

fix dmirror_devmem_fault_alloc_and_copy() retval handling

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606011329.zWs2BKy4-lkp@intel.com/
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Qiang Liu <liuqiang@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix
+++ a/lib/test_hmm.c
@@ -1167,9 +1167,9 @@ static int dmirror_migrate_to_system(str
 			goto out;
 
 		pr_debug("Migrating from device mem to sys mem\n");
-		ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
-		if (ret) {
+		if (dmirror_devmem_fault_alloc_and_copy(&args, dmirror)) {
 			migrate_vma_finalize(&args);
+			ret = -ENOMEM;
 			goto out;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix.patch
mm-switch-deferred-split-shrinker-to-list_lru-fix.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
sparc-add-_mcount-prototype.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

