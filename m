Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117A02F26
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 00:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730160085; cv=none; b=JouApEGeDu4vkV5gG/ifa0a9xcoJeCYRHtmdiVUL7nV2ceHSMsNXQsMUVnKnYzhW8uoxbwDKPqiKH3jlBZSqU/OWi34CxARwvDiNWYSVewFuBH0dyLcLx3YOMKGTwpVmQ71+rUY8ndyTR1IR9jbE8fuvyQd18ss/wmKhP5tSj/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730160085; c=relaxed/simple;
	bh=xpRx1A7JRYu//YsyBOpLpbFkb/QPJ+ypE1tugo6MNXE=;
	h=Date:To:From:Subject:Message-Id; b=JfdoFWPDpZkW4i4D+oxVjnCnpWj2zrkOfa2mRm5PNdXJJnCWMTxOnWFS9kgC7bcRYP+FcY/bBwHMApPTFUxhAb4sY0wtf2AdOF2ucILWnyHqz5Gc9N9DIRNHStteycy8tqYYB/H+rOr440P0XTDF6cZ/7Dw2ICK1fOb4Ll6kMlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qeiBs8fn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qeiBs8fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887DDC4CECD;
	Tue, 29 Oct 2024 00:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730160084;
	bh=xpRx1A7JRYu//YsyBOpLpbFkb/QPJ+ypE1tugo6MNXE=;
	h=Date:To:From:Subject:From;
	b=qeiBs8fnrTHuAiN3/RLfmKToRZIGsBLrn+ycnFgf0zqkZHxP0eyDUZl9QtTTQpr27
	 UCsxft80rtlYCaLWu9Au5I64MPXVHhKcsw/IayutjutWGDVb/NAaWQkd7/z7Zmm9mB
	 Xu4lXOXPYY6mMWRjyU+KNLqWl09JHCNS0qGjuiCU=
Date: Mon, 28 Oct 2024 17:01:23 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,apanyaki@amazon.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message.patch added to mm-unstable branch
Message-Id: <20241029000124.887DDC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/huge_count_read_write: remove unnecessary debugging message
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message.patch

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
Subject: selftests/damon/huge_count_read_write: remove unnecessary debugging message
Date: Mon, 28 Oct 2024 16:30:54 -0700

The program prints expected errors from write/read of the files with
invalid huge count, for only debugging purpose.  It is only making the
output noisy.  Remove those.

Link: https://lkml.kernel.org/r/20241028233058.283381-3-sj@kernel.org
Fixes: b4a002889d24 ("selftests/damon: test debugfs file reads/writes with huge count")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Andrew Paniakin <apanyaki@amazon.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/huge_count_read_write.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/damon/huge_count_read_write.c~selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message
+++ a/tools/testing/selftests/damon/huge_count_read_write.c
@@ -28,9 +28,7 @@ void write_read_with_huge_count(char *fi
 	}
 
 	write(filedesc, "", 0xfffffffful);
-	perror("after write: ");
 	ret = read(filedesc, buf, 0xfffffffful);
-	perror("after read: ");
 	close(filedesc);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message.patch
selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result.patch
selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures.patch
mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit.patch
mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment.patch

