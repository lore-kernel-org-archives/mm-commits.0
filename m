Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8B310F2
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744826; cv=none; b=e8YpOnHyX6kdIT4saKVo4iJFcK7uei6dsBDBn0HrE9Pa68j9Af7BAo7ZLT0GAXeBGMSKSgQOGRf5DyGbcisf+HyRE0WMmfW0QRocDQC2bRXVwb2DFD4xUWdlSkNZCdj38KTUncqNU6otJqbVFSPV0paskeya4kRAkPeV3CUf93M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744826; c=relaxed/simple;
	bh=7Dym14LRrbxRcWTC5qiCeRrosXssRF8Ma03fsx2fdMo=;
	h=Date:To:From:Subject:Message-Id; b=eJNY17Elr+0fPHojlLZamabm0J9wPsXpDZfYCLyu2XGNQPm3XHSc+X+U7pKifp3LFz2vhlMBcCY3F1Qq4LdKtCmHEARXsfSTiQMN2o2SOQ8AwfS7RxcTlmag9txBCShqzq+o2KcG5KqnuBVbK3Qnhu1dKQMOLMHSsQnIYUUdtOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gG/tqA9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gG/tqA9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B0DC4CEF7;
	Sun, 29 Mar 2026 00:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744826;
	bh=7Dym14LRrbxRcWTC5qiCeRrosXssRF8Ma03fsx2fdMo=;
	h=Date:To:From:Subject:From;
	b=gG/tqA9qpUGcYlw0mEXD4OGxVRWv8PFgSwUa2Lq1OINMUmbobgCgndHvPLYuJUM9R
	 I2dmxD7JYOSLRYA5k5VYhM3TAbfJu7Af1UdxCyNRoQ3/3oxjy6eOjQMdRtXY0QuGDR
	 RY5O2ZkPeJttDxwn54crjY3xTceGJ6e/8xPXqR+Y=
Date: Sat, 28 Mar 2026 17:40:26 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch removed from -mm tree
Message-Id: <20260329004026.A5B0DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/.kunitconifg: enable DAMON_DEBUG_SANITY
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/.kunitconifg: enable DAMON_DEBUG_SANITY
Date: Fri, 6 Mar 2026 07:29:12 -0800

CONFIG_DAMON_DEBUG_SANITY is recommended for DAMON development and test
setups.  Enable it on the default configurations for DAMON kunit test run.

Link: https://lkml.kernel.org/r/20260306152914.86303-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/.kunitconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/tests/.kunitconfig~mm-damon-tests-kunitconifg-enable-damon_debug_sanity
+++ a/mm/damon/tests/.kunitconfig
@@ -13,3 +13,6 @@ CONFIG_DAMON_VADDR_KUNIT_TEST=y
 CONFIG_SYSFS=y
 CONFIG_DAMON_SYSFS=y
 CONFIG_DAMON_SYSFS_KUNIT_TEST=y
+
+# enable DAMON_DEBUG_SANITY to catch any bug
+CONFIG_DAMON_DEBUG_SANITY=y
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

