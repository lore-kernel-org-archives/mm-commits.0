Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0430629E116;
	Wed, 10 Jun 2026 01:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781055413; cv=none; b=PFWVyKrIzu2G3C1TVSvMY2Nt1B5K+MDotIfbgPeKHxV8h2Ma6+YWUaVy5VHfJddhk0TSWlAEfNE1kwscG9gSM/FlISu638I/R7BWudw5MIRk1l18Mtc8oGeoNqb4aGTdDFRNQmj8siKWzuk2N2OCxh43kFO6A+NYbhY3h0INmz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781055413; c=relaxed/simple;
	bh=/gl99GJgdfpcWRLZCqYYP8F4/G4eYXx83hWjrBVCNdc=;
	h=Date:To:From:Subject:Message-Id; b=SVksTgqA81P6qSb+xftuNUw326mputMzDnO+2GRJd0oyFQMfo4/P+jD1dr42w/e/bBG0ikOvBr6iLUzqBopE9cEnZ5fTblsIXY1Is8ttidK1SWK5vzCvSH/pPGwX6uTBADTY1CSWdmpsK2wNwrsdifJOUHD4O4W3IGIKQz7zaSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wgj+/lYo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wgj+/lYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A61F1F00893;
	Wed, 10 Jun 2026 01:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781055408;
	bh=ekXe1CvN8tWkS0sqK9fMmQJi2X1A0j10kSVWYcb/vbo=;
	h=Date:To:From:Subject;
	b=Wgj+/lYodbqUIKdQPV4j60yxQidDD7Ksu4TXYVielF3gVkY5LUU+oQ/kDcZgPbVig
	 dAN9BLabVVtB95WxKOQOKzLIu80yQ9erXxPjmqqBAMu76XBsIRAa7ntS6ougBilAmG
	 625R8/7w3pGwGVOsIgbd5VIHmAMuX6idRk0JOCV0=
Date: Tue, 09 Jun 2026 18:36:47 -0700
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,stable@vger.kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,cuiyunhui@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup_test-fix-race-with-pin_longterm_test-ioctls.patch added to mm-new branch
Message-Id: <20260610013648.2A61F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup_test: fix race with PIN_LONGTERM_TEST ioctls
has been added to the -mm mm-new branch.  Its filename is
     mm-gup_test-fix-race-with-pin_longterm_test-ioctls.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup_test-fix-race-with-pin_longterm_test-ioctls.patch

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

Link: https://lore.kernel.org/20260608025043.88087-1-cuiyunhui@bytedance.com
Fixes: c77369b437f9 ("mm/gup_test: start/stop/read functionality for PIN LONGTERM test")
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
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

mm-gup_test-fix-race-with-pin_longterm_test-ioctls.patch

