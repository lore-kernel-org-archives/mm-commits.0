Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9101284687
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126211; cv=none; b=gbNiDSFWbQOjnz9kS+EtSe5wggRrgDT617tZtvvraN0/me6LXj4zrMOidOikGp/2L6V/0iqcchDzVpUvoy5mt+LU9E6H7Wu0lTJQ+HHOG+6wLJSaELFUNcwI+K7NdGYDa01db0vdZjfG/y+HAMKy2LJ2pcidta8w1aKKRtnWCkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126211; c=relaxed/simple;
	bh=UomESgMZbLKayJHf0S3tzpPZmHxWFxBLfHkmL7pwd3s=;
	h=Date:To:From:Subject:Message-Id; b=mXdq5XWmcCsS27M4PRU88I8zjVr9vq+fc69zVKfFsWazsxkZJ2V9ETgLOxgbDzGtFRjBz6tk9nGhnJ1GXlukN7aAVqG9gz2K1Gd0csxgdP4ArBb/lxKQsJ9oKGX5N7oJhRY9QU3UnmcF74Plbf6+ej8otWvHtMimRFHClvKZbE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uS7VqyPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uS7VqyPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20855C4CEE3;
	Thu, 10 Jul 2025 05:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126211;
	bh=UomESgMZbLKayJHf0S3tzpPZmHxWFxBLfHkmL7pwd3s=;
	h=Date:To:From:Subject:From;
	b=uS7VqyPJRugzjL5vGLpG1LVh26wZkHyA/Gb5eLXYTc+pvgyDHAiVS4O8VXKT+N8d7
	 hd3LvM7arFVk1uiXXe4pRdcaP93rJPWoHMdHYJSCUlnyXJSF/poJVwarKcA3luO4BM
	 X8QQusuvkh+f7Zy3FRBNUHdb01R+Nka48tKCF0LI=
Date: Wed, 09 Jul 2025 22:43:30 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch removed from -mm tree
Message-Id: <20250710054331.20855C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon: add DAMON_STAT usage document
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
mm-damon-add-trace-event-for-effective-size-quota-fix.patch
mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch
samples-damon-wsse-fix-boot-time-enable-handling.patch
samples-damon-prcl-fix-boot-time-enable-crash.patch
samples-damon-mtier-support-boot-time-enable-setup.patch
mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch
mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch
mm-damon-reclaim-use-parameter-context-correctly.patch
samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch

