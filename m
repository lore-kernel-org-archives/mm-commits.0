Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25FA243320
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837180; cv=none; b=nQxxDGn3xWLBcSLGmoseQXibDi+V58/4A/xbE2ezG2qv51bErFxHkqb/YPmBjZXO61Ct1kQ/cMV/yFbtA9eRWczIv2e6lJuhJs/wj6rUIYK2EYLHR5pfWN2TcjeF1MoA3KdfeLx1rJTKWLpPDohlBPXxjSbLPPRo1eWMbxuwSnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837180; c=relaxed/simple;
	bh=1RLPP0EmIKqwrxWJrRfdoh3XoQS0qS9J8PVOP60n2gw=;
	h=Date:To:From:Subject:Message-Id; b=Fs5gQKJfurl5aEzRkm3Jv+WkRyZ4+HOAyE4nJ4ue7gbiNpqt0BapTwYy74SoQXNNRyjZvlQ5B1D7FsCq4rP4x50BQUHaNGikfkgoIotKAxGdd+YSjg7KWC3K6hKq2qbfspjgFa2b7LS+MDuDXJuYh0j3aq1pd9po2MAPM7gtK6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XDpyAnZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XDpyAnZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869D6C4CEDD;
	Tue, 14 Jan 2025 06:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837180;
	bh=1RLPP0EmIKqwrxWJrRfdoh3XoQS0qS9J8PVOP60n2gw=;
	h=Date:To:From:Subject:From;
	b=XDpyAnZ3X39fq+xc7LE/hyCsydKnCV+UHqLXkhGxCoK58BGhmKFBQHZrEjE+WK5tT
	 Dm/zuY5dz9rhiaO+0lEG55VELgktTyatOK/sukxD+V9SEYije2FXHb6e2OWzUJThQO
	 urgD5eeH6yx/I80TY3xkscjxW3dtlnuuH2BE1lXE=
Date: Mon, 13 Jan 2025 22:46:20 -0800
To: mm-commits@vger.kernel.org,si.yanteng@linux.dev,shuah@kernel.org,rmoar@google.com,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch removed from -mm tree
Message-Id: <20250114064620.869D6C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kunit: configs: remove configs for DAMON debugfs interface tests
has been removed from the -mm tree.  Its filename was
     kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: kunit: configs: remove configs for DAMON debugfs interface tests
Date: Mon, 6 Jan 2025 11:19:39 -0800

It's time to remove DAMON debugfs interface, which has deprecated long
before in February 2023.  Read the cover letter of this patch series for
more details.

Remove kernel configs for running DAMON debugfs interface kunit tests from
the kunit all_tests configuration, to prevent unnecessary noises from
tests.

Link: https://lkml.kernel.org/r/20250106191941.107070-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Rae Moar <rmoar@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <si.yanteng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/kunit/configs/all_tests.config |    3 ---
 1 file changed, 3 deletions(-)

--- a/tools/testing/kunit/configs/all_tests.config~kunit-configs-remove-configs-for-damon-debugfs-interface-tests
+++ a/tools/testing/kunit/configs/all_tests.config
@@ -38,9 +38,6 @@ CONFIG_IWLWIFI=y
 CONFIG_DAMON=y
 CONFIG_DAMON_VADDR=y
 CONFIG_DAMON_PADDR=y
-CONFIG_DEBUG_FS=y
-CONFIG_DAMON_DBGFS=y
-CONFIG_DAMON_DBGFS_DEPRECATED=y
 
 CONFIG_REGMAP_BUILD=y
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

