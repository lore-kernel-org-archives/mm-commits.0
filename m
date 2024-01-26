Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B087475
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235443; cv=none; b=RbBwaZU6cZGs4NdyzGocvtKFljQLipebheBCiShngEWBwLnKTQTWlp65sGtdcEDVURafxc2JuzK5SGsJEe8Cl0Vv/6kgVqHZKIgr9fK6xnOi/CDOF5RW1VikFZZwyqBu1m8/hl1oVwuiaxTarbj3PI3NJs9G7BZXZNZOET7fssk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235443; c=relaxed/simple;
	bh=trgCaNwTCd31ZPMhbbOgN4R6CM0HUeyt5k6pM5jgQMg=;
	h=Date:To:From:Subject:Message-Id; b=o6TdY0l4B1qnqiark+mWksmGqOHwUs5U/AgmsHBWbJXgszz3CciTTRdpDNlUHWM5h1OrFWuIsJTdugG93xc/Y62zVgGRPI5srMORO3UvZZs1u5Clz7M4bRvvihB2VQ0HZDaHUKJkVLDrgA8OGAoO8bpxEq9xVgXk+vdsYowL/+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f8WQhu6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f8WQhu6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A91DC433F1;
	Fri, 26 Jan 2024 02:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235442;
	bh=trgCaNwTCd31ZPMhbbOgN4R6CM0HUeyt5k6pM5jgQMg=;
	h=Date:To:From:Subject:From;
	b=f8WQhu6QEfIhs9xkS3Bih+IRKVawUfA7KgxhyGK/Gih2DJsSkfZE74YW18ulLy43J
	 2X3PZ9UBl/RNQ2SWYg0brd4Vc9J5+odvXqzenGSouBNRd9mAchDGEPJTNvTrYAIuR+
	 Dm6Qmnnrmw7Jj5HVnA4DgaG11YBOyc0NjBgW2/SY=
Date: Thu, 25 Jan 2024 18:17:19 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,aishwarya.tcv@arm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch added to mm-hotfixes-unstable branch
Message-Id: <20240126021722.5A91DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: core: include linux/close_range.h for CLOSE_RANGE_* macros
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch

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
Subject: selftests: core: include linux/close_range.h for CLOSE_RANGE_* macros
Date: Tue, 24 Oct 2023 20:51:25 +0500

Correct header file is needed for getting CLOSE_RANGE_* macros. 
Previously it was tested with newer glibc which didn't show the need to
include the header which was a mistake.

Link: https://lkml.kernel.org/r/20231024155137.219700-1-usama.anjum@collabora.com
Fixes: ec54424923cf ("selftests: core: remove duplicate defines")
Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Link: https://lore.kernel.org/all/7161219e-0223-d699-d6f3-81abd9abf13b@arm.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/core/close_range_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/core/close_range_test.c~selftests-core-include-linux-close_rangeh-for-close_range_-macros
+++ a/tools/testing/selftests/core/close_range_test.c
@@ -12,6 +12,7 @@
 #include <syscall.h>
 #include <unistd.h>
 #include <sys/resource.h>
+#include <linux/close_range.h>
 
 #include "../kselftest_harness.h"
 #include "../clone3/clone3_selftests.h"
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-mremap_test-fix-build-warning.patch
selftests-mm-switch-to-bash-from-sh.patch
selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch

