Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E7E5228
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 00:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730160092; cv=none; b=ZyqEeZczsjKycszLMQ5JsKKEXXBjFEPWntP0QyMHIKG0UXXUXCOgCnoRkeb4Ve0psChsNl8OPYssUfmf3flkSIFeh27V2+bDQXo0SPE54x8/o87oXDwQ2ZCJIJqHNql7igqe4niL5friF+4esokPYtSJOL4EwnHTrFBFwwyibO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730160092; c=relaxed/simple;
	bh=t9kLQN2yePCrHfGXNMqs4I6KA5Gwwu+xL3lcCsmQECE=;
	h=Date:To:From:Subject:Message-Id; b=hE9cTIwBgSs5sNVG2wxDso+kvr8faaxGE4GDg8Vz2gXLXGD0p6hx2TSnAy2+LtNK5m71H1EcIVlF73iFVoHIJIoKHjNpb8sMjGEU6htSTjLqzn0+byu8A+b0woqtgRdI5r1SMDdqok6WHVAqQ3eVvbOXo9uUY/bGl6stajpj42g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fMkgX7Sg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fMkgX7Sg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B79C4CECD;
	Tue, 29 Oct 2024 00:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730160092;
	bh=t9kLQN2yePCrHfGXNMqs4I6KA5Gwwu+xL3lcCsmQECE=;
	h=Date:To:From:Subject:From;
	b=fMkgX7SgFS8scGZJg+OwJ3neGwSbxHYrybPWMbg43Kxhtpik3+qcvKbIvc2tKw/u1
	 /T+/CMhOAOs+p1A50O5uNq1wI0PdqJepp3ioJV9rIaR7VGlqaqHkDYImmx4uzaSTvT
	 6euXGgLiH5LBMoDUvAd1sDQ0NXTAA4L/FLgan+XE=
Date: Mon, 28 Oct 2024 17:01:31 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,apanyaki@amazon.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment.patch added to mm-unstable branch
Message-Id: <20241029000132.25B79C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/dbgfs-kunit: fix the header double inclusion guarding ifdef comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment.patch

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
Subject: mm/damon/tests/dbgfs-kunit: fix the header double inclusion guarding ifdef comment
Date: Mon, 28 Oct 2024 16:30:58 -0700

Closing part of double inclusion guarding macro for dbgfs-kunit.h was
copy-pasted from somewhere (maybe before the initial mainline merge of
DAMON), and not properly updated.  Fix it.

Link: https://lkml.kernel.org/r/20241028233058.283381-7-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Andrew Paniakin <apanyaki@amazon.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/dbgfs-kunit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/tests/dbgfs-kunit.h~mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment
+++ a/mm/damon/tests/dbgfs-kunit.h
@@ -168,6 +168,6 @@ static struct kunit_suite damon_test_sui
 };
 kunit_test_suite(damon_test_suite);
 
-#endif /* _DAMON_TEST_H */
+#endif /* _DAMON_DBGFS_TEST_H */
 
 #endif	/* CONFIG_DAMON_KUNIT_TEST */
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message.patch
selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result.patch
selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures.patch
mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit.patch
mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment.patch

