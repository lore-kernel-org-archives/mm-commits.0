Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650533C661C
	for <mm-commits@vger.kernel.org>; Mon, 23 Mar 2026 17:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774287797; cv=none; b=sckvuIRCNpg6Wv4/tBCioViXHNXzxQ8mxQgTusTr3Bw+lrz0zY31ZTS2XN4efQ8P0PnaEpd1/uGXDHiSaUI2T9ltH3LCbucuMJ4lrHTvogdjadsa3uucX94xmx/48GdGf3tO8k14SiclqWwy1vE9PN3dEdgGhzz8Darq0PIVPOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774287797; c=relaxed/simple;
	bh=6omY8M8Ok1l98iJZa4kGUkOjIE6oI5xiy+5hkPbVqs8=;
	h=Date:To:From:Subject:Message-Id; b=sSXRZZBEqDpRH82y8L3wvtyJzTJv3n4BA0myjwIoq3Z3+xF2Lad+OpqWl0BGwUP2waQCQedEYzJqrIeBuxcaUQ27K4pApYb9mMzqUxRB35RtnWUvGJp3Qzha+9w1iEyMyL7uQQ1bDqbo/YhMkI4lFrmn4tD4rsh/8Lw8fdjpzJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JMlKoA/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JMlKoA/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2476C2BC9E;
	Mon, 23 Mar 2026 17:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774287797;
	bh=6omY8M8Ok1l98iJZa4kGUkOjIE6oI5xiy+5hkPbVqs8=;
	h=Date:To:From:Subject:From;
	b=JMlKoA/BoJ9FDUInzIVq1g3SXM4nbxvMs7Y/HM+SMJpqRGnhecOyOGSGeYrBR4fkW
	 UoJz6PtIS6MxJPISFm1GGgk63T7Gy7yAXPzXMF0m51OVufDXThEnpDaGttyO+14V0e
	 jtuAda07z/IDwsdAamgEAYvvBt5Rc2ipSdldbwg0=
Date: Mon, 23 Mar 2026 10:43:16 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch added to mm-new branch
Message-Id: <20260323174316.F2476C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmemleak: add CONFIG_DEBUG_KMEMLEAK_VERBOSE build option
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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

Link: https://lkml.kernel.org/r/20260323-kmemleak_report-v1-1-ba2cdd9c11b9@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
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

mm-khugepaged-export-set_recommended_min_free_kbytes.patch
mm-huge_memory-refactor-anon_enabled_store-with-set_anon_enabled_mode.patch
mm-huge_memory-refactor-enabled_store-with-set_global_enabled_mode.patch
mm-ratelimit-min_free_kbytes-adjustment-messages.patch
mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch

