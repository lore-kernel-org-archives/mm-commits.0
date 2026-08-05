Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CAF3C2D
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 18:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785953857; cv=none; b=jLzLqCtb7nVBAOnsT2+7ylYnxGigx9HKD9PteVJgjIMZ/jsLTZD0inCEIljVfDQmIyl4zWUJtDy4jXLzFLl51Xx39NuMftyQRozXwH3b6dm6xzPqaWR7RWU7TLaHSKEWsiC6/df/yRp0QPRdOWEPpLK0qfwNlqsU2sDZFmiamnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785953857; c=relaxed/simple;
	bh=++vhinFu9MC/z4o14cs9+iHypC8ZQ6uU7ICFu6SsFSc=;
	h=Date:To:From:Subject:Message-Id; b=rn1NXTrohl+p+roO4qcFojqD6MuwsE8WX6afrQjU8v6GVBQ8kvYxox/vOLMA6+w9rqpswlBo1s1gNSnM2VXg6aV+M7z/9BsHwY3WnH8o0dHoOWKlGxYOnhaM0n+jBAZglgK6Dqi8m09M18BQ75XZBWHNPYDDoTmf7DTXbpHb8oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d5ksgMos; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d5ksgMos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D711F000E9;
	Wed,  5 Aug 2026 18:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785953856;
	bh=xt00W6kIWafOo78bbm9cepcEGVDHy/RuJMhRd1D0QzE=;
	h=Date:To:From:Subject;
	b=d5ksgMoslRamX9P2cKAwugHiQ9t8DimpPyCMgixwLfZJNVy2V59d5jFUQtd+2gwWb
	 B40svyp21OgV6MPdGFcMF2ZDpXsa/5tYBi5UQ2qn0cOkj5BKTyKcDDLnEQEh/MEDKt
	 1tQbQDsU9m4j2P3HywTYrdWSkGg+rafEtEeV0KN8=
Date: Wed, 05 Aug 2026 11:17:35 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,hao.ge@linux.dev,abhishekbapat@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-expose-boot-time-compression-configuration.patch added to mm-new branch
Message-Id: <20260805181736.14D711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: expose boot-time compression configuration
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-expose-boot-time-compression-configuration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-expose-boot-time-compression-configuration.patch

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
From: Abhishek Bapat <abhishekbapat@google.com>
Subject: alloc_tag: expose boot-time compression configuration
Date: Wed, 5 Aug 2026 17:29:52 +0000

Currently, userspace has limited visibility into the exact active runtime
state of memory allocation profiling and its page extension compression
('sysctl.vm.mem_profiling={0|1|never}[,compressed]').

While reading the sysctl provides basic on/off status, it is currently
impossible for userspace to natively determine whether page-tag
compression was successfully enabled without scraping dmesg boot logs.

Add a new read-only sysctl representing how compression was configured
at boot time.

Link: https://lore.kernel.org/c795f8089f82841e8a6e00d7ca286da2b23aeb7b.1785950530.git.abhishekbapat@google.com
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Cc: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/allocation-profiling.rst |   11 +++++++++++
 mm/alloc_tag.c                            |    6 ++++++
 2 files changed, 17 insertions(+)

--- a/Documentation/mm/allocation-profiling.rst~alloc_tag-expose-boot-time-compression-configuration
+++ a/Documentation/mm/allocation-profiling.rst
@@ -43,6 +43,17 @@ sysctl:
   warnings produced by allocations made while profiling is disabled and freed
   when it's enabled.
 
+  /proc/sys/vm/mem_profiling_compressed
+
+  1: Page alloc tag compression is enabled.
+
+  0: Page alloc tag compression is disabled.
+
+  This reflects a static boot-time configuration of how page allocation tags are
+  stored (in page flags when compression is enabled and in page_ext when disabled).
+  Toggling ``mem_profiling`` at runtime does not change the state of
+  ``mem_profiling_compressed``.
+
 Runtime info:
   /proc/allocinfo
 
--- a/mm/alloc_tag.c~alloc_tag-expose-boot-time-compression-configuration
+++ a/mm/alloc_tag.c
@@ -1304,6 +1304,12 @@ static const struct ctl_table memory_all
 		.mode		= 0644,
 		.proc_handler	= proc_mem_profiling_handler,
 	},
+	{
+		.procname	= "mem_profiling_compressed",
+		.data		= &mem_profiling_compressed,
+		.mode		= 0444,
+		.proc_handler	= proc_do_static_key,
+	},
 };
 
 static void __init sysctl_init(void)
_

Patches currently in -mm which might be from abhishekbapat@google.com are

alloc_tag-add-ioctl-filters-to-proc-allocinfo.patch
alloc_tag-add-size-based-filtering-to-ioctl.patch
alloc_tag-add-accuracy-based-filtering-to-ioctl.patch
alloc_tag-add-accuracy-based-filtering-to-ioctl-fix.patch
kselftest-alloc_tag-add-kselftest-for-ioctl-interface.patch
kselftest-alloc_tag-add-kselftest-for-ioctl-interface-fix.patch
kselftest-alloc_tag-extend-the-allocinfo-ioctl-kselftest.patch
alloc_tag-expose-boot-time-compression-configuration.patch

