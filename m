Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70FA31352B;
	Fri,  5 Jun 2026 17:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780680336; cv=none; b=RjpxMVlWryekE2Mhwi5+UXqPwQN7FqmxBMV2+O7kxZQwZRAmqYmA5bUDDXGv/WcjgSldMo0YItqLDsrQR8IYWxs1kOoy9KOqX35xMoSyzFo0h/37ByNX7Tuflak0aKo/ACZ+yUb72wFHjOOorn72YVHQnUZ3fvwHQomGMZFCkg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780680336; c=relaxed/simple;
	bh=iSYMWKVU+9IdwKgt1MnMrmYcOt2F3tsxeG+1zwHsRcc=;
	h=Date:To:From:Subject:Message-Id; b=shMtM6NVSSzwdd8fSSBMOjZmDB7Ta+cXn4b3mtv+dyTvp3m00H2xPPYG8wQqYI1cCZtZ3Z3kb6nA67wOxeEzXrIYfoH7yMdbqn33eTey18LSLYm8EuxpqVbEXOkQlW2iAY3TM1faM7oGrHeOWTSEQ3bw0ScwZTg22qSHcSA6bSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QqWYucY3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QqWYucY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F73C1F00893;
	Fri,  5 Jun 2026 17:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780680334;
	bh=Og1i0ZaVixKJ/DvfHnWEokw7o1IrjaKTQaHWl2XCMX4=;
	h=Date:To:From:Subject;
	b=QqWYucY3PFcfkKztiBJRrgCi9vcmpX+FfjtUJ5OPxjbzC7hEVTE2AeV7xNG85QHqA
	 S5Ee3+YchvQEPTw6GQKibhFS/euCsCRdf+Ss5SqRQQHfVKu4nIn3d1pMuMuvSUaHH/
	 +ZWm05oGXykZRz+WGsutxc/IpDm44w21Sx4hGLm8=
Date: Fri, 05 Jun 2026 10:25:34 -0700
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,stable@vger.kernel.org,rostedt@goodmis.org,qiuxu.zhuo@intel.com,linmiaohe@huawei.com,david@kernel.org,bp@alien8.de,xieyuanbin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-trace-change-memory_failure_event-to-ras-subsystem.patch added to mm-hotfixes-unstable branch
Message-Id: <20260605172534.7F73C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: trace: change memory_failure_event to ras subsystem
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-trace-change-memory_failure_event-to-ras-subsystem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-trace-change-memory_failure_event-to-ras-subsystem.patch

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
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
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

mm-memory-failure-trace-change-memory_failure_event-to-ras-subsystem.patch

