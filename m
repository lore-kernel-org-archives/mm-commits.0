From: akpm@linux-foundation.org
Subject: - sysctl-s390-move-sysctl-definitions-to-sysctlh.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:29 -0800
Message-ID: <200702150849.l1F8nT0P025132@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40114 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965446AbXBOItf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:49:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: s390: move sysctl definitions to sysctl.h
has been removed from the -mm tree.  Its filename was
     sysctl-s390-move-sysctl-definitions-to-sysctlh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: s390: move sysctl definitions to sysctl.h
From: Eric W. Biederman <ebiederm@xmission.com>

We need to have the the definition of all top level sysctl directories
registers in sysctl.h so we don't conflict by accident and cause abi problems.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/appldata/appldata.h |    3 +--
 arch/s390/kernel/debug.c      |    1 -
 arch/s390/mm/cmm.c            |    4 ----
 include/linux/sysctl.h        |    7 +++++++
 4 files changed, 8 insertions(+), 7 deletions(-)

diff -puN arch/s390/appldata/appldata.h~sysctl-s390-move-sysctl-definitions-to-sysctlh arch/s390/appldata/appldata.h
--- a/arch/s390/appldata/appldata.h~sysctl-s390-move-sysctl-definitions-to-sysctlh
+++ a/arch/s390/appldata/appldata.h
@@ -21,8 +21,7 @@
 #define APPLDATA_RECORD_NET_SUM_ID	0x03	/* must be < 256 !     */
 #define APPLDATA_RECORD_PROC_ID		0x04
 
-#define CTL_APPLDATA 		2120	/* sysctl IDs, must be unique */
-#define CTL_APPLDATA_TIMER 	2121
+#define CTL_APPLDATA_TIMER 	2121	/* sysctl IDs, must be unique */
 #define CTL_APPLDATA_INTERVAL 	2122
 #define CTL_APPLDATA_MEM	2123
 #define CTL_APPLDATA_OS		2124
diff -puN arch/s390/kernel/debug.c~sysctl-s390-move-sysctl-definitions-to-sysctlh arch/s390/kernel/debug.c
--- a/arch/s390/kernel/debug.c~sysctl-s390-move-sysctl-definitions-to-sysctlh
+++ a/arch/s390/kernel/debug.c
@@ -852,7 +852,6 @@ debug_finish_entry(debug_info_t * id, de
 static int debug_stoppable=1;
 static int debug_active=1;
 
-#define CTL_S390DBF 5677
 #define CTL_S390DBF_STOPPABLE 5678
 #define CTL_S390DBF_ACTIVE 5679
 
diff -puN arch/s390/mm/cmm.c~sysctl-s390-move-sysctl-definitions-to-sysctlh arch/s390/mm/cmm.c
--- a/arch/s390/mm/cmm.c~sysctl-s390-move-sysctl-definitions-to-sysctlh
+++ a/arch/s390/mm/cmm.c
@@ -256,10 +256,6 @@ cmm_skip_blanks(char *cp, char **endp)
 }
 
 #ifdef CONFIG_CMM_PROC
-/* These will someday get removed. */
-#define VM_CMM_PAGES		1111
-#define VM_CMM_TIMED_PAGES	1112
-#define VM_CMM_TIMEOUT		1113
 
 static struct ctl_table cmm_table[];
 
diff -puN include/linux/sysctl.h~sysctl-s390-move-sysctl-definitions-to-sysctlh include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-s390-move-sysctl-definitions-to-sysctlh
+++ a/include/linux/sysctl.h
@@ -70,6 +70,8 @@ enum
 	CTL_BUS=8,		/* Busses */
 	CTL_ABI=9,		/* Binary emulation */
 	CTL_CPU=10,		/* CPU stuff (speed scaling, etc) */
+	CTL_APPLDATA=2120,	/* s390 appldata */
+	CTL_S390DBF=5677,	/* s390 debug */
 	CTL_SUNRPC=7249,	/* sunrpc debug */
 	CTL_PM=9899,		/* frv power management */
 	CTL_FRV=9898,		/* frv specific sysctls */
@@ -205,6 +207,11 @@ enum
 	VM_PANIC_ON_OOM=33,	/* panic at out-of-memory */
 	VM_VDSO_ENABLED=34,	/* map VDSO into new processes? */
 	VM_MIN_SLAB=35,		 /* Percent pages ignored by zone reclaim */
+
+	/* s390 vm cmm sysctls */
+	VM_CMM_PAGES=1111,
+	VM_CMM_TIMED_PAGES=1112,
+	VM_CMM_TIMEOUT=1113,
 };
 
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
git-v9fs.patch
x86_64-irq-simplfy-__assign_irq_vector.patch
x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
i386-apic-clean-up-the-apic-code.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
