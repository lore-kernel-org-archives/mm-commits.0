Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D23111BF
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 19:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749067147; cv=none; b=nVD0EOZnA+W54Q++xMsETPq4th13SO3dmh/C6qRxdaNRsKQdcE31cQvdOY7scSiiTg+xkPYiANCGl/FzSM3poAm2kTtKTliT9bx0aQonW3iX76ptPvvVOcxuPbXnNyUnnqPo9zhWeRy8oHtP/pdpO1y2XLn0g4paIGlVnIuSP/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749067147; c=relaxed/simple;
	bh=JaA5VoEFOxg92XnnnpzgfulrBi4I4epyBzUo1RPGFXw=;
	h=Date:To:From:Subject:Message-Id; b=A/sn5QVj3QtdzHMRuVXAepBueBsbj3jiaJQ1hKXmMv9jwRpzC7PqPkSkLDRGkTPCwgHH7UHDDQ4ozYfvd5peHhTY8RSxJCZDfvjf4nqS1MrW2N5NMlBN1nQLFLgSu7jsuy5ONAuhYZpTsSsF+hrvwutKyMlMJJ2xTKCnuGzpd/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0umpU3qJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0umpU3qJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886B8C4CEE4;
	Wed,  4 Jun 2025 19:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749067146;
	bh=JaA5VoEFOxg92XnnnpzgfulrBi4I4epyBzUo1RPGFXw=;
	h=Date:To:From:Subject:From;
	b=0umpU3qJ3YujeTsdNBZmQlNU9CcpcDqOOooXRz1Ga5/q+8nkGjR6TTvWElH4RhHqQ
	 tUyquCW2zVgUfzRatq5o3wAOXCkyjGf3yD1eVo+dHkDLXahpyMUI/6HdSL+0uNkqLT
	 ISJPGRXePQTZNNYipDh5eFQ2Y7SH8OaQFhHfm1H0=
Date: Wed, 04 Jun 2025 12:59:06 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch added to mm-new branch
Message-Id: <20250604195906.886B8C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon: add DAMON_STAT usage document
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: Docs/admin-guide/mm/damon: add DAMON_STAT usage document
Date: Wed, 4 Jun 2025 11:31:27 -0700

Document DAMON_STAT usage and add a link to it on DAMON admin-guide page.

Link: https://lkml.kernel.org/r/20250604183127.13968-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/index.rst |    1 
 Documentation/admin-guide/mm/damon/stat.rst  |   69 +++++++++++++++++
 2 files changed, 70 insertions(+)

--- a/Documentation/admin-guide/mm/damon/index.rst~docs-admin-guide-mm-damon-add-damon_stat-usage-document
+++ a/Documentation/admin-guide/mm/damon/index.rst
@@ -14,3 +14,4 @@ access monitoring and access-aware syste
    usage
    reclaim
    lru_sort
+   stat
diff --git a/Documentation/admin-guide/mm/damon/stat.rst a/Documentation/admin-guide/mm/damon/stat.rst
new file mode 100644
--- /dev/null
+++ a/Documentation/admin-guide/mm/damon/stat.rst
@@ -0,0 +1,69 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
+Data Access Monitoring Results Stat
+===================================
+
+Data Access Monitoring Results Stat (DAMON_STAT) is a static kernel module that
+is aimed to be used for simple access pattern monitoring.  It monitors accesses
+on the system's entire physical memory using DAMON, and provides simplified
+access monitoring results statistics, namely idle time percentiles and
+estimated memory bandwidth.
+
+Monitoring Accuracy and Overhead
+================================
+
+DAMON_STAT uses monitoring intervals :ref:`auto-tuning
+<damon_design_monitoring_intervals_autotuning>` to make its accuracy high and
+overhead minimum.  It auto-tunes the intervals aiming 4 % of observable access
+events to be captured in each snapshot, while limiting the resulting sampling
+events to be 5 milliseconds in minimum and 10 seconds in maximum.  On a few
+production server systems, it resulted in consuming only 0.x % single CPU time,
+while capturing reasonable quality of access patterns.
+
+Interface: Module Parameters
+============================
+
+To use this feature, you should first ensure your system is running on a kernel
+that is built with ``CONFIG_DAMON_STAT=y``.  The feature can be enabled by
+default at build time, by setting ``CONFIG_DAMON_STAT_ENABLED_DEFAULT`` true.
+
+To let sysadmins enable or disable it at boot and/or runtime, and read the
+monitoring results, DAMON_STAT provides module parameters.  Following
+sections are descriptions of the parameters.
+
+enabled
+-------
+
+Enable or disable DAMON_STAT.
+
+You can enable DAMON_STAT by setting the value of this parameter as ``Y``.
+Setting it as ``N`` disables DAMON_STAT.  The default value is set by
+``CONFIG_DAMON_STAT_ENABLED_DEFAULT`` build config option.
+
+estimated_memory_bandwidth
+--------------------------
+
+Estimated memory bandwidth consumption (bytes per second) of the system.
+
+DAMON_STAT reads observed access events on the current DAMON results snapshot
+and converts it to memory bandwidth consumption estimation in bytes per second.
+The resulting metric is exposed to user via this read-only parameter.  Because
+DAMON uses sampling, this is only an estimation of the access intensity rather
+than accurate memory bandwidth.
+
+memory_idle_ms_percentiles
+--------------------------
+
+Per-byte idle time (milliseconds) percentiles of the system.
+
+DAMON_STAT calculates how long each byte of the memory was not accessed until
+now (idle time), based on the current DAMON results snapshot.  If DAMON found a
+region of access frequency (nr_accesses) larger than zero, every byte of the
+region gets zero idle time.  If a region has zero access frequency
+(nr_accesses), how long the region was keeping the zero access frequency (age)
+becomes the idle time of every byte of the region.  Then, DAMON_STAT exposes
+the percentiles of the idle time values via this read-only parameter.  Reading
+the parameter returns 101 idle time values in milliseconds, separated by comma.
+Each value represents 0-th, 1st, 2nd, 3rd, ..., 99th and 100th percentile idle
+times.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-handle-madvise_lock-failure-during-race-unwinding.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch

