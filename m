Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A4614F90
	for <mm-commits@vger.kernel.org>; Sat, 11 Jan 2025 00:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556350; cv=none; b=XCKV5Hgp6miWbeB4ghuGNsPdpSChC4QHFcgeffvDbEGlhEJu7yhbZGBmCcfnoT3dp/12iFV6Soy+UNUjkfdmj+jpFDXtRdYKOEYzC6Zm5oweM2muMwFEikAYrFY8eBYW92oN6eabobGU3S7KOSuj/CIW4I5n5w+RVqYX9NpL2wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556350; c=relaxed/simple;
	bh=EGV03ENmkGUYKdux20B1d3jHoA7QxFrpahPNH4Wab60=;
	h=Date:To:From:Subject:Message-Id; b=KqzITfm73jfGE3dhPBPFpM8MJtZWALhePqBNXXubrrDXJ8JUHYfFS9Fu7VJlksWcR0RjQspBxNHgz+90oXPX+NAfwVUgu+hbMVfzzOydzIUSO+WkjZYbaX+Kodwop9zXDWioY+1c6X+ol3CFqCMrDIF+D/S+PXID+fvQ4gJQ2zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q4Jtvpp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q4Jtvpp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25B1C4CED6;
	Sat, 11 Jan 2025 00:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736556349;
	bh=EGV03ENmkGUYKdux20B1d3jHoA7QxFrpahPNH4Wab60=;
	h=Date:To:From:Subject:From;
	b=q4Jtvpp+9GUSpDWytR9bEHX44e4w0+VDeFx83CmKTEfIdHHxvgYRYEoTTI0kcREJm
	 KYhaH+hYAemfvAauCSMMS4c78jgVCaRvq0gkqFGRJmsRGzGbaRWJddOWEsgBGQ9iub
	 yXXcEum5uweClV0OcDXSFxi/c9GrNSFvEcMqbR5w=
Date: Fri, 10 Jan 2025 16:45:49 -0800
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,wang.yaxin@zte.com.cn,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-filesystems-procrst-fix-possessive-form-of-process.patch added to mm-unstable branch
Message-Id: <20250111004549.B25B1C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/filesystems/proc.rst: fix possessive form of "process"
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-filesystems-procrst-fix-possessive-form-of-process.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-filesystems-procrst-fix-possessive-form-of-process.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Documentation/filesystems/proc.rst: fix possessive form of "process"
Date: Fri Jan 10 04:38:41 PM PST 2025

The possessive form of "process" is "process's".  Fix up various
misdirected attempts at this.  Also reflow some paragraphs.

Cc: David Hildenbrand <david@redhat.com>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   36 +++++++++++++++------------
 1 file changed, 20 insertions(+), 16 deletions(-)

--- a/Documentation/filesystems/proc.rst~documentation-filesystems-procrst-fix-possessive-form-of-process
+++ a/Documentation/filesystems/proc.rst
@@ -48,7 +48,7 @@ fixes/update part 1.1  Stefani Seibold <
   3.11	/proc/<pid>/patch_state - Livepatch patch operation state
   3.12	/proc/<pid>/arch_status - Task architecture specific information
   3.13  /proc/<pid>/fd - List of symlinks to open files
-  3.14  /proc/<pid/ksm_stat - Information about the process' ksm status.
+  3.14  /proc/<pid/ksm_stat - Information about the process's ksm status.
 
   4	Configuring procfs
   4.1	Mount options
@@ -485,14 +485,15 @@ Memory Area, or VMA) there is a series o
     THPeligible:           0
     VmFlags: rd ex mr mw me dw
 
-The first of these lines shows the same information as is displayed for the
-mapping in /proc/PID/maps.  Following lines show the size of the mapping
-(size); the size of each page allocated when backing a VMA (KernelPageSize),
-which is usually the same as the size in the page table entries; the page size
-used by the MMU when backing a VMA (in most cases, the same as KernelPageSize);
-the amount of the mapping that is currently resident in RAM (RSS); the
-process' proportional share of this mapping (PSS); and the number of clean and
-dirty shared and private pages in the mapping.
+The first of these lines shows the same information as is displayed for
+the mapping in /proc/PID/maps.  Following lines show the size of the
+mapping (size); the size of each page allocated when backing a VMA
+(KernelPageSize), which is usually the same as the size in the page table
+entries; the page size used by the MMU when backing a VMA (in most cases,
+the same as KernelPageSize); the amount of the mapping that is currently
+resident in RAM (RSS); the process's proportional share of this mapping
+(PSS); and the number of clean and dirty shared and private pages in the
+mapping.
 
 The "proportional set size" (PSS) of a process is the count of pages it has
 in memory, where each page is divided by the number of processes sharing it.
@@ -2233,8 +2234,8 @@ The number of open files for the process
 of stat() output for /proc/<pid>/fd for fast access.
 -------------------------------------------------------
 
-3.14 /proc/<pid/ksm_stat - Information about the process' ksm status
---------------------------------------------------------------------
+3.14 /proc/<pid/ksm_stat - Information about the process's ksm status
+---------------------------------------------------------------------
 When CONFIG_KSM is enabled, each process has this file which displays
 the information of ksm merging status.
 
@@ -2288,15 +2289,18 @@ memory consumed.
 ksm_merge_any
 ^^^^^^^^^^^^^
 
-It specifies whether the process'mm is added by prctl() into the candidate list
-of KSM or not, and KSM scanning is fully enabled at process level.
+It specifies whether the process's mm is added by prctl() into the
+candidate list of KSM or not, and KSM scanning is fully enabled at process
+level.
 
 ksm_mergeable
 ^^^^^^^^^^^^^
 
-It specifies whether any VMAs of the process'mm are currently applicable to KSM.
+It specifies whether any VMAs of the process's mm are currently applicable
+to KSM.
 
-More information about KSM can be found at Documentation/admin-guide/mm/ksm.rst.
+More information about KSM can be found at
+Documentation/admin-guide/mm/ksm.rst.
 
 
 Chapter 4: Configuring procfs
@@ -2327,7 +2331,7 @@ arguments are now protected against loca
 hidepid=invisible or hidepid=2 means hidepid=1 plus all /proc/<pid>/ will be
 fully invisible to other users.  It doesn't mean that it hides a fact whether a
 process with a specific pid value exists (it can be learned by other means, e.g.
-by "kill -0 $PID"), but it hides process' uid and gid, which may be learned by
+by "kill -0 $PID"), but it hides process's uid and gid, which may be learned by
 stat()'ing /proc/<pid>/ otherwise.  It greatly complicates an intruder's task of
 gathering information about running processes, whether some daemon runs with
 elevated privileges, whether other user runs some sensitive program, whether
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
replace-free-hugepage-folios-after-migration-fix.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb-fix.patch
documentation-filesystems-procrst-fix-possessive-form-of-process.patch
xarray-port-tests-to-kunit-fix.patch
checkpatch-check-return-of-git_commit_info-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

