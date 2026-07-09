Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA9E379C3C;
	Thu,  9 Jul 2026 22:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783637405; cv=none; b=H/3Abl0CtqBzD94rldWiGRzqCVfJh786zoq/O2etplxcCwrK09POstVlythbcD19wm/P0jvB9bA0+zI/2cE4tUvCjbG/kj/bNzedVJwtWK9vP76HqhU0n/xZ2AOz2thdfL2TdH/4nK8O6wCGBWx6SYfqA2dYcvbrdXYQpSuybFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783637405; c=relaxed/simple;
	bh=8+iHs92c7Hm4zjQKRmyjwa3pbf7Bm6ChHdHovxoRJKE=;
	h=Date:To:From:Subject:Message-Id; b=SkfxdKZrBpaVtzUSfnaefAYmiCDxApwlGD46wnvo9r3Q8nVqO24eWU2L1tqlV7uKHuQuliiF1+tW/fDpm+Q0FZhizVWhruTbgMg+385b6RkNyEg9sddZlafrPcXwxd2pDVyY9+jrYUCKF+PxglOcDJJdm3CWuAuzBN20s+3ur7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yhX5Z0v8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yhX5Z0v8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466691F000E9;
	Thu,  9 Jul 2026 22:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783637404;
	bh=rnlSBTLSUGsHJ53Y5Xp2RJwfNLDJuqeP0TrX+awToTY=;
	h=Date:To:From:Subject;
	b=yhX5Z0v8UCpFWgk5H5kpfJ3fcSor76GUHHeGvxZO8tQkwmd2mKBQNTz6FgaSxdGXb
	 2Pf2H4YUSmcRiftvIa3E+RFdAElZnKC3vLA2mQA7HjYlmbc0BOAiuHWzYR0H9Oo2AG
	 +Q8OgXQb1KQhyTt6jAekEEbRCyZ54NJRkEvpOAAw=
Date: Thu, 09 Jul 2026 15:50:03 -0700
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,stable@vger.kernel.org,rostedt@goodmis.org,qiuxu.zhuo@intel.com,linmiaohe@huawei.com,lance.yang@linux.dev,david@kernel.org,bp@alien8.de,xieyuanbin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-failure-trace-change-memory_failure_event-to-ras-subsystem.patch removed from -mm tree
Message-Id: <20260709225004.466691F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: trace: change memory_failure_event to ras subsystem
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-trace-change-memory_failure_event-to-ras-subsystem.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: mm/memory-failure: trace: change memory_failure_event to ras subsystem
Date: Fri, 5 Jun 2026 16:12:13 +0800

Commit 97f0b1345219 ("tracing: add trace event for memory-failure")
introduced memory_failure_event in ras subsystem.  commit 31807483d395
("mm/memory-failure: remove the selection of RAS") changed
memory_failure_event to memory_failure subsystem.  This breaks the
backward compatibility, some user programs rely on it.

Change memory_failure_event to ras subsystem to keep backward
compatibility.

Link: https://lore.kernel.org/20260605081213.154660-1-xieyuanbin1@huawei.com
Fixes: 31807483d395 ("mm/memory-failure: remove the selection of RAS")
Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Reported-by: Yi Lai <yi1.lai@intel.com>
Reported-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Closes: https://lore.kernel.org/linux-mm/CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/memory-failure.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/trace/events/memory-failure.h~mm-memory-failure-trace-change-memory_failure_event-to-ras-subsystem
+++ a/include/trace/events/memory-failure.h
@@ -1,6 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #undef TRACE_SYSTEM
-#define TRACE_SYSTEM memory_failure
+/*
+ * For historical versions, memory_failure_event is in ras subsystem,
+ * some user programs depend on it.
+ */
+#define TRACE_SYSTEM ras
 #define TRACE_INCLUDE_FILE memory-failure
 
 #if !defined(_TRACE_MEMORY_FAILURE_H) || defined(TRACE_HEADER_MULTI_READ)
_

Patches currently in -mm which might be from xieyuanbin1@huawei.com are


