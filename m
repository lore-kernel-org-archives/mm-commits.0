Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499856FC5
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 20:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768596238; cv=none; b=cf3CdIqoEwKDGvbbMkTMkVHSAIghA1tKW0Zc0k6UkfkoxkoiGboQalOBNR3TmwgWFG0s2KtnCr1rakpCbm9+LZbyrTB9H7/Tl13ZvPLfR7CHmiQnROB0/xtjapWTYEFN7EPEX/H6w81VNcQK/ONXpoQrNxNAqfbh5k7bIRmMm3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768596238; c=relaxed/simple;
	bh=v9e0IhYd6Yvt90eVJbhspINstcJb9Dyo8Gi+iarFD/4=;
	h=Date:To:From:Subject:Message-Id; b=iv56YO4BngnSvC1o4SuT9STEiutSnngQxPvGwPTAzdTAY+ppqQQy++x+uTmE1BW8f5n0/awHiCnU7CZg88vR8jxiUTqLwVP/1A/LqrxdhdDmKEVsImAegTb2PrBkUNiwm6DoAkyHMdt8IghgwX7h+VEFGMS7Z6iea4nosn9O8KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0qG2diyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0qG2diyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A15C116C6;
	Fri, 16 Jan 2026 20:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768596237;
	bh=v9e0IhYd6Yvt90eVJbhspINstcJb9Dyo8Gi+iarFD/4=;
	h=Date:To:From:Subject:From;
	b=0qG2diyhPsdbLHOYJQdRkZszplUVv253dbH/agveG1bD9HL9adxfFVZ+8eotZtM34
	 ImHOZuyuGqgv+ditBLcQ7+cNZ7Li69LHotqzj0AtbAJCdeucYffwl2COkwA/+HDaij
	 NVwTcSzXEaFmK8Tq446QYD9bxANl35/yGYrSn76g=
Date: Fri, 16 Jan 2026 12:43:57 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,sj@kernel.org,ran.xiaokai@zte.com.cn,kent.overstreet@linux.dev,corbet@lwn.net,akpm@linux-foundation.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-allocation-profiling-describe-sysctrl-limitations-in-debug-mode.patch added to mm-hotfixes-unstable branch
Message-Id: <20260116204357.C0A15C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/allocation-profiling: describe sysctrl limitations in debug mode
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     docs-mm-allocation-profiling-describe-sysctrl-limitations-in-debug-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-allocation-profiling-describe-sysctrl-limitations-in-debug-mode.patch

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
@@ -487,6 +487,10 @@ memory allocations.
 
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

docs-mm-allocation-profiling-describe-sysctrl-limitations-in-debug-mode.patch

