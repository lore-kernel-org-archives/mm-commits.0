Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8CA8827
	for <mm-commits@vger.kernel.org>; Wed,  1 Jan 2025 23:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735774778; cv=none; b=i5Vmrd65P7BmOtSLzq/fFwlute4oFnJxqVtBhw1aa1cBJMApiM17sxoTu0NI3aWRBLqhlh2rsRyZ+z2j6PFd2VOBRJ6DX/oPylGMCRg+rucsekdrZbSU2RiuQdO98qzMP750ew1CvpkJ19+FkH+2VtgBoKxqRqj1zG4rSXBCcrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735774778; c=relaxed/simple;
	bh=Wm0aMbdhxUmJjygShiadYihZkK8k85d/+4XPtBuKQm8=;
	h=Date:To:From:Subject:Message-Id; b=uiy6kM6DFa8Oxmw6uBimPTWAyG0TmuNeNDrfkd4lLoInB8ZXt9SJMXl++BCwSG16bTCGBUrH7KEkImA+5LsbNGUkuB8Rpy9PqaoeCMR7c57yEnMkvjWCN091LdtK+bXMCdh02E29OCUWg9jUr40nUCd/BW/sPfwAtkR6kyHs9aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ihjgg2zk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ihjgg2zk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F30C4CECE;
	Wed,  1 Jan 2025 23:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735774778;
	bh=Wm0aMbdhxUmJjygShiadYihZkK8k85d/+4XPtBuKQm8=;
	h=Date:To:From:Subject:From;
	b=ihjgg2zkc1LOHmAqmqZ9+yAZGI/5o0kTTXTJ78jyFWlXIOwUYPKzagLG9Zy77+dZq
	 OMD+k2LE93+iAsKCJtEgF60XeHcTCyIGt9tD9r403mexAu49qPQ8Vqk+KhNu5AL1hH
	 Ky1pk8b0TOoUtqjjaQtnXVf7EkmtiKW1Yc1Gz8oo=
Date: Wed, 01 Jan 2025 15:39:37 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,rmoar@google.com,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch added to mm-unstable branch
Message-Id: <20250101233938.41F30C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kunit: configs: remove configs for DAMON debugfs interface tests
has been added to the -mm mm-unstable branch.  Its filename is
     kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch

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
Subject: kunit: configs: remove configs for DAMON debugfs interface tests
Date: Wed, 1 Jan 2025 13:35:25 -0800

It's time to remove DAMON debugfs interface, which has deprecated long
before in February 2023.  Read the cover letter of this patch series for
more details.

Remove kernel configs for running DAMON debugfs interface kunit tests from
the kunit all_tests configuration, to prevent unnecessary noises from
tests.

Link: https://lkml.kernel.org/r/20250101213527.74203-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Rae Moar <rmoar@google.com>
Cc: Shuah Khan <shuah@kernel.org>
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

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch

