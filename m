Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234594ACC9B
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 22:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789509638; cv=none; b=k0bVYnNNih97ie1jj4pO/LTfZYSvxEIPFNnuHv6egzmhJz/NyeqDsJ33opzkcUXCJr33eif4D/e0diFG4dvsdjvyh6hVExD/c7rIRZig1pl3LL207mICA7u4Y4B2F9lSSdz3SiBV+20MAiHIdPilbEuFgPXUMje9uulyru0JZsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789509638; c=relaxed/simple;
	bh=HQ9FYubT+djYTjUjYDihA54PSxL2nSvSgwQzVlr9HzI=;
	h=Date:To:From:Subject:Message-Id; b=aYyUHMr4LYVVJSXi/wTQcT0TXliXqPjgqach309qyej6VbbhfiP1RfUo+E1aVOrfJZhYiAwrkzbxMKntH0883qcauh3VvhoeHukDQYez7oDhVjtlYUhzpcUQWzQS+esjKrCwzue4rMN3SewwnPYRKlG5K/5YCm80BDvTMEEgGKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YXQ95gjF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YXQ95gjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF491F000FF;
	Tue, 15 Sep 2026 22:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789509633;
	bh=7JNZ11O1Z/TO4+Mjl25jAAaWaipmsg0tOM/lDIfLi3o=;
	h=Date:To:From:Subject;
	b=YXQ95gjFCYX75IYguVFj6ZV52ab85527PoWvawgDGE1kuiHp9ZGJcLLV5N4PYoiWO
	 +BT9Z6KlJn4besaiYfOPEVsKMwNP2LJCPYei0ZKAbWOOzsklObo9+e23cubK8H1E2Y
	 zpGumZSjDfeDoW4eb69JcwTdjsqI2KbJmjDKjCUI=
Date: Tue, 15 Sep 2026 15:00:33 -0700
To: mm-commits@vger.kernel.org,weiyongjun1@huawei.com,rcampbell@nvidia.com,leon@kernel.org,jglisse@redhat.com,jgg@ziepe.ca,error27@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hmm-test-reject-overflowing-page-counts.patch added to mm-new branch
Message-Id: <20260915220033.ADF491F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hmm/test: reject overflowing page counts
has been added to the -mm mm-new branch.  Its filename is
     mm-hmm-test-reject-overflowing-page-counts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hmm-test-reject-overflowing-page-counts.patch

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
From: Dan Carpenter <error27@gmail.com>
Subject: mm/hmm/test: reject overflowing page counts
Date: Tue, 15 Sep 2026 19:37:27 +0300

The number of pages comes directly from userspace.  Shifting a value
larger than ULONG_MAX >> PAGE_SHIFT discards its high bits before the
existing end-address check.  A request for a huge number of pages can
therefore be accepted and processed as a much smaller request.

Reject page counts that cannot be represented as a byte size before
performing the shift.

So far as ChatGPT and I can tell this doesn't cause an issue in practice
but preventing this integer overflow is the correct thing to do.

Link: https://lore.kernel.org/6f0d39089e938d4f53dc72632eb84aca34de7015.1789457465.git.error27@gmail.com
Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Assisted-by: ChatGPT:gpt-5
---

 lib/test_hmm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/test_hmm.c~mm-hmm-test-reject-overflowing-page-counts
+++ a/lib/test_hmm.c
@@ -1624,6 +1624,8 @@ static long dmirror_fops_unlocked_ioctl(
 
 	if (cmd.addr & ~PAGE_MASK)
 		return -EINVAL;
+	if (cmd.npages > ULONG_MAX >> PAGE_SHIFT)
+		return -EINVAL;
 	if (cmd.addr >= (cmd.addr + (cmd.npages << PAGE_SHIFT)))
 		return -EINVAL;
 
_

Patches currently in -mm which might be from error27@gmail.com are

mm-hmm-test-reject-overflowing-page-counts.patch

