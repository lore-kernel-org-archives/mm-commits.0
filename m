Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFAD23909F
	for <mm-commits@vger.kernel.org>; Tue, 11 Aug 2026 04:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786421067; cv=none; b=FB7lUNHqTbhKsFQDgil4WSMUOqCyfJnSk7iiGgjnX5ycs+9I9dDerVzBAN3nGbcSAgfWWSE7a+dTzOBO/UZASDDThE2uI1bHp0SfYtA01WVxMTeGgCctEkHJPBYW81Qdm8UE4kYBOwrfZurjoGTP3cRnCg4HmKzgDw6Vpr5kEWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786421067; c=relaxed/simple;
	bh=q4+I3QYu/WutFWF0F2Y4UBGV9JbBHhBgXMExrNzaJgQ=;
	h=Date:To:From:Subject:Message-Id; b=TAk1FuwkBjYCz4UkUpAT4Mta0v6hZxa4b2fnPPFpY6XdUIel3nhhtpg1eYluUUWVRrbT0E5cz8jWA7S5ikE4P5JwwiV/6/mAJif6Xi4S1SRWD6bbjvKUA4Nghc45Si/2m8OgkfvK3wXdP9ZoOi8BO9Sta1ZxWbnSDw9Zrwq8eR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EYm1+B/M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EYm1+B/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E68E1F000E9;
	Tue, 11 Aug 2026 04:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786421065;
	bh=7+9X9qKOA3giOPnUEZ2x+uTli1DXpuavKl1kBt3h954=;
	h=Date:To:From:Subject;
	b=EYm1+B/MmiKIQm63VdKL3IZjjdGroyKPiIRmhwb8eKEn30XRvJbUebPLc2IaHrRmA
	 fJ74EPbTL8s0w0JdaCMzN0wKMel7JWrFWNDQ1YDzae+cxg4UtqKvSnjOxUyrXGPea7
	 xWGrgabJsGg7kcxRh+YANjLwp8ogeQwapXojpmR4=
Date: Mon, 10 Aug 2026 21:04:24 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,surenb@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch added to mm-new branch
Message-Id: <20260811040425.4E68E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/Kconfig.debug: make DEBUG_FORCE_WEAK_PER_CPU depend on S390||ALPHA
has been added to the -mm mm-new branch.  Its filename is
     lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/Kconfig.debug: make DEBUG_FORCE_WEAK_PER_CPU depend on S390||ALPHA
Date: Mon Aug 10 08:50:56 PM PDT 2026

CONFIG_DEBUG_FORCE_WEAK_PER_CPU appears to be alpha-specific.  The Kconfig
help text says s390 can need it also, but the comment in percpu-defs.h
only mentions alpha.  The original commit 7c756e6e19e7 ("percpu: implement
optional weak percpu definitions") mentions both alpha and s390.

All quite mysterious and perhaps this feature is no longer needed.

However x86_64 allmodconfig enables it, and because mm/alloc_tag.c
requires !DEBUG_FORCE_WEAK_PER_CPU (another mystery), alloc_tag isn't
getting allmodconfig build coverage.

Adding `depends on S390||ALPHA' fixes this.

Cc: Tejun Heo <tj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.debug~lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha
+++ a/lib/Kconfig.debug
@@ -616,6 +616,7 @@ config BUILTIN_MODULE_RANGES
 config DEBUG_FORCE_WEAK_PER_CPU
 	bool "Force weak per-cpu definitions"
 	depends on DEBUG_KERNEL
+	depends on S390 || ALPHA
 	help
 	  s390 and alpha require percpu variables in modules to be
 	  defined weak to work around addressing range issue which
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch
mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
selftests-mm-use-pattern-matching-in-gitignore-fix.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

