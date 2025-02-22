Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33FD3FFD
	for <mm-commits@vger.kernel.org>; Sat, 22 Feb 2025 00:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740183064; cv=none; b=IDIy/XCppQFp0KjMJReyuNIvqGD7m1qSHvDQVQfAnrYqFkew4DLaMF5YCsBPM3DckgFuDnksEFySNQWp3XFxcLMNbAPlAvzF7RvrnkTKySEV5Z/xF7c41s3w71PWGcES0SDGdTD3huN06MKRqj0hng2stx0tfR1pg8eWsg7INaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740183064; c=relaxed/simple;
	bh=S95iatLiOHsDB8pTWWhNE99wnCKvNQbHVE3yDWHA5+U=;
	h=Date:To:From:Subject:Message-Id; b=fiDBH84MlX1Dt+M5OXsOcbVHI8mHj0qNEWaSKu5nOiKCNNVPpQohZUgUgRibrZx4AlNJ95OI7eaFCZZ9YxpEFSyxV2q8pm2NXQw5ZFKVm/Il1vzqxSSZlJCpTkqCSzwO2b9EIbfx3RDQcFi58jZUohpLfyKvX8XliiG2fLGB1I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=djKuIDT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="djKuIDT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64255C4CED6;
	Sat, 22 Feb 2025 00:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740183064;
	bh=S95iatLiOHsDB8pTWWhNE99wnCKvNQbHVE3yDWHA5+U=;
	h=Date:To:From:Subject:From;
	b=djKuIDT1ksjpK1CEIpmNE0fvOrvmfmrlEZEUBv99PgbJmTyrawodkbVcCx9vDKd6t
	 42HYHGl/ReFGXQ1QZdTyF9RKaK8HGAp31EcH64MdfGx85ybwy48PWXBAw62ugW/mpK
	 6mUcLIgTRmJxBN/ceMpo8PG0WpPsgPRcKslN2vLs=
Date: Fri, 21 Feb 2025 16:11:03 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch added to mm-unstable branch
Message-Id: <20250222001104.64255C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip uffd-stress if userfaultfd not available
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch

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
Subject: selftests/mm: skip uffd-stress if userfaultfd not available
Date: Fri, 21 Feb 2025 18:25:42 +0000

It's pretty obvious that the test wouldn't work if you don't have the
feature enabled.  But, it's still useful to SKIP instead of failing so the
reader can immediately tell that this is the reason why.

Link: https://lkml.kernel.org/r/20250221-mm-selftests-v2-3-28c4d66383c5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-skip-uffd-stress-if-userfaultfd-not-available
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -412,8 +412,8 @@ static void parse_test_type_arg(const ch
 	 * feature.
 	 */
 
-	if (uffd_get_features(&features))
-		err("failed to get available features");
+	if (uffd_get_features(&features) && errno == ENOENT)
+		ksft_exit_skip("failed to get available features (%d)\n", errno);
 
 	test_uffdio_wp = test_uffdio_wp &&
 		(features & UFFD_FEATURE_PAGEFAULT_FLAG_WP);
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-fix-assumption-that-sudo-is-present.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_threads.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longerm-tests-on-weird-filesystems.patch

