Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE0DA47
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 04:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739853047; cv=none; b=JK484CSVbMEOiZ001fhHICJ1JzNzsM1xoLCBZxyJwcVPN7ngFkOvhZdTJVrOYgK5yepGDFULwYHnK4aaHgquJNSn9IgMsyo9RGYFt9ykueyzZdimvoPuxg1JAGo52hmg+CwoDjTolkXynauZ3UasGctWD93WYewg2PbYxEmyJ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739853047; c=relaxed/simple;
	bh=nB/luIG1pT1L8LK2Xt7HJbbGxS+ep89yCw+GBv7swqA=;
	h=Date:To:From:Subject:Message-Id; b=VyBonH29J8d3cAkaIkXsxLI/IuOQKp+E8dM+oIqRznLHydbvgGdbQQONV7KPfWBnw4SC4cx+CEtC0XHTnGGU+oN45o3dK0POrCLbxS/gdjjw1XGgEM1Ciou0Ao5KqxDqlra8cOhWkMXdmsnzX/qeiA5y/SmIIjQUvKt/RQ4W+W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sJxCAVLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sJxCAVLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE765C4CEE2;
	Tue, 18 Feb 2025 04:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739853046;
	bh=nB/luIG1pT1L8LK2Xt7HJbbGxS+ep89yCw+GBv7swqA=;
	h=Date:To:From:Subject:From;
	b=sJxCAVLo8MH184vtuerc0apMdavPpcTNQfyKjh66kEbv+uq6Jyi/f5nmzTNHt6+UU
	 mtnNS526NJ7OvmFLuRXRAhLnc3dgZ0/bCGSubsV7GKDHs9ORWIQ7gd1QP6BqJMla55
	 WkT/h3pJPgsH+hnptj8s4y2cTvET4J9ZByccG8cw=
Date: Mon, 17 Feb 2025 20:30:46 -0800
To: mm-commits@vger.kernel.org,ujwal.kundur@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-spelling.patch added to mm-unstable branch
Message-Id: <20250218043046.AE765C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix spelling
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-spelling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-spelling.patch

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
From: Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: selftests/mm: fix spelling
Date: Sat, 15 Feb 2025 13:48:03 +0530

Fix misspelling flagged by codespell.

Link: https://lkml.kernel.org/r/20250215081803.1793-1-ujwal.kundur@gmail.com
Signed-off-by: Ujwal Kundur <ujwal.kundur@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-fix-spelling
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -348,7 +348,7 @@ int uffd_test_ctx_init(uint64_t features
 	/*
 	 * After initialization of area_src, we must explicitly release pages
 	 * for area_dst to make sure it's fully empty.  Otherwise we could have
-	 * some area_dst pages be errornously initialized with zero pages,
+	 * some area_dst pages be erroneously initialized with zero pages,
 	 * hence we could hit memory corruption later in the test.
 	 *
 	 * One example is when THP is globally enabled, above allocate_area()
_

Patches currently in -mm which might be from ujwal.kundur@gmail.com are

documentation-fix-doc-link-to-fault-injectionrst.patch
selftests-mm-fix-spelling.patch

