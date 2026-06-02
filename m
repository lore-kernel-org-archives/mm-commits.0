Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779D630676C
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 00:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780361475; cv=none; b=JD9lJDd1LjIju4cTs50wDkFGQw2O/3UWJMhe2uyMkiHiP/pObh1rcm4/iEjKN1TcBcnnp0nMBDo0E3cIMXEFtFXL2cEYcmWc+oLKZDkDUvmtmNruzmsyOKiB74dO1FM4hdwKHiX3ol1+6g/X5bMIOudL+j4Hg+a0mTWG+FVAD/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780361475; c=relaxed/simple;
	bh=bd5lsX0q9Jvx6+Ho8jCdEf3Kw9+dMrKJrILmMxQ3G+0=;
	h=Date:To:From:Subject:Message-Id; b=d1rUq5rFT1VsBWMG55DpQkH4ABgPHKP8t3YIEmIbARjbCBnKW9pNlMv7x4jH6TW7iwbkGfEoP/IaZSmHmsuOrzMG+zAmw2aTkuWa5jg3Qed8iwUAAFhSBHqi5D051EV/pKfI84kyqfuEc0XjlzPW0TI8VuEjCEixq82omgj73aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w2ox4K4+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w2ox4K4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195461F00893;
	Tue,  2 Jun 2026 00:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780361474;
	bh=cwtFiBNLFYFVmjkY+XEotuhTgH9na7PPj8uEajEJex4=;
	h=Date:To:From:Subject;
	b=w2ox4K4+1o26cHmfZLccZFGpe2dCJ61HUJxpf9DE22zyGF1x7qGp4+2pjCzUCtCoQ
	 LyBWXZYN7YN4m++i737kUDtpOxn6EmcUr44pGQjmKzhW3aBzlE9kceFlEaJWQEEV6J
	 d81DChzZ/PUNJrB/nO/fNarOSZqW4gwlAUx6TNiU=
Date: Mon, 01 Jun 2026 17:51:13 -0700
To: mm-commits@vger.kernel.org,liuqiang@kylinos.cn,leon@kernel.org,jgg@ziepe.ca,apopple@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix.patch added to mm-unstable branch
Message-Id: <20260602005114.195461F00893@smtp.kernel.org>
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

