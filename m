Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFC0219494
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731019129; cv=none; b=jBNXHPtHu0Kh2+ifgmZI+oCh1PwU0OMPd42PVkt1s4hyXgoXyNi6oivYnU71xBXT0SEIEq0SATwAUUnb4wffQ1WWX0AHE+OqnSm2BQpWvFThNO1WuJNuwMwQrZ0YZgYuiALmvNuc48BkAdoUaVGTg91Z6xKdNiJ5hPzukFdgFvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731019129; c=relaxed/simple;
	bh=0JteKV9CtAehcJ8Ls7cSmnVl5kFXiZ2qho8pg6vhvvU=;
	h=Date:To:From:Subject:Message-Id; b=k6o1ZoVNeeeoIKZG7qPNw2uqCd5XCn2UbgrdHgvDt9Mmi5S0hbOmfk9sSYHMg9/93ZIfT9SnPNOv6B2kgbEJy9ftxaqS6aLLQ0RFMN4vsf9v831wyH7J09cdzGSBXtb9n6N0hXW3MfFt47TfFT+7lJIs36duu7YV1dMZL02/GoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K1F9gyaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K1F9gyaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835C9C4CECC;
	Thu,  7 Nov 2024 22:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731019129;
	bh=0JteKV9CtAehcJ8Ls7cSmnVl5kFXiZ2qho8pg6vhvvU=;
	h=Date:To:From:Subject:From;
	b=K1F9gyaJhfUKUYfSq6qSZN1A4aj6elVqBCvtf3I3FUEfMUJi7HR19Yx9+DbieobSS
	 dmsAlQ3v0mnJ6/+kE/Z6ZdxRH/PoL2Xc9diPIoH0n9LsfcApd2NdWL/Pqn5+zTmulC
	 /W/XKjvLZ6zghzqkQpvL4Ai8JxaQ07jNltAo4/Es=
Date: Thu, 07 Nov 2024 14:38:48 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,apanyaki@amazon.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result.patch removed from -mm tree
Message-Id: <20241107223849.835C9C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_debugfs_common: hide expected error message from test_write_result()
has been removed from the -mm tree.  Its filename was
     selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

docs-mm-damon-recommend-academic-papers-to-read-and-or-cite.patch
maintainers-memory-management-add-document-files-for-mm.patch

