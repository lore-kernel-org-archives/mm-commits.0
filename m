Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D55345563C
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 22:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682734; cv=none; b=ILLPYrUHZFfe7HAyf/nTwoVbRAjuK3bYqDHkzimMExrcxhiCIFrK2IW9FbgAbmtS6bBWj6YaPC/1FH41AUJQbBLUKTgXT4Sn09D08L9a3poH8SucmsLuiCCBsylgjYfuEo+Jx1n1a5inmrwu8gYDnHKy95WB8OgqqnWj2h5Qbek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682734; c=relaxed/simple;
	bh=EbwBGhRN0lPv5Nb8SfeyuxPe8B7TrsvG4p3qlDYkzQc=;
	h=Date:To:From:Subject:Message-Id; b=uCFO2YHKonlwi49/bqbNzEuu6u0C8xk7d9xu8cAXOjumd/YqIHgsGM9jrMSuqzsWEkgq2oEl6PitRz14LTENYPpHE9FcZ9RaMosHa/b3ugQAH+F//tOEU3OrasAbbOu9PG+nCqO2kHO//9ofsJRQF0w1FA0EPwAOBe4iPM4Acho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xz/qYEPh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xz/qYEPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542351F00893;
	Thu, 17 Sep 2026 22:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789682732;
	bh=4KbxcZH5D3qUZSqb5zSK1LQUEDx+ovdUeYmjHru6GSc=;
	h=Date:To:From:Subject;
	b=xz/qYEPhO6F788jEjGZeaVeUaY5r8J9Urjp8oONUoa3wky0fghiu+n4fTmD3chaxa
	 +37+YjHEaevOTxXXydf8JLQJK2SnweviNaqUf3j8NwfQDeszKqTST88R1BZg6EUDOX
	 2yuASwfyMnuW2LvMyAXrvWJb3ooDXUepF+OF2Guc=
Date: Thu, 17 Sep 2026 15:05:31 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-raise-min_unref_scans-to-3-for-verbose-auto-scan.patch added to mm-new branch
Message-Id: <20260917220532.542351F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmemleak: raise min_unref_scans to 3 for verbose auto-scan
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-raise-min_unref_scans-to-3-for-verbose-auto-scan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-raise-min_unref_scans-to-3-for-verbose-auto-scan.patch

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
Subject: mm: kmemleak: raise min_unref_scans to 3 for verbose auto-scan
Date: Thu, 17 Sep 2026 06:47:37 -0700

CONFIG_DEBUG_KMEMLEAK_VERBOSE sends every report to the console, so a
transient false positive there is broadcast to whatever collects the
kernel log rather than sitting in the debugfs file until someone looks. 
That asymmetry justifies being more conservative than the general case.

Require one more consecutive unreferenced scan before reporting.  The only
cost is that a genuine leak is reported one scan interval later (600s by
default); the value stays writable at run time through the module
parameter.

Kernels without CONFIG_DEBUG_KMEMLEAK_VERBOSE keep reporting on the first
unreferenced scan.

I've been running constant upstream kernel with
CONFIG_DEBUG_KMEMLEAK_VERBOSE set, and I am still seeing some rare false
positive, that goes away with min_unref_scans=3, so, making it the default
based on my heuristic.

Link: https://lore.kernel.org/20260917-b4-kmemleak-doc-v1-3-84fde6d1f749@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
---

 Documentation/dev-tools/kmemleak.rst |    2 +-
 mm/kmemleak.c                        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/dev-tools/kmemleak.rst~mm-kmemleak-raise-min_unref_scans-to-3-for-verbose-auto-scan
+++ a/Documentation/dev-tools/kmemleak.rst
@@ -206,7 +206,7 @@ the minimum age of an object to be repor
 
 The ``min_unref_scans`` module parameter requires an object to be seen
 unreferenced in that many consecutive scans before it is reported. It
-defaults to 2 when CONFIG_DEBUG_KMEMLEAK_VERBOSE is enabled, where the
+defaults to 3 when CONFIG_DEBUG_KMEMLEAK_VERBOSE is enabled, where the
 periodic scan thread confirms a leak on its own, and to 1 otherwise. A
 value of 1 preserves the historical behaviour; higher values filter the
 transient false positives described above, at the cost of delaying genuine
--- a/mm/kmemleak.c~mm-kmemleak-raise-min_unref_scans-to-3-for-verbose-auto-scan
+++ a/mm/kmemleak.c
@@ -238,7 +238,7 @@ static struct task_struct *scan_thread;
 static unsigned long jiffies_min_age;
 /* consecutive scans an object must stay unreferenced before reporting */
 static unsigned int min_unref_scans =
-	IS_ENABLED(CONFIG_DEBUG_KMEMLEAK_VERBOSE) ? 2 : 1;
+	IS_ENABLED(CONFIG_DEBUG_KMEMLEAK_VERBOSE) ? 3 : 1;
 module_param(min_unref_scans, uint, 0644);
 static unsigned long jiffies_last_scan;
 /* delay between automatic memory scannings */
_

Patches currently in -mm which might be from leitao@debian.org are

mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device.patch
mm-fail-the-fault-on-a-malformed-swap-entry-instead-of-retrying-it.patch
documentation-kmemleak-describe-the-metadata-pool-not-the-early-log.patch
documentation-kmemleak-fix-stale-statements-about-scanning.patch
mm-kmemleak-raise-min_unref_scans-to-3-for-verbose-auto-scan.patch

