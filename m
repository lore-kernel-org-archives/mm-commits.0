Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F79B2163B2
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188348; cv=none; b=bGgqa+2ur/HMzCGQnFFntx4AA5ryJvJ5mmkYgFYvQyOQgKTjfMUnnnpw3titzF1rUZYztQ1EEi83eYuZtnHjWmoVp3+qQCHXCGEAPDcXqcLNJVq7laaizkcQHgmFQy1DGiBYbEIPO6+rd4sWcJC04qnbegwGqF5bTR2ihpPwOzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188348; c=relaxed/simple;
	bh=rdimdVanBu1EMHChon8OBIVdmTra6oW18vCsF2eQjCs=;
	h=Date:To:From:Subject:Message-Id; b=K0gFpABdi0Tgqgeio7VhfLJY0ahaMEiLtAmt1LzjXMst7ec6bmbrgZ54UyswJc5JRdmgDO46oG8mJ90sK/pJZHP9Sm9Bho72oOE5aXoACs586JQw639PxN78HyT6ed6kq0TZZFPReOhfHLDBPUn99UgbGu9CDDLbQvDauKr/Rp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vizog4yd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vizog4yd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF02C4CEED;
	Mon, 17 Mar 2025 05:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188348;
	bh=rdimdVanBu1EMHChon8OBIVdmTra6oW18vCsF2eQjCs=;
	h=Date:To:From:Subject:From;
	b=vizog4ydl2y1WqrMawcz8roLq65SB9xHhqwPXO16S6HxHRuwzpe+S1zpUTk2Ws5JT
	 WQy+NTKF9p7fdi4/fmLGQvmxQJ2xpAYPRIBo5CET5FLQWdB0xYsbA4zL5h7YFQZKre
	 TUQ28vciPw467vGdPSrka1UVS8nBPvjoH/K1wZ3I=
Date: Sun, 16 Mar 2025 22:12:27 -0700
To: mm-commits@vger.kernel.org,ujwal.kundur@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-spelling.patch removed from -mm tree
Message-Id: <20250317051228.0EF02C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix spelling
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-spelling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


