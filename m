Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C445C1EB5E7
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 17:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741714618; cv=none; b=D/zjRSBFUtEeDBm/tExYjI0qdK54rDAEh2qSCWGc6tytMNqPgkIbunpQ+59BHEKAdLOIXCEIR0x+OsBTjXJ/OPpEqorzLQHrm725d8qoAe6gTCqqRzT4X24kAPo+rP0erm03ybSCHMmUJQUsW968FbWKM80i+TpBbM5wuFveT8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741714618; c=relaxed/simple;
	bh=hoLBeyoSBvVVK2XeOETrWJdJrvEKbXsS4DQ9wj7zCek=;
	h=Date:To:From:Subject:Message-Id; b=pB+I9oxH51yadZrjHL3MsR4fVcVOG51uRZ6cYLf/YfD3vYlELa5rbvd8iFlkcAtJo1DS//h/hwTe6EFr7CmnSpu/mZiaX1r3/ytugMFD6XfYev6Mvv2yongt1jMzpi8Ak4w3534neRnatiHa551zBqj/4r0U+GdahBT61DgkwWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2mwxMaCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2mwxMaCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBD0C4CEE9;
	Tue, 11 Mar 2025 17:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741714618;
	bh=hoLBeyoSBvVVK2XeOETrWJdJrvEKbXsS4DQ9wj7zCek=;
	h=Date:To:From:Subject:From;
	b=2mwxMaCxohkyMGK1/AFKqm/WjKvV4R/YJRI3znoMB5s6PJwvwe5QeF7ABEMU/wayA
	 RBg0xvQyhKDkIUUe4A82JpKU0F5Ab8nXHQBMGnthsTj9ewcQC0TvaEaEeKRo+s3dlv
	 r2mKagH8bcUFYiWWADU42ZKu3/urhzBcNTACLp4I=
Date: Tue, 11 Mar 2025 10:36:58 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-gup_longterm-tests-on-weird-filesystems.patch added to mm-unstable branch
Message-Id: <20250311173658.8EBD0C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip gup_longterm tests on weird filesystems
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-gup_longterm-tests-on-weird-filesystems.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-gup_longterm-tests-on-weird-filesystems.patch

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
Subject: selftests/mm: skip gup_longterm tests on weird filesystems
Date: Tue, 11 Mar 2025 13:18:19 +0000

Some filesystems don't support ftruncate()ing unlinked files.  They return
ENOENT.  In that case, skip the test.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-8-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-skip-gup_longterm-tests-on-weird-filesystems
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -96,7 +96,15 @@ static void do_test(int fd, size_t size,
 	int ret;
 
 	if (ftruncate(fd, size)) {
-		ksft_test_result_fail("ftruncate() failed (%s)\n", strerror(errno));
+		if (errno == ENOENT) {
+			/*
+			 * This can happen if the file has been unlinked and the
+			 * filesystem doesn't support truncating unlinked files.
+			 */
+			ksft_test_result_skip("ftruncate() failed with ENOENT\n");
+		} else {
+			ksft_test_result_fail("ftruncate() failed (%s)\n", strerror(errno));
+		}
 		return;
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

