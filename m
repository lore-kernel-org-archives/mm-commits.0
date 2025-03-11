Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190051D514A
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 17:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741714627; cv=none; b=onc/g7YbMQn9so+Cx5LnqD7csylxryz7criXVHk8zZTmi9XzPa5fKPAEV36jD30aR89wPIv3A6Z0uOyWcaLbgDq0aF7O2Eeh3hNrrAaGecEFIjcrzNDH9zBsVZrh37eFhr4t1Ma/UUzGN5HDQCDxlcBhF927gkPJB0CntAFuFew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741714627; c=relaxed/simple;
	bh=TBHDqPHOWkrwrWxT50Z8/qgJ7pIfpk5xfJ/4adt/qf0=;
	h=Date:To:From:Subject:Message-Id; b=qeGu6pDxRWaFzNA0dDadPDZdGMmzPGYeUDRj97UgemRBxy2uBFhQkqQE60iyiQaR5zEdv4MsZZcN3F8YTV24V7ToHyOB2j/L/3ayZKcpUaYHAsmDeBoaKloiUyAONEU7kHtU/YdS6wiQ/hjPhpRogsAgNSKZUue8zZRzelCUC/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rIWwRVPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rIWwRVPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADD9C4CEE9;
	Tue, 11 Mar 2025 17:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741714626;
	bh=TBHDqPHOWkrwrWxT50Z8/qgJ7pIfpk5xfJ/4adt/qf0=;
	h=Date:To:From:Subject:From;
	b=rIWwRVPpN6bj/Mondb2HBh46N+7yHIYeEiUDCvYjVafdM5TWuGgbLYcYO4YPiZxpG
	 7QvSe+aG+lsoplSk+IgDNlrACT/kIsbfMwe/C/CPP4UWHKixkqVUa67z1z68CIYpKi
	 +noHR2atjr67ziXjWJWvZ/7yGByEBatLcHmU74/0=
Date: Tue, 11 Mar 2025 10:37:06 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mlock-print-error-on-failure.patch added to mm-unstable branch
Message-Id: <20250311173706.8ADD9C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/mlock: print error on failure
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-mlock-print-error-on-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mlock-print-error-on-failure.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm/mlock: print error on failure
Date: Tue, 11 Mar 2025 13:18:23 +0000

It's not really possible to start diagnosing this without knowing the
actual error.

Also update the mlock2 helper to behave like libc would by setting errno
and returning -1.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-12-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mlock-random-test.c |    4 ++--
 tools/testing/selftests/mm/mlock2.h            |    8 +++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/mlock2.h~selftests-mm-mlock-print-error-on-failure
+++ a/tools/testing/selftests/mm/mlock2.h
@@ -6,7 +6,13 @@
 
 static int mlock2_(void *start, size_t len, int flags)
 {
-	return syscall(__NR_mlock2, start, len, flags);
+	int ret = syscall(__NR_mlock2, start, len, flags);
+
+	if (ret) {
+		errno = ret;
+		return -1;
+	}
+	return 0;
 }
 
 static FILE *seek_to_smaps_entry(unsigned long addr)
--- a/tools/testing/selftests/mm/mlock-random-test.c~selftests-mm-mlock-print-error-on-failure
+++ a/tools/testing/selftests/mm/mlock-random-test.c
@@ -161,9 +161,9 @@ static void test_mlock_within_limit(char
 				       MLOCK_ONFAULT);
 
 		if (ret)
-			ksft_exit_fail_msg("%s() failure at |%p(%d)| mlock:|%p(%d)|\n",
+			ksft_exit_fail_msg("%s() failure (%s) at |%p(%d)| mlock:|%p(%d)|\n",
 					   is_mlock ? "mlock" : "mlock2",
-					   p, alloc_size,
+					   strerror(errno), p, alloc_size,
 					   p + start_offset, lock_size);
 	}
 
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_parallel.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longterm-tests-on-weird-filesystems.patch
selftests-mm-drop-unnecessary-sudo-usage.patch
selftests-mm-ensure-uffd-wp-mremap-gets-pages-of-each-size.patch
selftests-mm-skip-mlock-tests-if-nobody-user-cant-read-it.patch
selftests-mm-mlock-print-error-on-failure.patch
mm-page_alloc-warn-on-nr_reserved_highatomic-underflow.patch
mm-page_alloc-clarify-terminology-in-migratetype-fallback-code.patch
mm-page_alloc-clarify-should_claim_block-commentary.patch
scripts-gdb-add-lx_per_cpu_ptr.patch

