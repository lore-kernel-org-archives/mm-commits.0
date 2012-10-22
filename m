From: akpm@linux-foundation.org
Subject: + procfs-add-vmflags-field-in-smaps-output-v2.patch added to -mm tree
Date: Mon, 22 Oct 2012 14:59:09 -0700
Message-ID: <20121022215910.1A3BE5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:44475 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab2JVV7N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 17:59:13 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so191298lbo.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 14:59:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, a.p.zijlstra@chello.nl, xemul@parallels.com


The patch titled
     Subject: procfs: add VmFlags field in smaps output
has been added to the -mm tree.  Its filename is
     procfs-add-vmflags-field-in-smaps-output-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: procfs: add VmFlags field in smaps output

During c/r sessions we've found that there is no way at the moment to
fetch some VMA associated flags, such as mlock() and madvise().

This leads us to a problem -- we don't know if we should call for mlock()
and/or madvise() after restore on the vma area we're bringing back to
life.

This patch intorduces a new field into "smaps" output called VmFlags,
where all set flags associated with the particular VMA is shown as two
letter mnemonics.

[ Strictly speaking for c/r we only need mlock/madvise bits but it has been
  said that providing just a few flags looks somehow inconsistent.  So all
  flags are here now. ]

This feature is made available on CONFIG_CHECKPOINT_RESTORE=n kernels, as
other applications may start to use these fields.

The data is encoded in a somewhat awkward two letters mnemonic form, to
encourage userspace to be prepared for fields being added or removed in
the future.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   40 ++++++++++++++++++++--
 fs/proc/task_mmu.c                 |   49 +++++++++++++++++++++++++++
 2 files changed, 87 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/proc.txt~procfs-add-vmflags-field-in-smaps-output-v2 Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~procfs-add-vmflags-field-in-smaps-output-v2
+++ a/Documentation/filesystems/proc.txt
@@ -142,7 +142,7 @@ Table 1-1: Process specific entries in /
  pagemap	Page table
  stack		Report full stack trace, enable via CONFIG_STACKTRACE
  smaps		a extension based on maps, showing the memory consumption of
-		each mapping
+		each mapping and flags associated with it
 ..............................................................................
 
 For example, to get the status information of a process, all you have to do is
@@ -415,8 +415,9 @@ Swap:                  0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
 Locked:              374 kB
+VmFlags: rd ex mr mw me de
 
-The first of these lines shows the same information as is displayed for the
+the first of these lines shows the same information as is displayed for the
 mapping in /proc/PID/maps.  The remaining lines show the size of the mapping
 (size), the amount of the mapping that is currently resident in RAM (RSS), the
 process' proportional share of this mapping (PSS), the number of clean and
@@ -430,6 +431,41 @@ and a page is modified, the file page is
 "Swap" shows how much would-be-anonymous memory is also used, but out on
 swap.
 
+"VmFlags" field deserves a separate description. This member represents the kernel
+flags associated with the particular virtual memory area in two letter encoded
+manner. The codes are the following:
+    rd  - readable
+    wr  - writeable
+    ex  - executable
+    sh  - shared
+    mr  - may read
+    mw  - may write
+    me  - may execute
+    ms  - may share
+    gd  - stack segment growns down
+    pf  - pure PFN range
+    dw  - disabled write to the mapped file
+    lo  - pages are locked in memory
+    io  - memory mapped I/O area
+    sr  - sequential read advise provided
+    rr  - random read advise provided
+    dc  - do not copy area on fork
+    de  - do not expand area on remapping
+    ac  - area is accountable
+    nr  - swap space is not reserved for the area
+    ht  - area uses huge tlb pages
+    nl  - non-linear mapping
+    ar  - architecture specific flag
+    dd  - do not include area into core dump
+    mm  - mixed map area
+    hg  - huge page advise flag
+    nh  - no-huge page advise flag
+    mg  - mergable advise flag
+
+Note that there is no guarantee that every flag and associated mnemonic will
+be present in all further kernel releases. Things get changed, the flags may
+be vanished or the reverse -- new added.
+
 This file is only present if the CONFIG_MMU kernel configuration option is
 enabled.
 
diff -puN fs/proc/task_mmu.c~procfs-add-vmflags-field-in-smaps-output-v2 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-add-vmflags-field-in-smaps-output-v2
+++ a/fs/proc/task_mmu.c
@@ -526,6 +526,53 @@ static int smaps_pte_range(pmd_t *pmd, u
 	return 0;
 }
 
+static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
+{
+	/*
+	 * Don't forget to update Documentation/ on changes.
+	 */
+
+#define __seq_show_vmflag(_f, _s)		\
+	do {					\
+		if (vma->vm_flags & (_f))	\
+			seq_puts(m, _s);	\
+	} while (0)
+
+	seq_puts(m, "VmFlags: ");
+
+	__seq_show_vmflag(VM_READ,	"rd ");
+	__seq_show_vmflag(VM_WRITE,	"wr ");
+	__seq_show_vmflag(VM_EXEC,	"ex ");
+	__seq_show_vmflag(VM_SHARED,	"sh ");
+	__seq_show_vmflag(VM_MAYREAD,	"mr ");
+	__seq_show_vmflag(VM_MAYWRITE,	"mw ");
+	__seq_show_vmflag(VM_MAYEXEC,	"me ");
+	__seq_show_vmflag(VM_MAYSHARE,	"ms ");
+	__seq_show_vmflag(VM_GROWSDOWN,	"gd ");
+	__seq_show_vmflag(VM_PFNMAP,	"pf ");
+	__seq_show_vmflag(VM_DENYWRITE,	"dw ");
+	__seq_show_vmflag(VM_LOCKED,	"lo ");
+	__seq_show_vmflag(VM_IO,	"io ");
+	__seq_show_vmflag(VM_SEQ_READ,	"sr ");
+	__seq_show_vmflag(VM_RAND_READ,	"rr ");
+	__seq_show_vmflag(VM_DONTCOPY,	"dc ");
+	__seq_show_vmflag(VM_DONTEXPAND,"de ");
+	__seq_show_vmflag(VM_ACCOUNT,	"ac ");
+	__seq_show_vmflag(VM_NORESERVE,	"nr ");
+	__seq_show_vmflag(VM_HUGETLB,	"ht ");
+	__seq_show_vmflag(VM_NONLINEAR,	"nl ");
+	__seq_show_vmflag(VM_ARCH_1,	"ar ");
+	__seq_show_vmflag(VM_DONTDUMP,	"dd ");
+	__seq_show_vmflag(VM_MIXEDMAP,	"mm ");
+	__seq_show_vmflag(VM_HUGEPAGE,	"hg ");
+	__seq_show_vmflag(VM_NOHUGEPAGE,"nh ");
+	__seq_show_vmflag(VM_MERGEABLE,	"mg ");
+
+	seq_putc(m, '\n');
+
+#undef __seq_show_vmflag
+}
+
 static int show_smap(struct seq_file *m, void *v, int is_pid)
 {
 	struct proc_maps_private *priv = m->private;
@@ -581,6 +628,8 @@ static int show_smap(struct seq_file *m,
 		seq_printf(m, "Nonlinear:      %8lu kB\n",
 				mss.nonlinear >> 10);
 
+	show_smap_vma_flags(m, vma);
+
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task->mm))
 			? vma->vm_start : 0;
_

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
proc-check-vma-vm_file-before-dereferencing.patch
procfs-add-vmflags-field-in-smaps-output-v2.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch

