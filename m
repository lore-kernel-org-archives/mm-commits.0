Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6805D2F3E
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 00:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730160090; cv=none; b=AR60OSj2S60buJVLVb+TZkjIJaBZSINABVCH8LIC7j6JbnNq6uW62sAwi+JA6VTFsuWc6uLl33JoML8s0RbGHplr665swwIePxqZJ8yQiI5qByFiUb/jjGtUutsuz7XmeEMRSTrXcoihV9BMvZyIIK0ZtaD3S4bC7QvlGA7ugmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730160090; c=relaxed/simple;
	bh=t7CWAWKV4owOmYn6mz4+Mnbc88oVfmpyhlANGbR1pGQ=;
	h=Date:To:From:Subject:Message-Id; b=UcusmiuVtT5V6erULdWJXkpWplZqa8pdAndwxBcvYsXEpGIRaKUqaRyl+cIzo8Dbi7NeTmmY0G8RX1p9guPrkB5Q16iEjZKeUfZ3qQVlu0/yI8Kojz7HIMuw+grnYn90sD54UhPogR/0wgPh1u02oVUFP8cTL6aNugreOhUPYvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k2iUiC1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k2iUiC1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE8CC4CEC3;
	Tue, 29 Oct 2024 00:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730160090;
	bh=t7CWAWKV4owOmYn6mz4+Mnbc88oVfmpyhlANGbR1pGQ=;
	h=Date:To:From:Subject:From;
	b=k2iUiC1KxHNeaheRlnbq19n2HEh++safMkgcvMOOtfxEiPPWfTrrQqwMTvTFbbJKY
	 1Eh60N1utSQH661MXl9dxRgs6lvUhX0FFD8DKxDYT7PHpd6kGgJ24T3PxFRYYH5Nwv
	 R+jhwIxHHsur0cGK0g2jdrGgTSf9uxNoFyQbYIvc=
Date: Mon, 28 Oct 2024 17:01:29 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,apanyaki@amazon.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit.patch added to mm-unstable branch
Message-Id: <20241029000130.3BE8CC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/Kconfig: update DBGFS_KUNIT prompt copy for SYSFS_KUNIT
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit.patch

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
Subject: mm/damon/Kconfig: update DBGFS_KUNIT prompt copy for SYSFS_KUNIT
Date: Mon, 28 Oct 2024 16:30:57 -0700

CONFIG_DAMON_SYSFS_KUNIT_TEST prompt is copied from that for DAMON debugfs
interface kunit tests, and not correctly updated.  Fix it.

Link: https://lkml.kernel.org/r/20241028233058.283381-6-sj@kernel.org
Fixes: b8ee5575f763 ("mm/damon/sysfs-test: add a unit test for damon_sysfs_set_targets()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Andrew Paniakin <apanyaki@amazon.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/Kconfig~mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit
+++ a/mm/damon/Kconfig
@@ -60,7 +60,7 @@ config DAMON_SYSFS
 	  the interface for arbitrary data access monitoring.
 
 config DAMON_SYSFS_KUNIT_TEST
-	bool "Test for damon debugfs interface" if !KUNIT_ALL_TESTS
+	bool "Test for damon sysfs interface" if !KUNIT_ALL_TESTS
 	depends on DAMON_SYSFS && KUNIT=y
 	default KUNIT_ALL_TESTS
 	help
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message.patch
selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result.patch
selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures.patch
mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit.patch
mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment.patch

