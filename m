From: akpm@linux-foundation.org
Subject: - sysctl-register-the-ocfs2-sysctl-numbers.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:50:11 -0800
Message-ID: <200702150850.l1F8oBg4025194@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40184 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965494AbXBOIuQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:50:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mark.fasheh@oracle.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: register the ocfs2 sysctl numbers
has been removed from the -mm tree.  Its filename was
     sysctl-register-the-ocfs2-sysctl-numbers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: register the ocfs2 sysctl numbers
From: Eric W. Biederman <ebiederm@xmission.com>

ocfs2 was did not have the binary number it uses under CTL_FS registered in
sysctl.h.  Register it to avoid future conflicts, and change the name of the
definition to be in line with the rest of the sysctl numbers.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/nodemanager.c |    4 ++--
 fs/ocfs2/cluster/nodemanager.h |    3 +--
 include/linux/sysctl.h         |    1 +
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/cluster/nodemanager.c~sysctl-register-the-ocfs2-sysctl-numbers fs/ocfs2/cluster/nodemanager.c
--- a/fs/ocfs2/cluster/nodemanager.c~sysctl-register-the-ocfs2-sysctl-numbers
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -55,7 +55,7 @@ static ctl_table ocfs2_nm_table[] = {
 
 static ctl_table ocfs2_mod_table[] = {
 	{
-		.ctl_name	= KERN_OCFS2_NM,
+		.ctl_name	= FS_OCFS2_NM,
 		.procname	= "nm",
 		.data		= NULL,
 		.maxlen		= 0,
@@ -67,7 +67,7 @@ static ctl_table ocfs2_mod_table[] = {
 
 static ctl_table ocfs2_kern_table[] = {
 	{
-		.ctl_name	= KERN_OCFS2,
+		.ctl_name	= FS_OCFS2,
 		.procname	= "ocfs2",
 		.data		= NULL,
 		.maxlen		= 0,
diff -puN fs/ocfs2/cluster/nodemanager.h~sysctl-register-the-ocfs2-sysctl-numbers fs/ocfs2/cluster/nodemanager.h
--- a/fs/ocfs2/cluster/nodemanager.h~sysctl-register-the-ocfs2-sysctl-numbers
+++ a/fs/ocfs2/cluster/nodemanager.h
@@ -33,8 +33,7 @@
 #include <linux/configfs.h>
 #include <linux/rbtree.h>
 
-#define KERN_OCFS2		988
-#define KERN_OCFS2_NM		1
+#define FS_OCFS2_NM		1
 
 const char *o2nm_get_hb_ctl_path(void);
 
diff -puN include/linux/sysctl.h~sysctl-register-the-ocfs2-sysctl-numbers include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-register-the-ocfs2-sysctl-numbers
+++ a/include/linux/sysctl.h
@@ -814,6 +814,7 @@ enum
 	FS_AIO_NR=18,	/* current system-wide number of aio requests */
 	FS_AIO_MAX_NR=19,	/* system-wide maximum number of aio requests */
 	FS_INOTIFY=20,	/* inotify submenu */
+	FS_OCFS2=988,	/* ocfs2 */
 };
 
 /* /proc/sys/fs/quota/ */
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
