Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D473C6A35
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 20:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772484190; cv=none; b=uXWts43rFQw8Vu4P2sjspYG+Xo0Pw4xBEHAlOd1arIE4bOTfHpFhjVMBnDaPoG65JBp8hUDe1ZJ4sqvxykHosXnt7E69R4/AjeDIsU9xIX2qIE6V9EYn+V7o/euT+jMdhfpruJ/fPKizPbFlZaPLI7nqEXZxQb0Zv9cv1KyTrDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772484190; c=relaxed/simple;
	bh=8Q/FdEaukdVFSP+uzfgYQMl+1DYAuzSf7hJH2/pCTro=;
	h=Date:To:From:Subject:Message-Id; b=HRgr/rYUeXGAiEiSaQ4+uhryqjTW8qIS+mGhN2qx05ya7l/4W0FkwjiiDBxskoLqATZ8phpr+7Yyd9QUY/qv9Ap+adJt1de1ItPnNd6taBuLNkfSDTmkonNDG5fqb9V+O7mnpjTZeNfv8JuPpdbJchkmgF2ydeOtqAfDyDhA7v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mmuVPgqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mmuVPgqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E824DC19423;
	Mon,  2 Mar 2026 20:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772484190;
	bh=8Q/FdEaukdVFSP+uzfgYQMl+1DYAuzSf7hJH2/pCTro=;
	h=Date:To:From:Subject:From;
	b=mmuVPgqmFr3Yvj8WXNFnXI9Rr6k1CmELnwFgFDFG00y/xDlWey2CsBzm2GybEx4E+
	 uwSIcWaKrfrFly71dpCURY94NCsCKH6h6eQ3QlZkDFRAir4Yty4Z0aQb9cPXGv51cF
	 YFYL0NgSoQuh5Bn9K0v/VtEJdYfq9085a5/5sqqA=
Date: Mon, 02 Mar 2026 12:43:09 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,peterx@redhat.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,dywoq.contact@gmail.com,david@kernel.org,aleks.koyf@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning.patch added to mm-new branch
Message-Id: <20260302204309.E824DC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: initialize 'seq' in gup_fast to remove -Wmaybe-uninitialized warning
has been added to the -mm mm-new branch.  Its filename is
     mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Alexey Suchkov <aleks.koyf@gmail.com>
Subject: mm: initialize 'seq' in gup_fast to remove -Wmaybe-uninitialized warning
Date: Mon, 2 Mar 2026 22:34:05 +0300

The local variable 'seq' in gup_fast (mm/gup.c) was declared
without initialization which, with gcc-15.2.1 can trigger:

mm/gup.c:3165:20: warning: `seq' may be used uninitialized [-Wmaybe-uninitialized]

Work around this by initializing 'seq' to 0.  This does not change
behavior, since read_seqcount_retry() always writes to it before use.

Link: https://lkml.kernel.org/r/20260302193405.37961-1-dywoq.contact@gmail.com
Signed-off-by: Alexey Suchkov <dywoq.contact@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning
+++ a/mm/gup.c
@@ -3131,7 +3131,7 @@ static unsigned long gup_fast(unsigned l
 {
 	unsigned long flags;
 	int nr_pinned = 0;
-	unsigned seq;
+	unsigned int seq = 0;
 
 	if (!IS_ENABLED(CONFIG_HAVE_GUP_FAST) ||
 	    !gup_fast_permitted(start, end))
_

Patches currently in -mm which might be from aleks.koyf@gmail.com are

mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning.patch

