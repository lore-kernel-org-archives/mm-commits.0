Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BE23A4523
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 22:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682730; cv=none; b=L4KFI+Fh6XvImXcGDJUIafl0WJqGhJJ9NF+4CHEO2Rjc+bBM5DnuiSUUbR0Si/7wOUBxj719/KSvnHcgTkMhGfaaM9zU1V2g57YV+n+o7qOMaVG8fdfzF5F/BKdI84ngveyHxKyWF+eCspMWKAZVkNljTfrhHzv172LT8XOBQJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682730; c=relaxed/simple;
	bh=d9tGtG51IEyZmaIhV00XbhR5WW8qejXjSOazJz+xDzE=;
	h=Date:To:From:Subject:Message-Id; b=sRyzLH1uwDrrKQ7kgC/3l9M4SgXJ/5SmvLQvBS7d7IFJYwkxCJnZ2Hk3/1a+aZJbYYV971shNacP7yE59qigrSVbmXT5PAB6zpK4H+iFeKTwIe/0zTENqsl6s/4olze71ALN+WsMVANU874+WBAnAQoyHqdZDAlVB7cdrskQK40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U8qMI050; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U8qMI050"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FD01F00898;
	Thu, 17 Sep 2026 22:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789682728;
	bh=zLSNFUwAaEg2Y7Lsu1+29zrSQh/jROrbbnqC7IF1DzM=;
	h=Date:To:From:Subject;
	b=U8qMI050E0LS9Lr+mLz1R6L2zaL/Org/aHQ2SB7GD0Xq+XM/W+9pXbraNjP29Nsjx
	 w7TAXNiApee48Zw0XiiXjkgssuh4gaxtTkWR48XUe+inR3I4Qc9OZGs6nrVAec7y0f
	 6pcu1/ha5E5Om0f7rGo3+//KOHK4ZSLDkdDDFHjU=
Date: Thu, 17 Sep 2026 15:05:28 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-kmemleak-describe-the-metadata-pool-not-the-early-log.patch added to mm-new branch
Message-Id: <20260917220528.61FD01F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: kmemleak: describe the metadata pool, not the early log
has been added to the -mm mm-new branch.  Its filename is
     documentation-kmemleak-describe-the-metadata-pool-not-the-early-log.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-kmemleak-describe-the-metadata-pool-not-the-early-log.patch

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
Subject: Documentation: kmemleak: describe the metadata pool, not the early log
Date: Thu, 17 Sep 2026 06:47:35 -0700

Patch series "kmemleak: fix stale documentation and raise the verbose
default".

The first two patches fix statements in
Documentation/dev-tools/kmemleak.rst that do not match mm/kmemleak.c.

The third requires one more consecutive unreferenced scan before a
CONFIG_DEBUG_KMEMLEAK_VERBOSE kernel reports a leak on the console, to
avoid the last false positives I am seeing when running
CONFIG_DEBUG_KMEMLEAK_VERBOSE on a daily basis.


This patch (of 3):

commit c5665868183f ("mm: kmemleak: use the memory pool for early
allocations") removed the early log buffer in favour of a static pool of
kmemleak_object structures, but the documentation still describes the old
mechanism.

Fix the documentation by describing what the pool actually is, matching
the Kconfig help text.

Link: https://lore.kernel.org/20260917142210.90829-1-sj@kernel.org
Link: https://lore.kernel.org/20260917-b4-kmemleak-doc-v1-1-84fde6d1f749@debian.org
Fixes: c5665868183f ("mm: kmemleak: use the memory pool for early allocations")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
---

 Documentation/dev-tools/kmemleak.rst |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/Documentation/dev-tools/kmemleak.rst~documentation-kmemleak-describe-the-metadata-pool-not-the-early-log
+++ a/Documentation/dev-tools/kmemleak.rst
@@ -66,9 +66,14 @@ Memory scanning parameters can be modifi
 Kmemleak can also be disabled at boot-time by passing ``kmemleak=off`` on
 the kernel command line.
 
-Memory may be allocated or freed before kmemleak is initialised and
-these actions are stored in an early log buffer. The size of this buffer
-is configured via the CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE option.
+Memory may be allocated or freed before kmemleak is initialised, so a
+static pool of metadata objects is used to track those allocations. Once
+kmemleak is fully initialised the pool becomes an emergency reserve, used
+whenever a metadata object cannot be allocated from the slab. The number
+of objects in the pool is configured via the
+CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE option. Exhausting it at run time
+prints "Cannot allocate a kmemleak_object structure" and disables
+kmemleak.
 
 If CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF are enabled, the kmemleak is
 disabled by default. Passing ``kmemleak=on`` on the kernel command
_

Patches currently in -mm which might be from leitao@debian.org are

mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device.patch
mm-fail-the-fault-on-a-malformed-swap-entry-instead-of-retrying-it.patch
documentation-kmemleak-describe-the-metadata-pool-not-the-early-log.patch
documentation-kmemleak-fix-stale-statements-about-scanning.patch
mm-kmemleak-raise-min_unref_scans-to-3-for-verbose-auto-scan.patch

