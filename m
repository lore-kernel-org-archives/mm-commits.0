Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79B62FD69E;
	Fri, 10 Jul 2026 18:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783709445; cv=none; b=L5yKc5K09HFUiJVp5zslaCaRwhTrO3NZsb8t8uYDV3j850wMxTYsrANg2zKQu5zA0bBgQuawlLlVNBy5vGmQBv4iqYjLnte2yZ0NdAxv7rru3R7w/znYO7KXhhwLNENPXjUwA3bJ6GZEREYeHMJQGit1veGieCzKTOTTBzd7UnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783709445; c=relaxed/simple;
	bh=WOzNP117jm4OL0RhQhIcfJcXE/oUn90/juMZlPhKOmQ=;
	h=Date:To:From:Subject:Message-Id; b=WVPf4ztIG5GVqEqgSpUHRMfv7+/PXCJaYzbeInfitAe5Flq8XOO0OU00hfoWIoqrcIivBYptYcvjg8DdeD2OZmmZ/S21bcz5wq6vPd5iJ+/tYpcEcftmpIDaDs4Gr24UMxPma+DLCuGttIjb8CtRk10yHD6ktQsxXbWNSOrLJ1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0oEeUu5M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0oEeUu5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499A01F000E9;
	Fri, 10 Jul 2026 18:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783709443;
	bh=VzT18xDDE23PNjf8Ei4vzdFxx+ju9YxlrMwmDN12IF0=;
	h=Date:To:From:Subject;
	b=0oEeUu5MpjtzV/BzigxYeYRKgU5BILIYY+ha3I3PpXqcHDN7JOJAwp5lnIShfNu8x
	 j0qLZQLf3y1X5GoaBvP+/uezR4Er3qMHGG6i0fGZ94IYPbWXpA6qGiX5yIkFMbqINM
	 M5gfHdFlqPEobI9VvNg5VAFpGI4xFy3YAa5Uu0zM=
Date: Fri, 10 Jul 2026 11:50:42 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,cyphar@cyphar.com,brauner@kernel.org,jkoolstra@xs4all.nl,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-fix-headers-in-fclogc.patch added to mm-hotfixes-unstable branch
Message-Id: <20260710185043.499A01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest: fix headers in fclog.c
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftest-fix-headers-in-fclogc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-fix-headers-in-fclogc.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jori Koolstra <jkoolstra@xs4all.nl>
Subject: selftest: fix headers in fclog.c
Date: Fri, 10 Jul 2026 19:17:35 +0200

fclog.c does not compile because it is missing fcntl.h, needed for
O_RDONLY etc.

There are also some redundant includes that are also in
kselftest_harness.h.

Link: https://lore.kernel.org/20260710171741.837308-1-jkoolstra@xs4all.nl
Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filesystems/fclog.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/tools/testing/selftests/filesystems/fclog.c~selftest-fix-headers-in-fclogc
+++ a/tools/testing/selftests/filesystems/fclog.c
@@ -6,10 +6,8 @@
 
 #include <assert.h>
 #include <errno.h>
+#include <fcntl.h>
 #include <sched.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
 #include <unistd.h>
 #include <sys/mount.h>
 
_

Patches currently in -mm which might be from jkoolstra@xs4all.nl are

selftest-fix-headers-in-fclogc.patch

