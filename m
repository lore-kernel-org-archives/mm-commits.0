Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310BC2C027C
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 21:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786570567; cv=none; b=Pqgd5uRU9xObcIvxSeg1c7RR8mxp3Jv2heucaFsori9hvBr8HOfmZeLXoG7gqc9o++/s0MIy6EfWd8BT/ZRWVU72YvOCkjYhbPCbHN3BtUcM7Y3Zr4Vs3AGJBBGUEYlPBf3QJNbnBCZoFM/LcCywZSdkvlkhscpaJR3Z2BQkGDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786570567; c=relaxed/simple;
	bh=iWQfMmhpFbqp4znCJrKW6oaFCBToKRxiczYxCuCIA24=;
	h=Date:To:From:Subject:Message-Id; b=SCmv0d6V/FunS6daUMlXMAwHEJfBYb42PXGMbIW3wlRXANKuOI7dT4dS/LpIFfuDQOpvDv3dHK9LQzoHoiGdS1AyTehiiWGtD7EPaKBCc+BmxrJ6KCC1kG8U/f4nSXdeEl5ctkfa5rKzVCqIVsq9NGBQ8k3cqUlg+k8L2usgovU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mkavy0rl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mkavy0rl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934E31F000E9;
	Wed, 12 Aug 2026 21:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786570565;
	bh=BO3FDECrdNFIXwVCf8QwHIZ2T1SaaaWC6KTQRNBGGO8=;
	h=Date:To:From:Subject;
	b=Mkavy0rl5j0jHaQEkgf+yckI6NtpfbsNclmsgGsMLbT56FVwPf0A8x5SPY6HATsHg
	 tkV4HGBVAZ4E9ZHNmlmA5R7QpZoBrmkooqJ1RG1s2T7nAQ7eXLvQwHQzZ/FB6FTI79
	 0uNuH3H7T2IypczcO0fTtxkUWszt043o4dScDme8=
Date: Wed, 12 Aug 2026 14:36:05 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rostedt@goodmis.org,kent.overstreet@linux.dev,gmonaco@redhat.com,dennis@kernel.org,akpm@linux-foundation.org,tj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-drop-config_debug_force_weak_per_cpu.patch added to mm-new branch
Message-Id: <20260812213605.934E31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: drop CONFIG_DEBUG_FORCE_WEAK_PER_CPU
has been added to the -mm mm-new branch.  Its filename is
     percpu-drop-config_debug_force_weak_per_cpu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-drop-config_debug_force_weak_per_cpu.patch

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
From: Tejun Heo <tj@kernel.org>
Subject: percpu: drop CONFIG_DEBUG_FORCE_WEAK_PER_CPU
Date: Wed, 12 Aug 2026 09:47:43 -1000

alpha requires percpu variables in modules to be defined as weak so that the
compiler generates GOT based external references for them. This puts two
extra restrictions on percpu variable definitions. The symbol must be
globally unique even when static and a static percpu variable can't be
defined inside a function. DEBUG_FORCE_WEAK_PER_CPU exists to give generic
code build coverage for these restrictions without building for alpha.

MEM_ALLOC_PROFILING defines a static percpu counter at each allocation call
site and thus can't be built with weak percpu definitions, so it depends on
!DEBUG_FORCE_WEAK_PER_CPU. As allmodconfig enables DEBUG_FORCE_WEAK_PER_CPU,
this knocks MEM_ALLOC_PROFILING out of allmodconfig build coverage.

allmodconfig coverage for MEM_ALLOC_PROFILING is worth more than build
coverage for restrictions which only matter to alpha module builds. Drop
DEBUG_FORCE_WEAK_PER_CPU. Restriction violations will now show up only on
alpha builds.

Link: https://lore.kernel.org/178656406317.2437052.7257990869957704195@slm.duckdns.org
Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Gabriele Monaco <gmonaco@redhat.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-defs.h |    7 +------
 include/rv/da_monitor.h     |    2 +-
 lib/Kconfig.debug           |   15 ---------------
 mm/Kconfig.debug            |    1 -
 4 files changed, 2 insertions(+), 23 deletions(-)

--- a/include/linux/percpu-defs.h~percpu-drop-config_debug_force_weak_per_cpu
+++ a/include/linux/percpu-defs.h
@@ -65,13 +65,8 @@
  *
  * Archs which need weak percpu definitions should set
  * CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU when necessary.
- *
- * To ensure that the generic code observes the above two
- * restrictions, if CONFIG_DEBUG_FORCE_WEAK_PER_CPU is set weak
- * definition is used for all cases.
  */
-#if (defined(CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU) && defined(MODULE)) || \
-	defined(CONFIG_DEBUG_FORCE_WEAK_PER_CPU)
+#if defined(CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU) && defined(MODULE)
 /*
  * __pcpu_scope_* dummy variable is used to enforce scope.  It
  * receives the static modifier when it's used in front of
--- a/include/rv/da_monitor.h~percpu-drop-config_debug_force_weak_per_cpu
+++ a/include/rv/da_monitor.h
@@ -24,7 +24,7 @@
 
 /*
  * Per-cpu variables require a unique name although static in some
- * configurations (e.g. CONFIG_DEBUG_FORCE_WEAK_PER_CPU or alpha modules).
+ * configurations (e.g. alpha modules).
  */
 #define DA_MON_NAME CONCATENATE(da_mon_, MONITOR_NAME)
 
--- a/lib/Kconfig.debug~percpu-drop-config_debug_force_weak_per_cpu
+++ a/lib/Kconfig.debug
@@ -613,21 +613,6 @@ config BUILTIN_MODULE_RANGES
 	 It also records an anchor symbol to determine the load address of the
 	 section.
 
-config DEBUG_FORCE_WEAK_PER_CPU
-	bool "Force weak per-cpu definitions"
-	depends on DEBUG_KERNEL
-	help
-	  s390 and alpha require percpu variables in modules to be
-	  defined weak to work around addressing range issue which
-	  puts the following two restrictions on percpu variable
-	  definitions.
-
-	  1. percpu symbols must be unique whether static or not
-	  2. percpu variables can't be defined inside a function
-
-	  To ensure that generic code follows the above rules, this
-	  option forces all percpu variables to be defined as weak.
-
 config WARN_CONTEXT_ANALYSIS
 	bool "Compiler context-analysis warnings"
 	depends on CC_IS_CLANG && CLANG_VERSION >= 230000
--- a/mm/Kconfig.debug~percpu-drop-config_debug_force_weak_per_cpu
+++ a/mm/Kconfig.debug
@@ -326,7 +326,6 @@ config MEM_ALLOC_PROFILING
 	default n
 	depends on MMU
 	depends on PROC_FS
-	depends on !DEBUG_FORCE_WEAK_PER_CPU
 	select CODE_TAGGING
 	select PAGE_EXTENSION
 	select SLAB_OBJ_EXT
_

Patches currently in -mm which might be from tj@kernel.org are

percpu-drop-config_debug_force_weak_per_cpu.patch

