From: akpm@linux-foundation.org
Subject: [to-be-updated] procfs-add-vmflags-field-in-smaps-output.patch removed from -mm tree
Date: Mon, 22 Oct 2012 14:58:22 -0700
Message-ID: <20121022215824.84B5D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:59620 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab2JVV61 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 17:58:27 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so172650wib.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 14:58:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, a.p.zijlstra@chello.nl, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: add VmFlags field in smaps output
has been removed from the -mm tree.  Its filename was
     procfs-add-vmflags-field-in-smaps-output.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: procfs: add VmFlags field in smaps output

During c/r sessions we've found that there is no way at the moment to
fetch some VMA associated flags, such as mlock() and madvise(), thus the
patches in this series intorduce new field into "smaps" output called
VmFlags where all flags associated with the particular VMA is shown in two
letter mnemonic.

Strictly speaking for c/r we only need mlock/madvise bits but it has been
said that providing just a few flags looks somehow inconsistent.  So all
flags are here now.

When we restore a VMA after checkpoint we would like to know if the area
was locked or say it had mergeable attribute, but at moment the kernel
does not provide such information, thus we can't figure out if we should
call mlock/madvise on VMA restore.

This patch adds new VmFlags field to smaps output with vma->vm_flags
encoded.

This feature is made available on CONFIG_CHECKPOINT_RESTORE=n kernels, as
other applications may start to use these fields.

The data is encoded in a somewhat awkward name:value form, to encourage
userspace to be prepared for fields being added or removed in the future.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   38 ++++++++++++++++++++++++++-
 fs/proc/task_mmu.c                 |   32 ++++++++++++++++++++++
 2 files changed, 69 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~procfs-add-vmflags-field-in-smaps-output fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-add-vmflags-field-in-smaps-output
+++ a/fs/proc/task_mmu.c
@@ -526,6 +526,36 @@ static int smaps_pte_range(pmd_t *pmd, u
 	return 0;
 }
 
+static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
+{
+	/*
+	 * Don't forget to update Documentation/ on changes.
+	 */
+#define __VM_FLAG(_f) (!!(vma->vm_flags & (_f)))
+	seq_printf(m, "VmFlags: "
+		   "RD:%d WR:%d EX:%d SH:%d MR:%d "
+		   "MW:%d ME:%d MS:%d GD:%d PF:%d "
+		   "DW:%d LO:%d IO:%d SR:%d RR:%d "
+		   "DC:%d DE:%d AC:%d NR:%d HT:%d "
+		   "NL:%d AR:%d DD:%d MM:%d HG:%d "
+		   "NH:%d MG:%d\n",
+		   __VM_FLAG(VM_READ),		__VM_FLAG(VM_WRITE),
+		   __VM_FLAG(VM_EXEC),		__VM_FLAG(VM_SHARED),
+		   __VM_FLAG(VM_MAYREAD),	__VM_FLAG(VM_MAYWRITE),
+		   __VM_FLAG(VM_MAYEXEC),	__VM_FLAG(VM_MAYSHARE),
+		   __VM_FLAG(VM_GROWSDOWN),	__VM_FLAG(VM_PFNMAP),
+		   __VM_FLAG(VM_DENYWRITE),	__VM_FLAG(VM_LOCKED),
+		   __VM_FLAG(VM_IO),		__VM_FLAG(VM_SEQ_READ),
+		   __VM_FLAG(VM_RAND_READ),	__VM_FLAG(VM_DONTCOPY),
+		   __VM_FLAG(VM_DONTEXPAND),	__VM_FLAG(VM_ACCOUNT),
+		   __VM_FLAG(VM_NORESERVE),	__VM_FLAG(VM_HUGETLB),
+		   __VM_FLAG(VM_NONLINEAR),	__VM_FLAG(VM_ARCH_1),
+		   __VM_FLAG(VM_DONTDUMP),	__VM_FLAG(VM_MIXEDMAP),
+		   __VM_FLAG(VM_HUGEPAGE),	__VM_FLAG(VM_NOHUGEPAGE),
+		   __VM_FLAG(VM_MERGEABLE));
+#undef __VM_FLAG
+}
+
 static int show_smap(struct seq_file *m, void *v, int is_pid)
 {
 	struct proc_maps_private *priv = m->private;
@@ -581,6 +611,8 @@ static int show_smap(struct seq_file *m,
 		seq_printf(m, "Nonlinear:      %8lu kB\n",
 				mss.nonlinear >> 10);
 
+	show_smap_vma_flags(m, vma);
+
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task->mm))
 			? vma->vm_start : 0;
diff -puN Documentation/filesystems/proc.txt~procfs-add-vmflags-field-in-smaps-output Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~procfs-add-vmflags-field-in-smaps-output
+++ a/Documentation/filesystems/proc.txt
@@ -142,7 +142,7 @@ Table 1-1: Process specific entries in /
  pagemap	Page table
  stack		Report full stack trace, enable via CONFIG_STACKTRACE
  smaps		a extension based on maps, showing the memory consumption of
-		each mapping
+		each mapping and flags associated with it
 ..............................................................................
 
 For example, to get the status information of a process, all you have to do is
@@ -415,6 +415,7 @@ Swap:                  0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
 Locked:              374 kB
+VmFlags: RD:1 WR:0 EX:1 SH:0 MR:1 MW:1 ME:1 MS:0 GD:0 PF:0 DW:1 LO:0 IO:0 SR:0 RR:0 DC:0 DE:0 AC:0 NR:0 HT:0 NL:0 AR:0 DD:0 MM:0 HG:0 NH:0 MG:0
 
 The first of these lines shows the same information as is displayed for the
 mapping in /proc/PID/maps.  The remaining lines show the size of the mapping
@@ -430,6 +431,41 @@ and a page is modified, the file page is
 "Swap" shows how much would-be-anonymous memory is also used, but out on
 swap.
 
+"VmFlags" field deserves a separate description. This member represents the kernel
+flags associated with the particular virtual memory area in two letter encoded
+manner. The codes are the following:
+    RD  - readable
+    WR  - writeable
+    EX  - executable
+    SH  - shared
+    MR  - may read
+    MW  - may write
+    ME  - may execute
+    MS  - may share
+    GD  - stack segment growns down
+    PF  - pure PFN range
+    DW  - disabled write to the mapped file
+    LO  - pages are locked in memory
+    IO  - memory mapped I/O area
+    SR  - sequential read advise provided
+    RR  - random read advise provided
+    DC  - do not copy area on fork
+    DE  - do not expand area on remapping
+    AC  - area is accountable
+    NR  - swap space is not reserved for the area
+    HT  - area uses huge tlb pages
+    NL  - non-linear mapping
+    AR  - architecture specific flag
+    DD  - do not include area into core dump
+    MM  - mixed map area
+    HG  - huge page advise flag
+    NH  - no-huge page advise flag
+    MG  - mergable advise flag
+
+Note that there is no guarantee that every flag and associated mnemonic will
+be present in all further kernel releases. Things get changed, the flags may
+be vanished or the reverse -- new added.
+
 This file is only present if the CONFIG_MMU kernel configuration option is
 enabled.
 
_

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
proc-check-vma-vm_file-before-dereferencing.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch

