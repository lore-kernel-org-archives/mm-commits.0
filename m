Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A64271450
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 23:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756423533; cv=none; b=jILPvthrF6yFHtLis9y+BmhTTHIhbmZfwa+xm5FLaFI5tEMTQmv1XkGWAkjXLgVvnt76gT1bQJFQsqfZjotIYc6bBvyUvZ/oNqrF1aiBQQUUI9y6EkpDPQbkGbDpiuVH9Xva53/sxCiDdV+KOt7okYWGNTmIk2vryh2xCG2NLx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756423533; c=relaxed/simple;
	bh=qTWjoP5SxDSmPZXVZtXVsMbkj/RVKrSMb3zd2rGx2Sc=;
	h=Date:To:From:Subject:Message-Id; b=Hpj9N2yEtsPcv4sw7k82b8nT7NRp6JfXgVxiE+EcJnMIlROH3pPC3cEzAQUw+hNaJpTwXgcJ63wxl4ztoae6bwDg1n8YTBm/8bnzB+J3IO8iCP8OWqLyceVfk2dJ80jdv6IzJS+Gr6/5jizrDTHN0jyph+gmus7zWxL/wGqqAUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y1PJ4tvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y1PJ4tvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE795C4CEF4;
	Thu, 28 Aug 2025 23:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756423532;
	bh=qTWjoP5SxDSmPZXVZtXVsMbkj/RVKrSMb3zd2rGx2Sc=;
	h=Date:To:From:Subject:From;
	b=y1PJ4tvx+f06VHdt5OfCDLrjoUfQvhC4NcK6MW7ZbUQIZ7vucNzOhifXwnaOBOR7H
	 XnVhAYiwXBCc7e2zpyxVjXhu90ZLR+mI/W+NDb04zHJ5Eh/WyHm1YhFZd472Sb5xzu
	 ntzhTCNSYC9M9esNM7eV/Pe43yMefMr7SdiDyyZg=
Date: Thu, 28 Aug 2025 16:25:32 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-testing-for-32-bit-builds.patch added to mm-new branch
Message-Id: <20250828232532.AE795C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix testing for 32 bit builds
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-fix-testing-for-32-bit-builds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-testing-for-32-bit-builds.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: maple_tree: fix testing for 32 bit builds
Date: Wed, 27 Aug 2025 20:30:22 -0400

Patch series "maple_tree: Fix testing for 32bit compiles".

The maple tree test suite supports 32bit builds which causes 32bit nodes
and index/last values.  Some tests have too large values and must be
skipped while others depend on certain actions causing the tree to be
altered in another measurable way (such as the height decreasing or
increasing).

Two tests were added that broke 32bit testing, either by compile warnings
or failures.  These fixes restore the tests to a working order.

Building 32bit version can be done on a 32bit platform, or by using a
command like: BUILD=32 make clean maple


This patch (of 2):

Some tests are invalid on 32bit due to the size of the index and last. 
Making those tests depend on the correct build flags stops compile
complaints.

Link: https://lkml.kernel.org/r/20250828003023.418966-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20250828003023.418966-2-Liam.Howlett@oracle.com
Fixes: 5d659bbb52a2 ("maple_tree: introduce mas_wr_store_type()")
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/radix-tree/maple.c~maple_tree-fix-testing-for-32-bit-builds
+++ a/tools/testing/radix-tree/maple.c
@@ -36428,6 +36428,7 @@ static void check_nomem_writer_race(stru
   */
 static inline int check_vma_modification(struct maple_tree *mt)
 {
+#if defined(CONFIG_64BIT)
 	MA_STATE(mas, mt, 0, 0);
 
 	mtree_lock(mt);
@@ -36451,6 +36452,8 @@ static inline int check_vma_modification
 
 	mas_destroy(&mas);
 	mtree_unlock(mt);
+#endif
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-fix-testing-for-32-bit-builds.patch

