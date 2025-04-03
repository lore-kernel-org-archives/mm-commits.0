Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35ED3B666
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 02:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743647192; cv=none; b=kOP4akN7lY8myXssE97H1nmDmwzuPigFZq7l8Hr2s8UelNHockMGhftB0y5rpsMAp1HkDiGoHmcYrpQyuHv/mn7BkgkYCWA6m9ppq5Ww1K3Kh/s6vXFbR1lK+XePvWGInJz0fUoblc9ZyQO/HEsr1nBZMnebWCiDoaSy6HBhT90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743647192; c=relaxed/simple;
	bh=qjPUFF3gWWbFlslo7lPvsvzLtmrvQr5FVqp1KfA4Zvg=;
	h=Date:To:From:Subject:Message-Id; b=T1LHlxTFkePIGnjPXvA+Zt2u+tl4QuZN7eQC3lXH9NH01D27/M3Tgef0J7ctRziViFGQPyAZFNaOMg1jraHzVLC0/COjl9hdX0fkg+LpgnGwvCjihShivq2BVwZ3JPye7Ot4Z5kV+7IqiyN96qFn7gPfVdvVF3eQ6cQC1QmJ56Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hr948r87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hr948r87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A56C4CEDD;
	Thu,  3 Apr 2025 02:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743647191;
	bh=qjPUFF3gWWbFlslo7lPvsvzLtmrvQr5FVqp1KfA4Zvg=;
	h=Date:To:From:Subject:From;
	b=hr948r87OOl0JlWkxKEGR07W96pDP8V5mRDPAuHPBg40zeCg2XVlJK8rlyZzheRrc
	 UK7LQFiwkIMicUMzUT93HbJaFVXBusWsr4RJJ+qCM5SS+ZHCqJ2lPTVDBiwd27ngwE
	 2DvmiQq7izDUFJO08O+O+M7Gdks82iiC+BTdBT4Q=
Date: Wed, 02 Apr 2025 19:26:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,ravi.bangoria@amd.com,peterz@infradead.org,mingo@kernel.org,mcgrof@kernel.org,liam.howlett@oracle.com,da.gomez@samsung.com,da.gomez@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + radix-tree-add-missing-cleanuph.patch added to mm-hotfixes-unstable branch
Message-Id: <20250403022631.B9A56C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: radix-tree: add missing cleanup.h
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     radix-tree-add-missing-cleanuph.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/radix-tree-add-missing-cleanuph.patch

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
From: Daniel Gomez <da.gomez@kernel.org>
Subject: radix-tree: add missing cleanup.h
Date: Fri, 21 Mar 2025 20:24:33 +0000


Add shared cleanup.h header for radix-tree testing tools.

Fixes build error found with kdevops [1]:

cc -I../shared -I. -I../../include -I../../../lib -g -Og -Wall
-D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined   -c -o
radix-tree.o radix-tree.c
In file included from ../shared/linux/idr.h:1,
                 from radix-tree.c:18:
../shared/linux/../../../../include/linux/idr.h:18:10: fatal error:
linux/cleanup.h: No such file or directory
   18 | #include <linux/cleanup.h>
      |          ^~~~~~~~~~~~~~~~~
compilation terminated.
make: *** [<builtin>: radix-tree.o] Error 1

[1] https://github.com/linux-kdevops/kdevops
https://github.com/linux-kdevops/linux-mm-kpd/
actions/runs/13971648496/job/39114756401

Link: https://lkml.kernel.org/r/20250321-fix-radix-tree-build-v1-1-838a1e6540e2@samsung.com
Fixes: 6c8b0b835f00 ("perf/core: Simplify perf_pmu_register()")
Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/shared/linux/cleanup.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/shared/linux/cleanup.h a/tools/testing/shared/linux/cleanup.h
new file mode 100644
--- /dev/null
+++ a/tools/testing/shared/linux/cleanup.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TEST_CLEANUP_H
+#define _TEST_CLEANUP_H
+
+#include "../../../../include/linux/cleanup.h"
+
+#endif /* _TEST_CLEANUP_H */
_

Patches currently in -mm which might be from da.gomez@kernel.org are

radix-tree-add-missing-cleanuph.patch

