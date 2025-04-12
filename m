Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5334DDAB
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418031; cv=none; b=Ze9o0ZrWW+FZeFBurz1xbPmbKk2mi9B3Mf8vSnhlrzIP0VrHjknYimtUsclEubeUbTfvANbId4/GqNlv+50YffwrhVnYlbtdLcYkDb25s0NG2EKP9KG0lw5JB2iD3YOkDuLAzycAfXyTNUv0BtqkEr1MsHrCpoA7MiOjz6OG8QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418031; c=relaxed/simple;
	bh=12pFY0y47VSlP30+LGnKHGlMvBvSZezy6IHRjUoTIaw=;
	h=Date:To:From:Subject:Message-Id; b=nigybSb8UOo7HNyE5y1kWCiXrBkHnwXK8dVpCKG+fYe2wVVNPoh10rJMc6alAAXLyjwryQismY2fruA46DhHZLWxhnuiDgHzwvZnGV9Xey/RFnHXKZ5mE4NGCTNTYMTzCGRkrynj68lV2L6UbnYM/3zmHBdzMZ8wVUik8ye/kac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wrrER+p8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wrrER+p8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A91FC4CEE2;
	Sat, 12 Apr 2025 00:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418031;
	bh=12pFY0y47VSlP30+LGnKHGlMvBvSZezy6IHRjUoTIaw=;
	h=Date:To:From:Subject:From;
	b=wrrER+p8y4jl/oUTIVQ2ytNeQtLq9PrgPaH31Rq6L79+Z3iBQSfwUv75glTtJlro7
	 b4iQq8Dxdq+tfUNjk0nZu9MZ0qCrk1/bRsGOGWkxUndPo5/5b9cV72PLmpyPlaw7Dv
	 QV6/guW4wWaOWv5rgm8Trk2+NsGPwm6Vu+lgwgfo=
Date: Fri, 11 Apr 2025 17:33:51 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-compiler-wmaybe-uninitialized-warning.patch removed from -mm tree
Message-Id: <20250412003351.9A91FC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix compiler -Wmaybe-uninitialized warning
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-compiler-wmaybe-uninitialized-warning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: selftests/mm: fix compiler -Wmaybe-uninitialized warning
Date: Wed, 9 Apr 2025 15:20:06 +0530

Following build warning comes up for cow test as 'transferred' variable has
not been initialized. Fix the warning via zero init for the variable.

  CC       cow
cow.c: In function `do_test_vmsplice_in_parent':
cow.c:365:61: warning: `transferred' may be used uninitialized [-Wmaybe-uninitialized]
  365 |                 cur = read(fds[0], new + total, transferred - total);
      |                                                 ~~~~~~~~~~~~^~~~~~~
cow.c:296:29: note: `transferred' was declared here
  296 |         ssize_t cur, total, transferred;
      |                             ^~~~~~~~~~~
  CC       compaction_test
  CC       gup_longterm

Link: https://lkml.kernel.org/r/20250409095006.1422620-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-fix-compiler-wmaybe-uninitialized-warning
+++ a/tools/testing/selftests/mm/cow.c
@@ -293,7 +293,7 @@ static void do_test_vmsplice_in_parent(c
 		.iov_base = mem,
 		.iov_len = size,
 	};
-	ssize_t cur, total, transferred;
+	ssize_t cur, total, transferred = 0;
 	struct comm_pipes comm_pipes;
 	char *old, *new;
 	int ret, fds[2];
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-ptdump-split-note_page-into-level-specific-callbacks.patch
mm-ptdump-split-effective_prot-into-level-specific-callbacks.patch
arm64-mm-define-ptdesc_t.patch

