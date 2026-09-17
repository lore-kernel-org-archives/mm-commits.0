Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AFB4657E0
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 22:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682732; cv=none; b=nhYbZeV8IFkv8Q/wbvTrz3HxbcwfzS37xLF2WJ9LIfBg0DXDugLkDnc/wzyjezlqRENJJrAEGHsd/K7Je9C4w7ti44L25w7c+tixxOL+bgIwBzV0jFvx7Jm41gWPL3PENEvxdWmqy5683Cyxne20Zaf7X8dpL1DJYnbGYSPeyH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682732; c=relaxed/simple;
	bh=95ujxU83OQca6St85vkwVRS5aPQemevOO1zXuRL3C+0=;
	h=Date:To:From:Subject:Message-Id; b=rYhCdIghPSb129i0i7st/wdztulAFhj/I760qClIDlU5I0vL8hG33JCxlzrgjWR26UUFgWReEbNUZBkxwHkfZmBJXuR59dW1LSO50VLCt1+fUrHunXQ5Zxx7Tp2YPpf3mq9aBfA1f0qy1PXJZeE1JeyFFOMEY4+8VRkKgSE9t78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0A8SVYmC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0A8SVYmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1A61F000FF;
	Thu, 17 Sep 2026 22:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789682730;
	bh=BQ83WHuTayGMc3BhWgHnpRvp4JsjlnVcq/nSGFJMoxU=;
	h=Date:To:From:Subject;
	b=0A8SVYmC6wmZKQOKKEWlUwD00/yfg/WfhD2kEHsix+T7bMlUsNTNqHtgTojs1e82h
	 dpoDkyKSrkfnJUe7UxjRCor0PzesN9jP/ZD2Mxt6VwgInXvAgBdRaIU1Ox+brxMgCw
	 wei6SCzkVYq3+qosHY7H1p0jaeViMCgr3dCtbRMU=
Date: Thu, 17 Sep 2026 15:05:29 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-kmemleak-fix-stale-statements-about-scanning.patch added to mm-new branch
Message-Id: <20260917220530.5E1A61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: kmemleak: fix stale statements about scanning
has been added to the -mm mm-new branch.  Its filename is
     documentation-kmemleak-fix-stale-statements-about-scanning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-kmemleak-fix-stale-statements-about-scanning.patch

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
Subject: Documentation: kmemleak: fix stale statements about scanning
Date: Thu, 17 Sep 2026 06:47:36 -0700

Three statements in the "false positives/negatives" and "Limitations"
sections have never matched the code:

 - task stack scanning is on by default (kmemleak_stack_scan = 1), as
   the parameter list earlier in the same document already states;

 - MSECS_MIN_AGE has been 5000, not 1000, since the initial commit;

 - scanning is done by a periodic kthread. Reading the debugfs file
   only lists what the last scan found; kmemleak_open() calls
   seq_open() and never scans.

Link: https://lore.kernel.org/20260917-b4-kmemleak-doc-v1-2-84fde6d1f749@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Fixes: 04f70336c80c ("kmemleak: Add documentation on the memory leak detector")
Fixes: e0a2a1601bec ("kmemleak: Enable task stacks scanning by default")
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
---

 Documentation/dev-tools/kmemleak.rst |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/Documentation/dev-tools/kmemleak.rst~documentation-kmemleak-fix-stale-statements-about-scanning
+++ a/Documentation/dev-tools/kmemleak.rst
@@ -190,7 +190,8 @@ reported by kmemleak because values foun
 point to such objects. To reduce the number of false negatives, kmemleak
 provides the kmemleak_ignore, kmemleak_scan_area, kmemleak_no_scan and
 kmemleak_erase functions (see above). The task stacks also increase the
-amount of false negatives and their scanning is not enabled by default.
+amount of false negatives and their scanning is enabled by default; it
+can be turned off with ``stack=off``.
 
 The false positives are objects wrongly reported as being memory leaks
 (orphan). For objects known not to be leaks, kmemleak provides the
@@ -200,7 +201,7 @@ longer be scanned.
 
 Some of the reported leaks are only transient, especially on SMP
 systems, because of pointers temporarily stored in CPU registers or
-stacks. Kmemleak defines MSECS_MIN_AGE (defaulting to 1000) representing
+stacks. Kmemleak defines MSECS_MIN_AGE (defaulting to 5000) representing
 the minimum age of an object to be reported as a memory leak.
 
 The ``min_unref_scans`` module parameter requires an object to be seen
@@ -217,8 +218,10 @@ Limitations and Drawbacks
 -------------------------
 
 The main drawback is the reduced performance of memory allocation and
-freeing. To avoid other penalties, the memory scanning is only performed
-when the /sys/kernel/debug/kmemleak file is read. Anyway, this tool is
+freeing. To avoid other penalties, the memory scanning is performed by a
+periodic thread rather than on every allocation. Reading the
+/sys/kernel/debug/kmemleak file only lists the objects found by the last
+scan; writing ``scan`` to it triggers a new one. Anyway, this tool is
 intended for debugging purposes where the performance might not be the
 most important requirement.
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device.patch
mm-fail-the-fault-on-a-malformed-swap-entry-instead-of-retrying-it.patch
documentation-kmemleak-describe-the-metadata-pool-not-the-early-log.patch
documentation-kmemleak-fix-stale-statements-about-scanning.patch
mm-kmemleak-raise-min_unref_scans-to-3-for-verbose-auto-scan.patch

