Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA625539A
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 00:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730160088; cv=none; b=SV3DNcbMwo+Kh1wi6JrIk52DPR45xa4Mko6BjzY32u/PmCdulGqOi/rYzHi0ok4bYPlxHmIfE63oeAoNhGjd8fslID6ew/I5zEwM+aIIUVp4QE1rZCXz6hioRek1h3jH4kqFJCEZSjgtzuol1X+SjaMYQnJtVxcemDeGZbwLOX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730160088; c=relaxed/simple;
	bh=cYpY+t67x5V77e0PPt9JLV6xGkBtDCkA42hf6zfo4yQ=;
	h=Date:To:From:Subject:Message-Id; b=h6XJCcJ0ZDgKw0/V8TyGnbnA6A1YLZLFF+2FDyIPuuNxbENAoVQr2cIBxUYdP2Ag7QXcJNdBerkVcItnxxXcxHHmZP86RpgXUwrgNoZELwEBIeMBc1hBdD3KkLsUG9e3pkwsvIqTzPLMicLDIfYQYj3T6TyMb9EGlSBzg1ig7wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bii0F8oe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bii0F8oe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6E5C4CEC3;
	Tue, 29 Oct 2024 00:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730160088;
	bh=cYpY+t67x5V77e0PPt9JLV6xGkBtDCkA42hf6zfo4yQ=;
	h=Date:To:From:Subject:From;
	b=bii0F8oej3y7eZJz71VK5iNrrXZOMKwoEAdLvQgR19Npww6j5uaf1ftXTUgKveYvF
	 vz89Cprw4muTdmhGcDGy0LRAMtiPmMAiBz8ez9WbslXkwFSRHLoO562j325kR/bf+j
	 cH4NwOfCNYoIxkldP11ejpJinViqgZq7ZjbjxveY=
Date: Mon, 28 Oct 2024 17:01:27 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,apanyaki@amazon.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures.patch added to mm-unstable branch
Message-Id: <20241029000128.5B6E5C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/debugfs_duplicate_context_creation: hide errors from expected file write failures
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/debugfs_duplicate_context_creation: hide errors from expected file write failures
Date: Mon, 28 Oct 2024 16:30:56 -0700

debugfs_duplicate_context_creation.sh does an invalid file write to ensure
it fails.  Check of the failure is sufficient, so the error message from
the failure only makes the output unnecessarily noisy.  Hide it.

Link: https://lkml.kernel.org/r/20241028233058.283381-5-sj@kernel.org
Fixes: ade38b8ca5ce ("selftest/damon: add a test for duplicate context dirs creation")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Andrew Paniakin <apanyaki@amazon.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/debugfs_duplicate_context_creation.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/debugfs_duplicate_context_creation.sh~selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures
+++ a/tools/testing/selftests/damon/debugfs_duplicate_context_creation.sh
@@ -12,7 +12,7 @@ then
 	exit 1
 fi
 
-if echo foo > "$DBGFS/mk_contexts"
+if echo foo > "$DBGFS/mk_contexts" 2> /dev/null
 then
 	echo "duplicate context creation success"
 	exit 1
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message.patch
selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result.patch
selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures.patch
mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit.patch
mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment.patch

