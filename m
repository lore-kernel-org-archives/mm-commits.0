Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69150242D65
	for <mm-commits@vger.kernel.org>; Mon, 10 Aug 2026 18:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786386186; cv=none; b=cBUJyOkylxLXOLlaeryBHRxBMy0KsOmkH6bg3LZLTrl47QmDQK4ENw6hQDAHYiDitl/2b8cVeLUr5/iKjKLvJ7FW7gngghY9cSp8p5ABZsoMh/qxLsrxFp7wPef2t0SHvLv4Q0iDwQIeiEn335/oXscluuYIMH1RaNxMxLgLTuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786386186; c=relaxed/simple;
	bh=kT6iKOKvkGzPBWZUEvphHciueyXafC6Cfp6kPmKfqDo=;
	h=Date:To:From:Subject:Message-Id; b=LtX7b+XxwgBucHP8+9jYDxtBInIrSmVEmKGsy5ggVaoDTv3aESMtCWJSYmNWA7tRvTHnwtF+AHITKscJym4YhrfR9ZCxV4zdw/gwnwn5ofNjPbwKigGmZgqQ75hmloFQFBrWEJeJkpj2UkvyXDGYrl2KaH/tyjFcHrMcuVMiVdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zXYidvXG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zXYidvXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF271F000E9;
	Mon, 10 Aug 2026 18:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786386183;
	bh=x5bn+R/172rAVdglQxRCjNPAwG1wG1yAUDiY7VIQD1g=;
	h=Date:To:From:Subject;
	b=zXYidvXGu+SzWX/mFHU7LV63X/1PecZNTZZ6aXbMdwcLyRcyCaEI1l9JzIfjBD5Mj
	 ihDwSEdHXo1s5/c7SZz7l5Rwi6rY8H306XST/YEi+CoGfXojtrdoOtdASN+VWP+WXf
	 Y+sjrCHjAQ8Te5OiuoPgPzfKRvo/9BCIsLazSy84=
Date: Mon, 10 Aug 2026 11:23:03 -0700
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,cuiyunhui@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-gup_test-fix-race-with-pin_longterm_test-ioctls.patch removed from -mm tree
Message-Id: <20260810182303.6AF271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup_test: fix race with PIN_LONGTERM_TEST ioctls
has been removed from the -mm tree.  Its filename was
     mm-gup_test-fix-race-with-pin_longterm_test-ioctls.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Yunhui Cui <cuiyunhui@bytedance.com>
Subject: mm/gup_test: fix race with PIN_LONGTERM_TEST ioctls
Date: Mon, 8 Jun 2026 10:50:42 +0800

The PIN_LONGTERM_TEST helpers keep their state in global variables that
are protected by pin_longterm_test_mutex when accessed from ioctl(). 
However, gup_test_release() calls pin_longterm_test_stop() without holding
that mutex.

This can race with PIN_LONGTERM_TEST_STOP and let two callers operate on
the same pages array concurrently, corrupting the test state and possibly
freeing it twice:

 CPU 0                              CPU 1
 -----                              -----
 ioctl(PIN_LONGTERM_TEST_STOP)
   mutex_lock(&pin_longterm_test_mutex)
   pin_longterm_test_stop()
     if (pin_longterm_test_pages)
       kvfree(pin_longterm_test_pages)

                                    close()
                                      gup_test_release()
                                        pin_longterm_test_stop()
                                          if (pin_longterm_test_pages)
                                            kvfree(pin_longterm_test_pages)

     pin_longterm_test_pages = NULL
   mutex_unlock(&pin_longterm_test_mutex)

Protect the release path with the same mutex so that stop and release
cannot run pin_longterm_test_stop() concurrently.

John observed "this fix is purely static code analysis hygiene:
correcting a theoretical problem that does not actually provide any
sort of vulnerability fix in the kernel".

Link: https://lore.kernel.org/20260608025043.88087-1-cuiyunhui@bytedance.com
Fixes: c77369b437f9 ("mm/gup_test: start/stop/read functionality for PIN LONGTERM test")
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/gup_test.c~mm-gup_test-fix-race-with-pin_longterm_test-ioctls
+++ a/mm/gup_test.c
@@ -377,7 +377,9 @@ static long gup_test_ioctl(struct file *
 
 static int gup_test_release(struct inode *inode, struct file *file)
 {
+	mutex_lock(&pin_longterm_test_mutex);
 	pin_longterm_test_stop();
+	mutex_unlock(&pin_longterm_test_mutex);
 
 	return 0;
 }
_

Patches currently in -mm which might be from cuiyunhui@bytedance.com are

riscv-mm-exclude-invalid-thp-pmds-from-page-table-check.patch

