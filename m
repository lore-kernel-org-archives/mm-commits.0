Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8B53209
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 00:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730160087; cv=none; b=Opqqe+oUQGcjVqHQ0Z++VuKg6hQ9fG9uNwj21m9Nmn4Ev2j5oV7WfWnPaTOaJDSmGUhNyBie6JEibsiZzc6tJ2VOjfeJ2B7Hn2K0iL+HxFeEehug8icO0Gkhx/HSPBdgO03uU/dh/31MCUQ4+rposuORkWk4haVEo+bsYivHQrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730160087; c=relaxed/simple;
	bh=Dl1GCYp/uYYO8JoXgBoq4ToXkswMhEDPK2u4l8dBm6A=;
	h=Date:To:From:Subject:Message-Id; b=jHZLuA3IornJiL9bIf+G7Ktt4RflkSsgINRzp9h7iJ1Gsb0qNo7aKTH8rtPF5mmChNdBz6yzrJBJoWCZBbSPMyKWLijWMIV6MQqmtqQ2KOwMWH/Xt066Pgg8YtFK9qzdyPqmaL0/htLn7xtdeY6j5zpqJl3bLXNUkBkOtqLm05E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JHDcuPPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JHDcuPPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D96CC4CECD;
	Tue, 29 Oct 2024 00:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730160086;
	bh=Dl1GCYp/uYYO8JoXgBoq4ToXkswMhEDPK2u4l8dBm6A=;
	h=Date:To:From:Subject:From;
	b=JHDcuPPuEdy3OLPeQiZYie1Z8wZtb/2uxz9vMkuKndFfgFd5ESwc0W3D+Hc3Qk0YZ
	 IDegYHhGKlnpHsPJT1f84veEa35fM0/TKYKwGgr/VEvA2rc0Ftqs9F93bHfeQcYAPs
	 5A7sb49eTqQHJ17J+VtB1g7qpKIcbxhPRijP+SyI=
Date: Mon, 28 Oct 2024 17:01:25 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,apanyaki@amazon.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result.patch added to mm-unstable branch
Message-Id: <20241029000126.7D96CC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_debugfs_common: hide expected error message from test_write_result()
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result.patch

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
Subject: selftests/damon/_debugfs_common: hide expected error message from test_write_result()
Date: Mon, 28 Oct 2024 16:30:55 -0700

DAMON debugfs interface selftests use test_write_result() to check if
valid or invalid writes to files of the interface success or fail as
expected.  File write error messages from expected failures are only
making the output noisy.  Hide such expected error messages.

Link: https://lkml.kernel.org/r/20241028233058.283381-4-sj@kernel.org
Fixes: b348eb7abd09 ("mm/damon: add user space selftests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Andrew Paniakin <apanyaki@amazon.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_debugfs_common.sh |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_debugfs_common.sh~selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result
+++ a/tools/testing/selftests/damon/_debugfs_common.sh
@@ -8,7 +8,12 @@ test_write_result() {
 	expect_reason=$4
 	expected=$5
 
-	echo "$content" > "$file"
+	if [ "$expected" = "0" ]
+	then
+		echo "$content" > "$file"
+	else
+		echo "$content" > "$file" 2> /dev/null
+	fi
 	if [ $? -ne "$expected" ]
 	then
 		echo "writing $content to $file doesn't return $expected"
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message.patch
selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result.patch
selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures.patch
mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit.patch
mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment.patch

