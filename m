Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D684D3176F0
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 06:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755325264; cv=none; b=NEYQOiz+ZEoPdmQnhX/AimhQxviO4TXFET7KjQsc5dbml39MFcAn8RQJ1jAA23fR4ADkE1+jq4YiUBIMN1QkG70h2JwfdCx3htjFwI6KGFNaQqpJ57rsxdgGA6gXeXh9edSKu8eNw9HOUPnbB6ggL922s6vp6kAvSpJ9F+oYTEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755325264; c=relaxed/simple;
	bh=hWESBZ2X9bkp+mqpsilqOullsb1necx6yfr36ZucfQQ=;
	h=Date:To:From:Subject:Message-Id; b=fjjlSca4bzPJQDrYQEaSuqeDn3eZ0FxoUR8qZ8KWukIzIPJ+BduMOzPUT0fzX+4b3Yg8ZtuqlsJ2L3IL1F/3YILnY6yNd6/of9S3ykMBy+TE0yiHDb6rW9p2ra+0x4Au8xjvJhWV+eINTWwRIfqzPZZWlsSK44VlE9O5efuwB/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zTIkkdHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zTIkkdHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E02C4CEF0;
	Sat, 16 Aug 2025 06:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755325263;
	bh=hWESBZ2X9bkp+mqpsilqOullsb1necx6yfr36ZucfQQ=;
	h=Date:To:From:Subject:From;
	b=zTIkkdHWcUT3yQn9PyQ3EDciYoKzOfn9pD2qDRicmpHFasHdkuXNVL0333a/YSoOZ
	 yqdFVxYd1AbfgEpEAIfnskkFCMYkbBdeMhMNEv8GGaC1HcsRmsBsjB+70j06VOU2og
	 UDVV8uaMi7poM82iPwiWkoOG3AiTzeM8eujdlNg4=
Date: Fri, 15 Aug 2025 23:21:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,usamaarif642@gmail.com,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,laoar.shao@gmail.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,arnd@arndb.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage.patch added to mm-new branch
Message-Id: <20250816062103.48E02C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: prctl: extend PR_SET_THP_DISABLE to optionally exclude VM_HUGEPAGE
has been added to the -mm mm-new branch.  Its filename is
     prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: David Hildenbrand <david@redhat.com>
Subject: prctl: extend PR_SET_THP_DISABLE to optionally exclude VM_HUGEPAGE
Date: Fri, 15 Aug 2025 14:54:53 +0100

Patch series "prctl: extend PR_SET_THP_DISABLE to only provide THPs when
advised", v5.

This will allow individual processes to opt-out of THP = "always" into THP
= "madvise", without affecting other workloads on the system.  This has
been extensively discussed on the mailing list and has been summarized
very well by David in the first patch which also includes the links to
alternatives, please refer to the first patch commit message for the
motivation for this series.

Patch 1 adds the PR_THP_DISABLE_EXCEPT_ADVISED flag to implement this,
along with the MMF changes.

Patch 2 is a cleanup patch for tva_flags that will allow the forced
collapse case to be transmitted to vma_thp_disabled (which is done in
patch 3).

Patch 4 adds documentation for PR_SET_THP_DISABLE/PR_GET_THP_DISABLE.

Patches 6-7 implement the selftests for PR_SET_THP_DISABLE for completely
disabling THPs (old behaviour) and only enabling it at advise
(PR_THP_DISABLE_EXCEPT_ADVISED).


This patch (of 7):

People want to make use of more THPs, for example, moving from the "never"
system policy to "madvise", or from "madvise" to "always".

While this is great news for every THP desperately waiting to get
allocated out there, apparently there are some workloads that require a
bit of care during that transition: individual processes may need to
opt-out from this behavior for various reasons, and this should be
permitted without needing to make all other workloads on the system
similarly opt-out.

The following scenarios are imaginable:

(1) Switch from "none" system policy to "madvise"/"always", but keep THPs
    disabled for selected workloads.

(2) Stay at "none" system policy, but enable THPs for selected
    workloads, making only these workloads use the "madvise" or "always"
    policy.

(3) Switch from "madvise" system policy to "always", but keep the
    "madvise" policy for selected workloads: allocate THPs only when
    advised.

(4) Stay at "madvise" system policy, but enable THPs even when not advised
    for selected workloads -- "always" policy.

Once can emulate (2) through (1), by setting the system policy to
"madvise"/"always" while disabling THPs for all processes that don't want
THPs.  It requires configuring all workloads, but that is a user-space
problem to sort out.

(4) can be emulated through (3) in a similar way.

