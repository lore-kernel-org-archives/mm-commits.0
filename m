Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3240CBA42
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744417990; cv=none; b=JgnohKatXRgfQp5yotq44zpea/1ksCKbk5DyB+exCQiA3gzCY81PanbU5uo8gaDpSUJgZE6Ybkc09C42W8JLWCI93DKyB8LVKl/togPskBd+jJqqUyoC+JXlQ/h0++/7sJ9NmG1oEW4Jan4uxYMPHurAqswdYkm/G/VcyQH2hac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744417990; c=relaxed/simple;
	bh=hBtM8P1q3j9CpoXQsStK/HbT25l28TXJ2vuFSvuKos4=;
	h=Date:To:From:Subject:Message-Id; b=EKvYD+dlthWNjMOIaOH7kvX1pjF6o+rd0TCbnfIRq2jXYN74B9gyzZfJYWlKVnvpbLmtLycGBTXYl1GqBNmOWFo6PXCp+5tlHNky9HLFfXk3KfV2ERCJop0Yp8FigkZ1L3ewomt7naEd1yP2A/HLr/lJo8p0HzERoyBfERh0oAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xt8puOyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xt8puOyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72914C4CEE2;
	Sat, 12 Apr 2025 00:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744417989;
	bh=hBtM8P1q3j9CpoXQsStK/HbT25l28TXJ2vuFSvuKos4=;
	h=Date:To:From:Subject:From;
	b=Xt8puOyrsEsyFl7d15eNB1Y9T1O3EkGAdZmV7gjq+Xr6ddlgnCVWGuMQ5pPX2Ht+C
	 4BJ5vTZgvEFZR9+6P1heHIcARIErkHQ52hEH1k6/Op7FP2l7XTkaT/8dmFiTAz2wVC
	 Tb2rbvPthyH+PYkVcrFbRXLCnA4VUMujWjBtb1KU=
Date: Fri, 11 Apr 2025 17:33:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,ravi.bangoria@amd.com,peterz@infradead.org,mingo@kernel.org,mcgrof@kernel.org,liam.howlett@oracle.com,da.gomez@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] radix-tree-add-missing-cleanuph.patch removed from -mm tree
Message-Id: <20250412003309.72914C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: radix-tree: add missing cleanup.h
has been removed from the -mm tree.  Its filename was
     radix-tree-add-missing-cleanuph.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Daniel Gomez <da.gomez@samsung.com>
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

[akpm@linux-foundation.org: remove unneeded header guards, per Sidhartha]
Link: https://lkml.kernel.org/r/20250321-fix-radix-tree-build-v1-1-838a1e6540e2@samsung.com
Fixes: 6c8b0b835f00 ("perf/core: Simplify perf_pmu_register()")
Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/shared/linux/cleanup.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/shared/linux/cleanup.h a/tools/testing/shared/linux/cleanup.h
new file mode 100644
--- /dev/null
+++ a/tools/testing/shared/linux/cleanup.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include "../../../../include/linux/cleanup.h"
_

Patches currently in -mm which might be from da.gomez@samsung.com are


