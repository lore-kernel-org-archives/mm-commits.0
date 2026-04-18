Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B721B78F3
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498697; cv=none; b=NaxHIXsnUytCSFUU+20poiA+PTFktZkgHCasElH0wmHgPxbsxi72tnGhTqmHNh3dfOrT3XAfgVmzaXpsQuQ9xVlzikoXwl1QgHQaFwtAW6+ioYL6YcHs1R/spWwAhe4punri5nJvHC3m/vsanmCFupEW040a6KRAJmwecetTN6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498697; c=relaxed/simple;
	bh=w779K3KemaxDOxf4y7oPyG4fig9y6+2SJAFAUhVOLgY=;
	h=Date:To:From:Subject:Message-Id; b=UHRp35I9qwIouc+rPBzw+w517EZCUwxQqkxWM3Q+/YIW/uOli+D1Ztr8z9hDW/twwAozfxFPVl6SnAbWWcHA5D7hCW0xAj1ZZ1UpHja187OdOm92+AATrbkQjG7dRMVFBFYbdqp2K6y77Lwf1MjzW9tUSJvnOud0e1rt/0dSSnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RSb6RG8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RSb6RG8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5165C19424;
	Sat, 18 Apr 2026 07:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498696;
	bh=w779K3KemaxDOxf4y7oPyG4fig9y6+2SJAFAUhVOLgY=;
	h=Date:To:From:Subject:From;
	b=RSb6RG8pkVUq+F1MDg6QuLEWNTnVJvzrYcOge39jH8hjem5FLC3wgGmreZdGQceLr
	 Q43LSShHbHyhYHZg5UBUCpAS/kAxUQHY7GGIujlRJGuzwJEJnbt8zLdj1q0bFuiOyu
	 Eh3ezs1AJ5vEP0srFbqPizfSM6fBzLisEA2wuVT0=
Date: Sat, 18 Apr 2026 00:51:31 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch removed from -mm tree
Message-Id: <20260418075135.D5165C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmemleak: add CONFIG_DEBUG_KMEMLEAK_VERBOSE build option
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm: kmemleak: add CONFIG_DEBUG_KMEMLEAK_VERBOSE build option
Date: Mon, 23 Mar 2026 04:12:13 -0700

Add a Kconfig option to default kmemleak verbose mode on at build time. 
This option depends on DEBUG_KMEMLEAK_AUTO_SCAN since verbose reporting is
only meaningful when the automatic scanning thread is running.

When enabled, kmemleak prints full details (backtrace, hex dump, address)
of unreferenced objects to dmesg as they are detected during scanning,
removing the need to manually read /sys/kernel/debug/kmemleak.

Making this a compile-time option rather than a boot parameter allows
debug kernel flavors to enable verbose kmemleak reporting by default
without requiring changes to boot arguments.  A machine can simply swap to
a debug kernel and benefit from kmemleak reporting automatically.

By surfacing leak reports directly in dmesg, they are automatically
forwarded through any kernel logging infrastructure and can be easily
captured by log aggregation tooling, making it practical to monitor memory
leaks across large fleets.

The verbose setting can still be toggled at runtime via
/sys/module/kmemleak/parameters/verbose.

Link: https://lore.kernel.org/20260323-kmemleak_report-v1-1-ba2cdd9c11b9@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |   11 +++++++++++
 mm/kmemleak.c    |    2 +-
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/mm/Kconfig.debug~mm-kmemleak-add-config_debug_kmemleak_verbose-build-option
+++ a/mm/Kconfig.debug
@@ -297,6 +297,17 @@ config DEBUG_KMEMLEAK_AUTO_SCAN
 
 	  If unsure, say Y.
 
+config DEBUG_KMEMLEAK_VERBOSE
+	bool "Default kmemleak to verbose mode"
+	depends on DEBUG_KMEMLEAK_AUTO_SCAN
+	help
+	  Say Y here to have kmemleak print unreferenced object details
+	  (backtrace, hex dump, address) to dmesg when new memory leaks are
+	  detected during automatic scanning. This can also be toggled at
+	  runtime via /sys/module/kmemleak/parameters/verbose.
+
+	  If unsure, say N.
+
 config PER_VMA_LOCK_STATS
 	bool "Statistics for per-vma locks"
 	depends on PER_VMA_LOCK
--- a/mm/kmemleak.c~mm-kmemleak-add-config_debug_kmemleak_verbose-build-option
+++ a/mm/kmemleak.c
@@ -241,7 +241,7 @@ static int kmemleak_skip_disable;
 /* If there are leaks that can be reported */
 static bool kmemleak_found_leaks;
 
-static bool kmemleak_verbose;
+static bool kmemleak_verbose = IS_ENABLED(CONFIG_DEBUG_KMEMLEAK_VERBOSE);
 module_param_named(verbose, kmemleak_verbose, bool, 0600);
 
 static void kmemleak_disable(void);
_

Patches currently in -mm which might be from leitao@debian.org are

mm-blk-cgroup-fix-use-after-free-in-cgwb_release_workfn.patch
kho-fix-error-handling-in-kho_add_subtree.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

