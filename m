Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9044C15C158
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 05:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706979; cv=none; b=sBNVFkYw/CWjzz4XHXKLjTuVjnN/ZO7WcASt7YyrwKTQgAmeOMLu3K0qApye+k8Ieyz7DvB8S9PIWCp4Jy5ziiNEaCVZoAUGZXdMNiZYz1XSRMaD7os9iPFiHQeQA7jb1UVJsy6ej3ZdcikTNIYxHIHxaudOFFBNfNZqafo7NGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706979; c=relaxed/simple;
	bh=JBhrXMdhc7va3Hv5yHKvzh9kLQlglLF42qcxLrM689M=;
	h=Date:To:From:Subject:Message-Id; b=fEwytFhT25Vf7J1VD0+gOqO3CiLF0PN5HL1+XlPAWgM6WMsTzOyiuUK88e8RZS60gX14IedzjNonPM3VjKG/r8yDqQyvUuRpf0PQJLrMtp6siMw34+bDH8Vi6x/CDsoP9mPtnMxbPOJBid4F9zSTbEqA8H6uOq3U8gYXd9qNBmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1IY798rt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1IY798rt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4870CC4CEEA;
	Thu, 12 Jun 2025 05:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749706979;
	bh=JBhrXMdhc7va3Hv5yHKvzh9kLQlglLF42qcxLrM689M=;
	h=Date:To:From:Subject:From;
	b=1IY798rtlyEC+UYYVYhHeH5XURoms72THvGUwo89+e4ayAPSdUmmVIYgQBGGLC18e
	 J8FwqkVf1Njn+6XOrsNKyHSn39aErjbt/4oDtw+dh5bcYE5w+Krnd69NO7WmGXumz4
	 OaVL7245YlrK7lDeA+KSxwTd1u6YpcxJlke4s5xc=
Date: Wed, 11 Jun 2025 22:42:58 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-skip-failed-memfd-setups-in-gup_longterm.patch removed from -mm tree
Message-Id: <20250612054259.4870CC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip failed memfd setups in gup_longterm
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-failed-memfd-setups-in-gup_longterm.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: skip failed memfd setups in gup_longterm
Date: Thu, 05 Jun 2025 22:34:31 +0100

Unlike the other cases gup_longterm's memfd tests previously skipped the
test when failing to set up the file descriptor to test.  Restore this
behavior to avoid hitting failures when hugetlb isn't configured.

Link: https://lkml.kernel.org/r/20250605-selftest-mm-gup-longterm-tweaks-v1-1-2fae34b05958@kernel.org
Fixes: 66bce7afbaca ("selftests/mm: fix test result reporting in gup_longterm")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reported-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Closes: https://lkml.kernel.org/r/a76fc252-0fe3-4d4b-a9a1-4a2895c2680d@lucifer.local
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-skip-failed-memfd-setups-in-gup_longterm
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -298,8 +298,11 @@ static void run_with_memfd(test_fn fn, c
 	log_test_start("%s ... with memfd", desc);
 
 	fd = memfd_create("test", 0);
-	if (fd < 0)
+	if (fd < 0) {
 		ksft_print_msg("memfd_create() failed (%s)\n", strerror(errno));
+		log_test_result(KSFT_SKIP);
+		return;
+	}
 
 	fn(fd, pagesize);
 	close(fd);
@@ -366,6 +369,8 @@ static void run_with_memfd_hugetlb(test_
 	fd = memfd_create("test", flags);
 	if (fd < 0) {
 		ksft_print_msg("memfd_create() failed (%s)\n", strerror(errno));
+		log_test_result(KSFT_SKIP);
+		return;
 	}
 
 	fn(fd, hugetlbsize);
_

Patches currently in -mm which might be from broonie@kernel.org are

kselftest-mm-clarify-errors-for-pipe.patch
selftests-mm-convert-some-cow-error-reports-to-ksft_perror.patch
selftests-mm-dont-compare-return-values-to-in-cow.patch
selftests-mm-add-messages-about-test-errors-to-the-cow-tests.patch
selftests-mm-check-for-yama-ptrace_scope-configuraiton-before-modifying-it.patch

