Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729D02DD60E
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 20:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768854668; cv=none; b=Y7fZslasFE7VP6B67t9L6x90RBTnnmWz04Ti39kPHW9rRnsNoFEG+64sXrFq9/FyalN96GuvfdBzv1vkGeYp+n8Yam+AQtJ8WLELyFJrVTvbTZmVrCi8Sijc8XmSeUkhFPe9HHDHpWby1Uncj04Mih7G088CDs6oaZ5tcsttl9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768854668; c=relaxed/simple;
	bh=PW9wCKH36pwi2ev2DMTGwN+HAAAqjkhwHATkTuZw8VI=;
	h=Date:To:From:Subject:Message-Id; b=e9Anz7G8KrTu7E8J6kRvDaBy+5i1fPcLEafNTU7Pt19BM1BTXcbGyBbCN24eiU2byBTyirK/PtP+M9M2OwozgRDrtZJ4lQG4N6LPMU92AwjcUT4VL2Dse7gUdx9w5U8+3iljoI+O8o/hGDF7B0uSdW8bot6ybbEtYWk52Czhm2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mUpMF4g9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mUpMF4g9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19A0C116C6;
	Mon, 19 Jan 2026 20:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768854666;
	bh=PW9wCKH36pwi2ev2DMTGwN+HAAAqjkhwHATkTuZw8VI=;
	h=Date:To:From:Subject:From;
	b=mUpMF4g9wtpLv/prbDOdNiGW3h6j2uaiioPWvNMCq/PiFz0MMEhj1wrisrGvMbpe+
	 tIBUv0wyjJX9EIwpN6UX+mLHMzrNMBByPLp49nQ3Qv8m+7zbj6NyWRhU5PAw0wAjS0
	 ean8AIT8lgdZeVeOyTmRaDlsDkJz8LjArs808xBQ=
Date: Mon, 19 Jan 2026 12:31:06 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,sj@kernel.org,ran.xiaokai@zte.com.cn,kent.overstreet@linux.dev,corbet@lwn.net,akpm@linux-foundation.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] docs-mm-allocation-profiling-describe-sysctrl-limitations-in-debug-mode.patch removed from -mm tree
Message-Id: <20260119203106.D19A0C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/allocation-profiling: describe sysctrl limitations in debug mode
has been removed from the -mm tree.  Its filename was
     docs-mm-allocation-profiling-describe-sysctrl-limitations-in-debug-mode.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: Docs/mm/allocation-profiling: describe sysctrl limitations in debug mode
Date: Fri, 16 Jan 2026 10:44:23 -0800

When CONFIG_MEM_ALLOC_PROFILING_DEBUG=y, /proc/sys/vm/mem_profiling is
read-only to avoid debug warnings in a scenario when an allocation is
made while profiling is disabled (allocation does not get an allocation
tag), then profiling gets enabled and allocation gets freed (warning due
to the allocation missing allocation tag).

Link: https://lkml.kernel.org/r/20260116184423.2708363-1-surenb@google.com
Fixes: ebdf9ad4ca98 ("memprofiling: documentation")
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst   |    4 ++++
 Documentation/mm/allocation-profiling.rst |   10 ++++++++++
 2 files changed, 14 insertions(+)

--- a/Documentation/admin-guide/sysctl/vm.rst~docs-mm-allocation-profiling-describe-sysctrl-limitations-in-debug-mode
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -494,6 +494,10 @@ memory allocations.
 
 The default value depends on CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT.
 
+When CONFIG_MEM_ALLOC_PROFILING_DEBUG=y, this control is read-only to avoid
+warnings produced by allocations made while profiling is disabled and freed
+when it's enabled.
+
 
 memory_failure_early_kill
 =========================
--- a/Documentation/mm/allocation-profiling.rst~docs-mm-allocation-profiling-describe-sysctrl-limitations-in-debug-mode
+++ a/Documentation/mm/allocation-profiling.rst
@@ -33,6 +33,16 @@ Boot parameter:
 sysctl:
   /proc/sys/vm/mem_profiling
 
+  1: Enable memory profiling.
+
+  0: Disable memory profiling.
+
+  The default value depends on CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT.
+
+  When CONFIG_MEM_ALLOC_PROFILING_DEBUG=y, this control is read-only to avoid
+  warnings produced by allocations made while profiling is disabled and freed
+  when it's enabled.
+
 Runtime info:
   /proc/allocinfo
 
_

Patches currently in -mm which might be from surenb@google.com are


