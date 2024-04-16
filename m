Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410931386A8
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 19:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713296682; cv=none; b=EonsyO9hjGivCZN1IVn58i7bSJ2WNXrqk4hXMkXs0wz4Gym+HiZkZKoEIEA2yXBSX+fq+wjADscC6v7C7wLKUK2kVDH0bLDUGM1ceOytZABh7jp7VHrGMfS475gGS8k8WBTWVorLa5KK3GYlf+vytPXtF6FG+hspODO/TAgunPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713296682; c=relaxed/simple;
	bh=5O8vBgHQ72EwmfBmwJq9DA9G2Ihxv6EG1sgmfs9XOIM=;
	h=Date:To:From:Subject:Message-Id; b=YgzITnJAbDQG5OvIrsNC7NkwDi0+Lzu9R7SyYm83fyRAFeGYoV0nKjNRQLzo3WIuT9/UXsxSwQt0nmCY+0kJttGyVLh2ARGFkJKQ2OuQyt56WL0lvZgoQUVRCuRZvS5k8GHPf8sKqZ76YY8j8dXd5Z0RQ3FqEJrnSYC2z9EcOpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oChekbSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oChekbSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA56C113CE;
	Tue, 16 Apr 2024 19:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713296681;
	bh=5O8vBgHQ72EwmfBmwJq9DA9G2Ihxv6EG1sgmfs9XOIM=;
	h=Date:To:From:Subject:From;
	b=oChekbSYvAIxVSvSkParG143OKu/BQcR40pxjenfVIyxGs8uC9gtthCiIJwqx30/e
	 66NkxkPClo4rYtff2JihpBziKg3l2AyRvFHBGYYGeQ/jz6D/QQ3SKVwMzjVOJXg7MS
	 FFiTUXON2fAzN96fuo7UxH/eYqPCZxvCZYoOskg0=
Date: Tue, 16 Apr 2024 12:44:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-unused-and-uninitialized-variable-warning.patch added to mm-hotfixes-unstable branch
Message-Id: <20240416194441.BAA56C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: fix unused and uninitialized variable warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-unused-and-uninitialized-variable-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-unused-and-uninitialized-variable-warning.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: mm: fix unused and uninitialized variable warning
Date: Tue, 16 Apr 2024 21:26:58 +0500

Fix the warnings by initializing and marking the variable as unused.
I've caught the warnings by using clang.

split_huge_page_test.c:303:6: warning: variable 'dummy' set but not used [-Wunused-but-set-variable]
  303 |         int dummy;
      |             ^
split_huge_page_test.c:343:3: warning: variable 'dummy' is uninitialized when used here [-Wuninitialized]
  343 |                 dummy += *(*addr + i);
      |                 ^~~~~
split_huge_page_test.c:303:11: note: initialize the variable 'dummy' to silence this warning
  303 |         int dummy;
      |                  ^
      |                   = 0
2 warnings generated.

Link: https://lkml.kernel.org/r/20240416162658.3353622-1-usama.anjum@collabora.com
Fixes: fc4d182316bd ("mm: huge_memory: enable debugfs to split huge pages to any order")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-fix-unused-and-uninitialized-variable-warning
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -300,7 +300,7 @@ int create_pagecache_thp_and_fd(const ch
 		char **addr)
 {
 	size_t i;
-	int dummy;
+	int __attribute__((unused)) dummy = 0;
 
 	srand(time(NULL));
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-fix-unused-and-uninitialized-variable-warning.patch
selftests-exec-make-binaries-position-independent.patch

