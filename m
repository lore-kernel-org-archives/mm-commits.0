Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2691332604;
	Thu, 26 Mar 2026 22:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774564803; cv=none; b=BeF7ycT+qb+RPNzGnL9KducPI8cJx84v8ykt9TrrDgA47q8U53qQaU5kRcLbCHEGa4Ron7exs7ZcvDXhUNvT1jshZB21CN5JKGir2utW6EcQW3NP7FvghHpQwvCaF67fTOAEFD47/04HO1K7barw9nAzw9xP6xljVDqJSeKri2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774564803; c=relaxed/simple;
	bh=oh80rKsHBrtYcSrCoMb+q7py+fza9k3+/UWp0y1ZT8c=;
	h=Date:To:From:Subject:Message-Id; b=t12J+2DmuUnbEPPsWUHUMFiUkSfSBOcJBRyDuS7bIx1VxSnN1wR7x6WxrRPAzbOK7zZNAMkXV8eg8I8FcGd6r8EARi28f+LTd9Y9tIVZf/zCflgdmr89d7kov5trQlXPuxri/tCsKNTkfDOB1OrJbO6Vw02l622e3hQMmqS05yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Exhf8utC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Exhf8utC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5354C116C6;
	Thu, 26 Mar 2026 22:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774564802;
	bh=oh80rKsHBrtYcSrCoMb+q7py+fza9k3+/UWp0y1ZT8c=;
	h=Date:To:From:Subject:From;
	b=Exhf8utClP4KNk9G51G9SWgFUmq/jp9ScqvJ8AYDW6utttW07AUtPYKArxnOOGcZk
	 EQS2q0XHZSTzhOyAy0bOg5J4n468/V5A6MMC+xTe7Cu2xjIda2mqgIq8BVi+B0M6pa
	 8AcibKhCvs/Ne8jSJZ6GdHiAiILP6KjiOmveArls=
Date: Thu, 26 Mar 2026 15:40:01 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pmladek@suse.com,kees@kernel.org,dhowells@redhat.com,davidgow@google.com,lk@c--e.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-scatterlist-fix-length-calculations-in-extract_kvec_to_sg.patch added to mm-nonmm-unstable branch
Message-Id: <20260326224002.A5354C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/scatterlist: fix length calculations in extract_kvec_to_sg
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-scatterlist-fix-length-calculations-in-extract_kvec_to_sg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-scatterlist-fix-length-calculations-in-extract_kvec_to_sg.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: "Christian A. Ehrhardt" <lk@c--e.de>
Subject: lib/scatterlist: fix length calculations in extract_kvec_to_sg
Date: Thu, 26 Mar 2026 22:49:01 +0100

Patch series "Fix bugs in extract_iter_to_sg()", v3.

Fix bugs in the kvec and user variants of extract_iter_to_sg.  This series
is growing due to useful remarks made by sashiko.dev.

The main bugs are:
- The length for an sglist entry when extracting from
  a kvec can exceed the number of bytes in the page. This
  is obviously not intended.
- When extracting a user buffer the sglist is temporarily
  used as a scratch buffer for extracted page pointers.
  If the sglist already contains some elements this scratch
  buffer could overlap with existing entries in the sglist.

The series adds test cases to the kunit_iov_iter test that demonstrate all
of these bugs.  Additionally, there is a memory leak fix for the test
itself.

The bugs were orignally introduced into kernel v6.3 where the function
lived in fs/netfs/iterator.c.  It was later moved to lib/scatterlist.c in
v6.5.  Thus the actual fix is only marked for backports to v6.5+.


This patch (of 5):

When extracting from a kvec to a scatterlist, do not cross page
boundaries.  The required length was already calculated but not used as
intended.

Adjust the copied length if the loop runs out of sglist entries without
extracting everything.

While there, return immediately from extract_iter_to_sg if there are no
sglist entries at all.

A subsequent commit will add kunit test cases that demonstrate that the
patch is necessary.

Link: https://lkml.kernel.org/r/20260326214905.818170-1-lk@c--e.de
Link: https://lkml.kernel.org/r/20260326214905.818170-2-lk@c--e.de
Fixes: 018584697533 ("netfs: Add a function to extract an iterator into a scatterlist")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Cc: David Gow <davidgow@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: <stable@vger.kernel.org>	[v6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/scatterlist.c~lib-scatterlist-fix-length-calculations-in-extract_kvec_to_sg
+++ a/lib/scatterlist.c
@@ -1247,7 +1247,7 @@ static ssize_t extract_kvec_to_sg(struct
 			else
 				page = virt_to_page((void *)kaddr);
 
-			sg_set_page(sg, page, len, off);
+			sg_set_page(sg, page, seg, off);
 			sgtable->nents++;
 			sg++;
 			sg_max--;
@@ -1256,6 +1256,7 @@ static ssize_t extract_kvec_to_sg(struct
 			kaddr += PAGE_SIZE;
 			off = 0;
 		} while (len > 0 && sg_max > 0);
+		ret -= len;
 
 		if (maxsize <= 0 || sg_max == 0)
 			break;
@@ -1409,7 +1410,7 @@ ssize_t extract_iter_to_sg(struct iov_it
 			   struct sg_table *sgtable, unsigned int sg_max,
 			   iov_iter_extraction_t extraction_flags)
 {
-	if (maxsize == 0)
+	if (maxsize == 0 || sg_max == 0)
 		return 0;
 
 	switch (iov_iter_type(iter)) {
_

Patches currently in -mm which might be from lk@c--e.de are

lib-scatterlist-fix-length-calculations-in-extract_kvec_to_sg.patch
lib-scatterlist-fix-temp-buffer-in-extract_user_to_sg.patch
lib-kunit_iov_iter-fix-memory-leaks.patch
lib-kunit_iov_iter-improve-error-detection.patch
lib-kunit_iov_iter-add-tests-for-extract_iter_to_sg.patch