Back when (1) was relevant in the past, as people started enabling THPs,
we added PR_SET_THP_DISABLE, so relevant workloads that were not ready yet
(i.e., used by Redis) were able to just disable THPs completely.  Redis
still implements the option to use this interface to disable THPs
completely.

With PR_SET_THP_DISABLE, we added a way to force-disable THPs for a
workload -- a process, including fork+exec'ed process hierarchy.  That
essentially made us support (1): simply disable THPs for all workloads
that are not ready for THPs yet, while still enabling THPs system-wide.

The quest for handling (3) and (4) started, but current approaches
(completely new prctl, options to set other policies per process,
alternatives to prctl -- mctrl, cgroup handling) don't look particularly
promising.  Likely, the future will use bpf or something similar to
implement better policies, in particular to also make better decisions
about THP sizes to use, but this will certainly take a while as that work
just started.

Long story short: a simple enable/disable is not really suitable for the
future, so we're not willing to add completely new toggles.

While we could emulate (3)+(4) through (1)+(2) by simply disabling THPs
completely for these processes, this is a step backwards, because these
processes can no longer allocate THPs in regions where THPs were
explicitly advised: regions flagged as VM_HUGEPAGE.  Apparently, that
imposes a problem for relevant workloads, because "not THPs" is certainly
worse than "THPs only when advised".

Could we simply relax PR_SET_THP_DISABLE, to "disable THPs unless not
explicitly advised by the app through MAD_HUGEPAGE"?  *maybe*, but this
would change the documented semantics quite a bit, and the versatility to
use it for debugging purposes, so I am not 100% sure that is what we want
-- although it would certainly be much easier.

So instead, as an easy way forward for (3) and (4), add an option to
make PR_SET_THP_DISABLE disable *less* THPs for a process.

In essence, this patch:

(A) Adds PR_THP_DISABLE_EXCEPT_ADVISED, to be used as a flag in arg3
    of prctl(PR_SET_THP_DISABLE) when disabling THPs (arg2 != 0).

    prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED).

(B) Makes prctl(PR_GET_THP_DISABLE) return 3 if
    PR_THP_DISABLE_EXCEPT_ADVISED was set while disabling.

    Previously, it would return 1 if THPs were disabled completely. Now
    it returns the set flags as well: 3 if PR_THP_DISABLE_EXCEPT_ADVISED
    was set.

(C) Renames MMF_DISABLE_THP to MMF_DISABLE_THP_COMPLETELY, to express
    the semantics clearly.

    Fortunately, there are only two instances outside of prctl() code.

(D) Adds MMF_DISABLE_THP_EXCEPT_ADVISED to express "no THP except for VMAs
    with VM_HUGEPAGE" -- essentially "thp=madvise" behavior

    Fortunately, we only have to extend vma_thp_disabled().

(E) Indicates "THP_enabled: 0" in /proc/pid/status only if THPs are
    disabled completely

    Only indicating that THPs are disabled when they are really disabled
    completely, not only partially.

    For now, we don't add another interface to obtained whether THPs
    are disabled partially (PR_THP_DISABLE_EXCEPT_ADVISED was set). If
    ever required, we could add a new entry.

The documented semantics in the man page for PR_SET_THP_DISABLE "is
inherited by a child created via fork(2) and is preserved across
execve(2)" is maintained.  This behavior, for example, allows for
disabling THPs for a workload through the launching process (e.g., systemd
where we fork() a helper process to then exec()).

For now, MADV_COLLAPSE will *fail* in regions without VM_HUGEPAGE and
VM_NOHUGEPAGE.  As MADV_COLLAPSE is a clear advise that user space thinks
a THP is a good idea, we'll enable that separately next (requiring a bit
of cleanup first).

There is currently not way to prevent that a process will not issue
PR_SET_THP_DISABLE itself to re-enable THP.  There are not really known
users for re-enabling it, and it's against the purpose of the original
interface.  So if ever required, we could investigate just forbidding to
re-enable them, or make this somehow configurable.

Link: https://lkml.kernel.org/r/20250815135549.130506-1-usamaarif642@gmail.com
Link: https://lkml.kernel.org/r/20250815135549.130506-2-usamaarif642@gmail.com
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Tested-by: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yafang <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    5 +-
 fs/proc/array.c                    |    2 
 include/linux/huge_mm.h            |   20 ++++++---
 include/linux/mm_types.h           |   14 ++----
 include/uapi/linux/prctl.h         |   10 ++++
 kernel/sys.c                       |   59 +++++++++++++++++++++------
 mm/khugepaged.c                    |    2 
 7 files changed, 83 insertions(+), 29 deletions(-)

