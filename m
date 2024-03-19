Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B833BBD7
	for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2024 21:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710884866; cv=none; b=na0toF8HyHWqXE1D4GMqmf7PgHSFQW7gTAredHQfl+hA3BmImzSzcYZP0ZmxKc6gg5OFtErBdVOtpeDKET5lnebLXvAqiOJm0ep13KYOI6qyrTfNdMSKBL4Yxd5SRpB2P4by0zTisuVNH81Xh43naHfdTrDWP1qRRbVp8Hj7/G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710884866; c=relaxed/simple;
	bh=Mb+UKx7guZ5VYgU5h0FhJwbwlKzAwtn555eIOMDkjnQ=;
	h=Date:To:From:Subject:Message-Id; b=HhFazhhM2r3tK6+w7MNdJ73FWyS+jBrNXLAkoNcq6QJ9IJcvUKTgVhdQsNkMEBL3I0c6/OKRv/LJT0BYDfmc23mDFKhMJ+3iqwklA2ltTttZPVN5GbtQUZrX1+ktbLm/lpn3qDdJRcdfunWD0iPDHpIOQdccZIQFiyh0TXpwgkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0m+UttGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0m+UttGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8256EC433C7;
	Tue, 19 Mar 2024 21:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710884865;
	bh=Mb+UKx7guZ5VYgU5h0FhJwbwlKzAwtn555eIOMDkjnQ=;
	h=Date:To:From:Subject:From;
	b=0m+UttGMMAl5wo6sD25mCbwRBW5aZhEXON6WQZVMvIt/qHHMVCVXa1pTrjsBwNLIN
	 O6KR7FScz7Sg+lORJWhzkJGya/Hc5bFRl6rAvJ3l33CKzy72OIKBRXzHwGcPvSmXhO
	 Oh0es4VAbZen1lf5XSxCoqaNGp4qv7ocWARNiGJ0=
Date: Tue, 19 Mar 2024 14:47:45 -0700
To: mm-commits@vger.kernel.org,jglisse@redhat.com,duoming@zju.edu.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmmc-handle-src_pfns-and-dst_pfns-allocation-failure.patch added to mm-unstable branch
Message-Id: <20240319214745.8256EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_hmm.c: handle src_pfns and dst_pfns allocation failure
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_hmmc-handle-src_pfns-and-dst_pfns-allocation-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmmc-handle-src_pfns-and-dst_pfns-allocation-failure.patch

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
From: Duoming Zhou <duoming@zju.edu.cn>
Subject: lib/test_hmm.c: handle src_pfns and dst_pfns allocation failure
Date: Tue, 12 Mar 2024 08:59:05 +0800

The kcalloc() in dmirror_device_evict_chunk() will return null if the
physical memory has run out.  As a result, if src_pfns or dst_pfns is
dereferenced, the null pointer dereference bug will happen.

Moreover, the device is going away.  If the kcalloc() fails, the pages
mapping a chunk could not be evicted.  So add a __GFP_NOFAIL flag in
kcalloc().

Finally, as there is no need to have physically contiguous memory, Switch
kcalloc() to kvcalloc() in order to avoid failing allocations.

Link: https://lkml.kernel.org/r/20240312005905.9939-1-duoming@zju.edu.cn
Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Cc: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmmc-handle-src_pfns-and-dst_pfns-allocation-failure
+++ a/lib/test_hmm.c
@@ -1226,8 +1226,8 @@ static void dmirror_device_evict_chunk(s
 	unsigned long *src_pfns;
 	unsigned long *dst_pfns;
 
-	src_pfns = kcalloc(npages, sizeof(*src_pfns), GFP_KERNEL);
-	dst_pfns = kcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL);
+	src_pfns = kvcalloc(npages, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
+	dst_pfns = kvcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
 
 	migrate_device_range(src_pfns, start_pfn, npages);
 	for (i = 0; i < npages; i++) {
@@ -1250,8 +1250,8 @@ static void dmirror_device_evict_chunk(s
 	}
 	migrate_device_pages(src_pfns, dst_pfns, npages);
 	migrate_device_finalize(src_pfns, dst_pfns, npages);
-	kfree(src_pfns);
-	kfree(dst_pfns);
+	kvfree(src_pfns);
+	kvfree(dst_pfns);
 }
 
 /* Removes free pages from the free list so they can't be re-allocated */
_

Patches currently in -mm which might be from duoming@zju.edu.cn are

lib-test_hmmc-handle-src_pfns-and-dst_pfns-allocation-failure.patch

