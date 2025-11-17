Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A482531577B
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 17:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763398910; cv=none; b=ZGO3NQ+bqwbk7UALFydhnxOZvbk8bU6CLB10S2JRcq+Y/g6seV42grSV+UsHUg6+kOlMxOqMl5JVYM6wBIIb8rosPPbz8uB0a8tvDN3E1m8up1JI6rj0g5KlePkmWOKJy8ArTLNVqPJYz07A3ogtLjB5BkS0Ro1xFXJx/icnuBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763398910; c=relaxed/simple;
	bh=ZNFfFG4rQvWzcfiIqCbQ1R1VZ9Q1UI9hjo76dHtyBBQ=;
	h=Date:To:From:Subject:Message-Id; b=cb7iaoxgMl0T8YykDqPkY1sWcC4l2AbDQxCU16kzi5tF3Cx9TtyeeF057V66xZY+7rRCwOdw1Z4+QRscVR3uiWnhLAFqEqV5vfrQCk7EzVnZPBrJ0t5NEgZJ3UjJzFQUKxMMs8VqWFBTdOkhen48NLLgG15T+lZfvz6ZtMYOTzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iFQI3bMU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iFQI3bMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D989C19424;
	Mon, 17 Nov 2025 17:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763398910;
	bh=ZNFfFG4rQvWzcfiIqCbQ1R1VZ9Q1UI9hjo76dHtyBBQ=;
	h=Date:To:From:Subject:From;
	b=iFQI3bMUujxr4DHF3o7ozCIlG1T37NY3qjA/pxUjEMBDXDOL88UwHIXYsUesnjqP2
	 m/hT5XXSmqCo1TRiYxrwCOwtsWe19lNHThUvkuQyIkySfxd6Ks/rWiGWpn/FbXtz76
	 qWNj8PcY25X/oPXvUGT3lLU80s2sxNbP1ya7V2wc=
Date: Mon, 17 Nov 2025 09:01:48 -0800
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,dan.j.williams@intel.com,peng8420.li@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-gup_test-fix-comment-regarding-origin-of-foll_write.patch added to mm-new branch
Message-Id: <20251117170150.0D989C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: gup_test: fix comment regarding origin of FOLL_WRITE
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-gup_test-fix-comment-regarding-origin-of-foll_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-gup_test-fix-comment-regarding-origin-of-foll_write.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Peng Li <peng8420.li@gmail.com>
Subject: selftests/mm: gup_test: fix comment regarding origin of FOLL_WRITE
Date: Mon, 17 Nov 2025 23:40:12 +0800

The 'FOLL_WRITE' of the copied source is located in mm_types.h of mm, not
mm.h, so fix it.

Link: https://lkml.kernel.org/r/20251117154012.197499-2-peng8420.li@gmail.com
Signed-off-by: Peng Li <peng8420.li@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/gup_test.c~selftests-mm-gup_test-fix-comment-regarding-origin-of-foll_write
+++ a/tools/testing/selftests/mm/gup_test.c
@@ -17,7 +17,7 @@
 
 #define MB (1UL << 20)
 
-/* Just the flags we need, copied from mm.h: */
+/* Just the flags we need, copied from the kernel internals. */
 #define FOLL_WRITE	0x01	/* check pte is writable */
 
 #define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
_

Patches currently in -mm which might be from peng8420.li@gmail.com are

selftests-mm-gup_test-stop-testing-foll_touch.patch
selftests-mm-gup_test-fix-comment-regarding-origin-of-foll_write.patch