--- a/Documentation/filesystems/proc.rst~prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage
+++ a/Documentation/filesystems/proc.rst
@@ -291,8 +291,9 @@ It's slow but very precise.
  HugetlbPages                size of hugetlb memory portions
  CoreDumping                 process's memory is currently being dumped
                              (killing the process may lead to a corrupted core)
- THP_enabled		     process is allowed to use THP (returns 0 when
-			     PR_SET_THP_DISABLE is set on the process
+ THP_enabled                 process is allowed to use THP (returns 0 when
+                             PR_SET_THP_DISABLE is set on the process to disable
+                             THP completely, not just partially)
  Threads                     number of threads
  SigQ                        number of signals queued/max. number for queue
  SigPnd                      bitmap of pending signals for the thread
--- a/fs/proc/array.c~prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage
+++ a/fs/proc/array.c
@@ -422,7 +422,7 @@ static inline void task_thp_status(struc
 	bool thp_enabled = IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE);
 
 	if (thp_enabled)
-		thp_enabled = !mm_flags_test(MMF_DISABLE_THP, mm);
+		thp_enabled = !mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 	seq_printf(m, "THP_enabled:\t%d\n", thp_enabled);
 }
 
--- a/include/linux/huge_mm.h~prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage
+++ a/include/linux/huge_mm.h
@@ -318,16 +318,26 @@ struct thpsize {
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
 
+/*
+ * Check whether THPs are explicitly disabled for this VMA, for example,
+ * through madvise or prctl.
+ */
 static inline bool vma_thp_disabled(struct vm_area_struct *vma,
 		vm_flags_t vm_flags)
 {
+	/* Are THPs disabled for this VMA? */
+	if (vm_flags & VM_NOHUGEPAGE)
+		return true;
+	/* Are THPs disabled for all VMAs in the whole process? */
+	if (mm_flags_test(MMF_DISABLE_THP_COMPLETELY, vma->vm_mm))
+		return true;
 	/*
-	 * Explicitly disabled through madvise or prctl, or some
-	 * architectures may disable THP for some mappings, for
-	 * example, s390 kvm.
+	 * Are THPs disabled only for VMAs where we didn't get an explicit
+	 * advise to use them?
 	 */
-	return (vm_flags & VM_NOHUGEPAGE) ||
-	       mm_flags_test(MMF_DISABLE_THP, vma->vm_mm);
+	if (vm_flags & VM_HUGEPAGE)
+		return false;
+	return mm_flags_test(MMF_DISABLE_THP_EXCEPT_ADVISED, vma->vm_mm);
 }
 
 static inline bool thp_disabled_by_hw(void)
--- a/include/linux/mm_types.h~prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage
+++ a/include/linux/mm_types.h
@@ -1780,19 +1780,17 @@ enum {
 #define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
 #define MMF_VM_HUGEPAGE		17	/* set when mm is available for khugepaged */
 
-/*
- * This one-shot flag is dropped due to necessity of changing exe once again
- * on NFS restore
- */
-//#define MMF_EXE_FILE_CHANGED	18	/* see prctl_set_mm_exe_file() */
+#define MMF_HUGE_ZERO_FOLIO	18      /* mm has ever used the global huge zero folio */
 
 #define MMF_HAS_UPROBES		19	/* has uprobes */
 #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
 #define MMF_OOM_SKIP		21	/* mm is of no interest for the OOM killer */
 #define MMF_UNSTABLE		22	/* mm is unstable for copy_from_user */
-#define MMF_HUGE_ZERO_FOLIO	23      /* mm has ever used the global huge zero folio */
-#define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
-#define MMF_DISABLE_THP_MASK	_BITUL(MMF_DISABLE_THP)
+
+#define MMF_DISABLE_THP_EXCEPT_ADVISED	23	/* no THP except when advised (e.g., VM_HUGEPAGE) */
+#define MMF_DISABLE_THP_COMPLETELY	24	/* no THP for all VMAs */
+#define MMF_DISABLE_THP_MASK	(_BITUL(MMF_DISABLE_THP_COMPLETELY) | \
+				 _BITUL(MMF_DISABLE_THP_EXCEPT_ADVISED))
 #define MMF_OOM_REAP_QUEUED	25	/* mm was queued for oom_reaper */
 #define MMF_MULTIPROCESS	26	/* mm is shared between processes */
 /*
--- a/include/uapi/linux/prctl.h~prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage
+++ a/include/uapi/linux/prctl.h
@@ -177,7 +177,17 @@ struct prctl_mm_map {
 
 #define PR_GET_TID_ADDRESS	40
 
+/*
+ * Flags for PR_SET_THP_DISABLE are only applicable when disabling. Bit 0
+ * is reserved, so PR_GET_THP_DISABLE can return "1 | flags", to effectively
+ * return "1" when no flags were specified for PR_SET_THP_DISABLE.
+ */
 #define PR_SET_THP_DISABLE	41
+/*
+ * Don't disable THPs when explicitly advised (e.g., MADV_HUGEPAGE /
+ * VM_HUGEPAGE).
+ */
+# define PR_THP_DISABLE_EXCEPT_ADVISED	(1 << 1)
 #define PR_GET_THP_DISABLE	42
 
 /*
--- a/kernel/sys.c~prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage
+++ a/kernel/sys.c
@@ -2452,6 +2452,51 @@ static int prctl_get_auxv(void __user *a
 	return sizeof(mm->saved_auxv);
 }
 
+static int prctl_get_thp_disable(unsigned long arg2, unsigned long arg3,
+				 unsigned long arg4, unsigned long arg5)
+{
+	struct mm_struct *mm = current->mm;
+
+	if (arg2 || arg3 || arg4 || arg5)
+		return -EINVAL;
+
+	/* If disabled, we return "1 | flags", otherwise 0. */
+	if (mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm))
+		return 1;
+	else if (mm_flags_test(MMF_DISABLE_THP_EXCEPT_ADVISED, mm))
+		return 1 | PR_THP_DISABLE_EXCEPT_ADVISED;
+	return 0;
+}
+
+static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
+				 unsigned long arg4, unsigned long arg5)
+{
+	struct mm_struct *mm = current->mm;
+
+	if (arg4 || arg5)
+		return -EINVAL;
+
+	/* Flags are only allowed when disabling. */
+	if ((!thp_disable && flags) || (flags & ~PR_THP_DISABLE_EXCEPT_ADVISED))
+		return -EINVAL;
+	if (mmap_write_lock_killable(current->mm))
+		return -EINTR;
+	if (thp_disable) {
+		if (flags & PR_THP_DISABLE_EXCEPT_ADVISED) {
+			mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
+			mm_flags_set(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
+		} else {
+			mm_flags_set(MMF_DISABLE_THP_COMPLETELY, mm);
+			mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
+		}
+	} else {
+		mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
+		mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
+	}
+	mmap_write_unlock(current->mm);
+	return 0;
+}
+
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
@@ -2625,20 +2670,10 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			return -EINVAL;
 		return task_no_new_privs(current) ? 1 : 0;
 	case PR_GET_THP_DISABLE:
-		if (arg2 || arg3 || arg4 || arg5)
-			return -EINVAL;
-		error = !!mm_flags_test(MMF_DISABLE_THP, me->mm);
+		error = prctl_get_thp_disable(arg2, arg3, arg4, arg5);
 		break;
 	case PR_SET_THP_DISABLE:
-		if (arg3 || arg4 || arg5)
-			return -EINVAL;
-		if (mmap_write_lock_killable(me->mm))
-			return -EINTR;
-		if (arg2)
-			mm_flags_set(MMF_DISABLE_THP, me->mm);
-		else
-			mm_flags_clear(MMF_DISABLE_THP, me->mm);
-		mmap_write_unlock(me->mm);
+		error = prctl_set_thp_disable(arg2, arg3, arg4, arg5);
 		break;
 	case PR_MPX_ENABLE_MANAGEMENT:
 	case PR_MPX_DISABLE_MANAGEMENT:
--- a/mm/khugepaged.c~prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage
+++ a/mm/khugepaged.c
@@ -410,7 +410,7 @@ static inline int hpage_collapse_test_ex
 static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
 {
 	return hpage_collapse_test_exit(mm) ||
-		mm_flags_test(MMF_DISABLE_THP, mm);
+		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
 static bool hugepage_pmd_enabled(void)
_

Patches currently in -mm which might be from david@redhat.com are

mm-migrate-remove-migratepage_unmap.patch
treewide-remove-migratepage_success.patch
mm-huge_memory-move-more-common-code-into-insert_pmd.patch
mm-huge_memory-move-more-common-code-into-insert_pud.patch
mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch
fs-dax-use-vmf_insert_folio_pmd-to-insert-the-huge-zero-folio.patch
mm-huge_memory-mark-pmd-mappings-of-the-huge-zero-folio-special.patch
powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel.patch
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch
mm-memory-factor-out-common-code-from-vm_normal_page_.patch
mm-introduce-and-use-vm_normal_page_pud.patch
mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page.patch
prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage.patch
mm-huge_memory-convert-tva_flags-to-enum-tva_type.patch
mm-huge_memory-respect-madv_collapse-with-pr_thp_disable_except_advised.patch

