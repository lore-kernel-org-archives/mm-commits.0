From: akpm@linux-foundation.org
Subject: + seq_file-constify-seq_operations.patch added to -mm tree
Date: Tue, 11 Aug 2009 16:09:44 -0700
Message-ID: <200908112309.n7BN9kDs028240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754292AbZHKXKh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 19:10:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmorris@namei.org, serue@us.ibm.com


The patch titled
     seq_file: constify seq_operations
has been added to the -mm tree.  Its filename is
     seq_file-constify-seq_operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: seq_file: constify seq_operations
From: James Morris <jmorris@namei.org>

Make all seq_operations structs const, to help mitigate against
revectoring user-triggerable function pointers.

This is derived from the grsecurity patch, although generated from scratch
because it's simpler than extracting the changes from there.

Signed-off-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/setup.c                  |    2 +-
 arch/powerpc/kernel/setup-common.c           |    2 +-
 arch/powerpc/platforms/pseries/hvCall_inst.c |    2 +-
 arch/x86/mm/pat.c                            |    2 +-
 drivers/block/cciss.c                        |    2 +-
 drivers/char/misc.c                          |    2 +-
 drivers/char/tpm/tpm_bios.c                  |    4 ++--
 drivers/isdn/capi/kcapi_proc.c               |   10 +++++-----
 drivers/scsi/sg.c                            |    6 +++---
 drivers/staging/rtl8192e/ieee80211/proc.c    |    2 +-
 fs/afs/proc.c                                |    8 ++++----
 fs/dlm/debug_fs.c                            |   12 ++++++------
 fs/ext4/mballoc.c                            |    4 ++--
 fs/jbd2/journal.c                            |    4 ++--
 fs/nfs/client.c                              |    4 ++--
 fs/nfsd/export.c                             |    2 +-
 fs/ocfs2/cluster/netdebug.c                  |    4 ++--
 fs/ocfs2/dlm/dlmdebug.c                      |    2 +-
 fs/proc/nommu.c                              |    2 +-
 include/linux/nfsd/nfsd.h                    |    2 +-
 ipc/util.c                                   |    2 +-
 kernel/cgroup.c                              |    2 +-
 kernel/kprobes.c                             |    2 +-
 kernel/lockdep_proc.c                        |    2 +-
 kernel/trace/ftrace.c                        |    4 ++--
 kernel/trace/trace.c                         |    4 ++--
 net/ipv6/ip6mr.c                             |    4 ++--
 net/key/af_key.c                             |    2 +-
 security/integrity/ima/ima_fs.c              |    4 ++--
 security/smack/smackfs.c                     |    6 +++---
 30 files changed, 55 insertions(+), 55 deletions(-)

diff -puN arch/mn10300/kernel/setup.c~seq_file-constify-seq_operations arch/mn10300/kernel/setup.c
--- a/arch/mn10300/kernel/setup.c~seq_file-constify-seq_operations
+++ a/arch/mn10300/kernel/setup.c
@@ -285,7 +285,7 @@ static void c_stop(struct seq_file *m, v
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start	= c_start,
 	.next	= c_next,
 	.stop	= c_stop,
diff -puN arch/powerpc/kernel/setup-common.c~seq_file-constify-seq_operations arch/powerpc/kernel/setup-common.c
--- a/arch/powerpc/kernel/setup-common.c~seq_file-constify-seq_operations
+++ a/arch/powerpc/kernel/setup-common.c
@@ -328,7 +328,7 @@ static void c_stop(struct seq_file *m, v
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start =c_start,
 	.next =	c_next,
 	.stop =	c_stop,
diff -puN arch/powerpc/platforms/pseries/hvCall_inst.c~seq_file-constify-seq_operations arch/powerpc/platforms/pseries/hvCall_inst.c
--- a/arch/powerpc/platforms/pseries/hvCall_inst.c~seq_file-constify-seq_operations
+++ a/arch/powerpc/platforms/pseries/hvCall_inst.c
@@ -71,7 +71,7 @@ static int hc_show(struct seq_file *m, v
 	return 0;
 }
 
-static struct seq_operations hcall_inst_seq_ops = {
+static const struct seq_operations hcall_inst_seq_ops = {
         .start = hc_start,
         .next  = hc_next,
         .stop  = hc_stop,
diff -puN arch/x86/mm/pat.c~seq_file-constify-seq_operations arch/x86/mm/pat.c
--- a/arch/x86/mm/pat.c~seq_file-constify-seq_operations
+++ a/arch/x86/mm/pat.c
@@ -826,7 +826,7 @@ static int memtype_seq_show(struct seq_f
 	return 0;
 }
 
-static struct seq_operations memtype_seq_ops = {
+static const struct seq_operations memtype_seq_ops = {
 	.start = memtype_seq_start,
 	.next  = memtype_seq_next,
 	.stop  = memtype_seq_stop,
diff -puN drivers/block/cciss.c~seq_file-constify-seq_operations drivers/block/cciss.c
--- a/drivers/block/cciss.c~seq_file-constify-seq_operations
+++ a/drivers/block/cciss.c
@@ -369,7 +369,7 @@ static void cciss_seq_stop(struct seq_fi
 	h->busy_configuring = 0;
 }
 
-static struct seq_operations cciss_seq_ops = {
+static const struct seq_operations cciss_seq_ops = {
 	.start = cciss_seq_start,
 	.show  = cciss_seq_show,
 	.next  = cciss_seq_next,
diff -puN drivers/char/misc.c~seq_file-constify-seq_operations drivers/char/misc.c
--- a/drivers/char/misc.c~seq_file-constify-seq_operations
+++ a/drivers/char/misc.c
@@ -91,7 +91,7 @@ static int misc_seq_show(struct seq_file
 }
 
 
-static struct seq_operations misc_seq_ops = {
+static const struct seq_operations misc_seq_ops = {
 	.start = misc_seq_start,
 	.next  = misc_seq_next,
 	.stop  = misc_seq_stop,
diff -puN drivers/char/tpm/tpm_bios.c~seq_file-constify-seq_operations drivers/char/tpm/tpm_bios.c
--- a/drivers/char/tpm/tpm_bios.c~seq_file-constify-seq_operations
+++ a/drivers/char/tpm/tpm_bios.c
@@ -343,14 +343,14 @@ static int tpm_ascii_bios_measurements_s
 	return 0;
 }
 
-static struct seq_operations tpm_ascii_b_measurments_seqops = {
+static const struct seq_operations tpm_ascii_b_measurments_seqops = {
 	.start = tpm_bios_measurements_start,
 	.next = tpm_bios_measurements_next,
 	.stop = tpm_bios_measurements_stop,
 	.show = tpm_ascii_bios_measurements_show,
 };
 
-static struct seq_operations tpm_binary_b_measurments_seqops = {
+static const struct seq_operations tpm_binary_b_measurments_seqops = {
 	.start = tpm_bios_measurements_start,
 	.next = tpm_bios_measurements_next,
 	.stop = tpm_bios_measurements_stop,
diff -puN drivers/isdn/capi/kcapi_proc.c~seq_file-constify-seq_operations drivers/isdn/capi/kcapi_proc.c
--- a/drivers/isdn/capi/kcapi_proc.c~seq_file-constify-seq_operations
+++ a/drivers/isdn/capi/kcapi_proc.c
@@ -89,14 +89,14 @@ static int contrstats_show(struct seq_fi
 	return 0;
 }
 
-static struct seq_operations seq_controller_ops = {
+static const struct seq_operations seq_controller_ops = {
 	.start	= controller_start,
 	.next	= controller_next,
 	.stop	= controller_stop,
 	.show	= controller_show,
 };
 
-static struct seq_operations seq_contrstats_ops = {
+static const struct seq_operations seq_contrstats_ops = {
 	.start	= controller_start,
 	.next	= controller_next,
 	.stop	= controller_stop,
@@ -194,14 +194,14 @@ applstats_show(struct seq_file *seq, voi
 	return 0;
 }
 
-static struct seq_operations seq_applications_ops = {
+static const struct seq_operations seq_applications_ops = {
 	.start	= applications_start,
 	.next	= applications_next,
 	.stop	= applications_stop,
 	.show	= applications_show,
 };
 
-static struct seq_operations seq_applstats_ops = {
+static const struct seq_operations seq_applstats_ops = {
 	.start	= applications_start,
 	.next	= applications_next,
 	.stop	= applications_stop,
@@ -264,7 +264,7 @@ static int capi_driver_show(struct seq_f
 	return 0;
 }
 
-static struct seq_operations seq_capi_driver_ops = {
+static const struct seq_operations seq_capi_driver_ops = {
 	.start	= capi_driver_start,
 	.next	= capi_driver_next,
 	.stop	= capi_driver_stop,
diff -puN drivers/scsi/sg.c~seq_file-constify-seq_operations drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~seq_file-constify-seq_operations
+++ a/drivers/scsi/sg.c
@@ -2233,7 +2233,7 @@ static struct file_operations dev_fops =
 	.open = sg_proc_open_dev,
 	.release = seq_release,
 };
-static struct seq_operations dev_seq_ops = {
+static const struct seq_operations dev_seq_ops = {
 	.start = dev_seq_start,
 	.next  = dev_seq_next,
 	.stop  = dev_seq_stop,
@@ -2246,7 +2246,7 @@ static struct file_operations devstrs_fo
 	.open = sg_proc_open_devstrs,
 	.release = seq_release,
 };
-static struct seq_operations devstrs_seq_ops = {
+static const struct seq_operations devstrs_seq_ops = {
 	.start = dev_seq_start,
 	.next  = dev_seq_next,
 	.stop  = dev_seq_stop,
@@ -2259,7 +2259,7 @@ static struct file_operations debug_fops
 	.open = sg_proc_open_debug,
 	.release = seq_release,
 };
-static struct seq_operations debug_seq_ops = {
+static const struct seq_operations debug_seq_ops = {
 	.start = dev_seq_start,
 	.next  = dev_seq_next,
 	.stop  = dev_seq_stop,
diff -puN /dev/null /dev/null
diff -puN fs/afs/proc.c~seq_file-constify-seq_operations fs/afs/proc.c
--- a/fs/afs/proc.c~seq_file-constify-seq_operations
+++ a/fs/afs/proc.c
@@ -28,7 +28,7 @@ static int afs_proc_cells_show(struct se
 static ssize_t afs_proc_cells_write(struct file *file, const char __user *buf,
 				    size_t size, loff_t *_pos);
 
-static struct seq_operations afs_proc_cells_ops = {
+static const struct seq_operations afs_proc_cells_ops = {
 	.start	= afs_proc_cells_start,
 	.next	= afs_proc_cells_next,
 	.stop	= afs_proc_cells_stop,
@@ -70,7 +70,7 @@ static void *afs_proc_cell_volumes_next(
 static void afs_proc_cell_volumes_stop(struct seq_file *p, void *v);
 static int afs_proc_cell_volumes_show(struct seq_file *m, void *v);
 
-static struct seq_operations afs_proc_cell_volumes_ops = {
+static const struct seq_operations afs_proc_cell_volumes_ops = {
 	.start	= afs_proc_cell_volumes_start,
 	.next	= afs_proc_cell_volumes_next,
 	.stop	= afs_proc_cell_volumes_stop,
@@ -95,7 +95,7 @@ static void *afs_proc_cell_vlservers_nex
 static void afs_proc_cell_vlservers_stop(struct seq_file *p, void *v);
 static int afs_proc_cell_vlservers_show(struct seq_file *m, void *v);
 
-static struct seq_operations afs_proc_cell_vlservers_ops = {
+static const struct seq_operations afs_proc_cell_vlservers_ops = {
 	.start	= afs_proc_cell_vlservers_start,
 	.next	= afs_proc_cell_vlservers_next,
 	.stop	= afs_proc_cell_vlservers_stop,
@@ -119,7 +119,7 @@ static void *afs_proc_cell_servers_next(
 static void afs_proc_cell_servers_stop(struct seq_file *p, void *v);
 static int afs_proc_cell_servers_show(struct seq_file *m, void *v);
 
-static struct seq_operations afs_proc_cell_servers_ops = {
+static const struct seq_operations afs_proc_cell_servers_ops = {
 	.start	= afs_proc_cell_servers_start,
 	.next	= afs_proc_cell_servers_next,
 	.stop	= afs_proc_cell_servers_stop,
diff -puN fs/dlm/debug_fs.c~seq_file-constify-seq_operations fs/dlm/debug_fs.c
--- a/fs/dlm/debug_fs.c~seq_file-constify-seq_operations
+++ a/fs/dlm/debug_fs.c
@@ -386,9 +386,9 @@ static int table_seq_show(struct seq_fil
 	return rv;
 }
 
-static struct seq_operations format1_seq_ops;
-static struct seq_operations format2_seq_ops;
-static struct seq_operations format3_seq_ops;
+static const struct seq_operations format1_seq_ops;
+static const struct seq_operations format2_seq_ops;
+static const struct seq_operations format3_seq_ops;
 
 static void *table_seq_start(struct seq_file *seq, loff_t *pos)
 {
@@ -534,21 +534,21 @@ static void table_seq_stop(struct seq_fi
 	}
 }
 
-static struct seq_operations format1_seq_ops = {
+static const struct seq_operations format1_seq_ops = {
 	.start = table_seq_start,
 	.next  = table_seq_next,
 	.stop  = table_seq_stop,
 	.show  = table_seq_show,
 };
 
-static struct seq_operations format2_seq_ops = {
+static const struct seq_operations format2_seq_ops = {
 	.start = table_seq_start,
 	.next  = table_seq_next,
 	.stop  = table_seq_stop,
 	.show  = table_seq_show,
 };
 
-static struct seq_operations format3_seq_ops = {
+static const struct seq_operations format3_seq_ops = {
 	.start = table_seq_start,
 	.next  = table_seq_next,
 	.stop  = table_seq_stop,
diff -puN fs/ext4/mballoc.c~seq_file-constify-seq_operations fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~seq_file-constify-seq_operations
+++ a/fs/ext4/mballoc.c
@@ -2205,7 +2205,7 @@ static void ext4_mb_seq_history_stop(str
 {
 }
 
-static struct seq_operations ext4_mb_seq_history_ops = {
+static const struct seq_operations ext4_mb_seq_history_ops = {
 	.start  = ext4_mb_seq_history_start,
 	.next   = ext4_mb_seq_history_next,
 	.stop   = ext4_mb_seq_history_stop,
@@ -2366,7 +2366,7 @@ static void ext4_mb_seq_groups_stop(stru
 {
 }
 
-static struct seq_operations ext4_mb_seq_groups_ops = {
+static const struct seq_operations ext4_mb_seq_groups_ops = {
 	.start  = ext4_mb_seq_groups_start,
 	.next   = ext4_mb_seq_groups_next,
 	.stop   = ext4_mb_seq_groups_stop,
diff -puN fs/jbd2/journal.c~seq_file-constify-seq_operations fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~seq_file-constify-seq_operations
+++ a/fs/jbd2/journal.c
@@ -768,7 +768,7 @@ static void jbd2_seq_history_stop(struct
 {
 }
 
-static struct seq_operations jbd2_seq_history_ops = {
+static const struct seq_operations jbd2_seq_history_ops = {
 	.start  = jbd2_seq_history_start,
 	.next   = jbd2_seq_history_next,
 	.stop   = jbd2_seq_history_stop,
@@ -872,7 +872,7 @@ static void jbd2_seq_info_stop(struct se
 {
 }
 
-static struct seq_operations jbd2_seq_info_ops = {
+static const struct seq_operations jbd2_seq_info_ops = {
 	.start  = jbd2_seq_info_start,
 	.next   = jbd2_seq_info_next,
 	.stop   = jbd2_seq_info_stop,
diff -puN fs/nfs/client.c~seq_file-constify-seq_operations fs/nfs/client.c
--- a/fs/nfs/client.c~seq_file-constify-seq_operations
+++ a/fs/nfs/client.c
@@ -1529,7 +1529,7 @@ static void *nfs_server_list_next(struct
 static void nfs_server_list_stop(struct seq_file *p, void *v);
 static int nfs_server_list_show(struct seq_file *m, void *v);
 
-static struct seq_operations nfs_server_list_ops = {
+static const struct seq_operations nfs_server_list_ops = {
 	.start	= nfs_server_list_start,
 	.next	= nfs_server_list_next,
 	.stop	= nfs_server_list_stop,
@@ -1550,7 +1550,7 @@ static void *nfs_volume_list_next(struct
 static void nfs_volume_list_stop(struct seq_file *p, void *v);
 static int nfs_volume_list_show(struct seq_file *m, void *v);
 
-static struct seq_operations nfs_volume_list_ops = {
+static const struct seq_operations nfs_volume_list_ops = {
 	.start	= nfs_volume_list_start,
 	.next	= nfs_volume_list_next,
 	.stop	= nfs_volume_list_stop,
diff -puN fs/nfsd/export.c~seq_file-constify-seq_operations fs/nfsd/export.c
--- a/fs/nfsd/export.c~seq_file-constify-seq_operations
+++ a/fs/nfsd/export.c
@@ -1515,7 +1515,7 @@ static int e_show(struct seq_file *m, vo
 	return svc_export_show(m, &svc_export_cache, cp);
 }
 
-struct seq_operations nfs_exports_op = {
+const struct seq_operations nfs_exports_op = {
 	.start	= e_start,
 	.next	= e_next,
 	.stop	= e_stop,
diff -puN fs/ocfs2/cluster/netdebug.c~seq_file-constify-seq_operations fs/ocfs2/cluster/netdebug.c
--- a/fs/ocfs2/cluster/netdebug.c~seq_file-constify-seq_operations
+++ a/fs/ocfs2/cluster/netdebug.c
@@ -163,7 +163,7 @@ static void nst_seq_stop(struct seq_file
 {
 }
 
-static struct seq_operations nst_seq_ops = {
+static const struct seq_operations nst_seq_ops = {
 	.start = nst_seq_start,
 	.next = nst_seq_next,
 	.stop = nst_seq_stop,
@@ -344,7 +344,7 @@ static void sc_seq_stop(struct seq_file 
 {
 }
 
-static struct seq_operations sc_seq_ops = {
+static const struct seq_operations sc_seq_ops = {
 	.start = sc_seq_start,
 	.next = sc_seq_next,
 	.stop = sc_seq_stop,
diff -puN fs/ocfs2/dlm/dlmdebug.c~seq_file-constify-seq_operations fs/ocfs2/dlm/dlmdebug.c
--- a/fs/ocfs2/dlm/dlmdebug.c~seq_file-constify-seq_operations
+++ a/fs/ocfs2/dlm/dlmdebug.c
@@ -683,7 +683,7 @@ static int lockres_seq_show(struct seq_f
 	return 0;
 }
 
-static struct seq_operations debug_lockres_ops = {
+static const struct seq_operations debug_lockres_ops = {
 	.start =	lockres_seq_start,
 	.stop =		lockres_seq_stop,
 	.next =		lockres_seq_next,
diff -puN fs/proc/nommu.c~seq_file-constify-seq_operations fs/proc/nommu.c
--- a/fs/proc/nommu.c~seq_file-constify-seq_operations
+++ a/fs/proc/nommu.c
@@ -109,7 +109,7 @@ static void *nommu_region_list_next(stru
 	return rb_next((struct rb_node *) v);
 }
 
-static struct seq_operations proc_nommu_region_list_seqop = {
+static const struct seq_operations proc_nommu_region_list_seqop = {
 	.start	= nommu_region_list_start,
 	.next	= nommu_region_list_next,
 	.stop	= nommu_region_list_stop,
diff -puN include/linux/nfsd/nfsd.h~seq_file-constify-seq_operations include/linux/nfsd/nfsd.h
--- a/include/linux/nfsd/nfsd.h~seq_file-constify-seq_operations
+++ a/include/linux/nfsd/nfsd.h
@@ -60,7 +60,7 @@ extern spinlock_t		nfsd_drc_lock;
 extern unsigned int		nfsd_drc_max_mem;
 extern unsigned int		nfsd_drc_mem_used;
 
-extern struct seq_operations nfs_exports_op;
+extern const struct seq_operations nfs_exports_op;
 
 /*
  * Function prototypes.
diff -puN ipc/util.c~seq_file-constify-seq_operations ipc/util.c
--- a/ipc/util.c~seq_file-constify-seq_operations
+++ a/ipc/util.c
@@ -942,7 +942,7 @@ static int sysvipc_proc_show(struct seq_
 	return iface->show(s, it);
 }
 
-static struct seq_operations sysvipc_proc_seqops = {
+static const struct seq_operations sysvipc_proc_seqops = {
 	.start = sysvipc_proc_start,
 	.stop  = sysvipc_proc_stop,
 	.next  = sysvipc_proc_next,
diff -puN kernel/cgroup.c~seq_file-constify-seq_operations kernel/cgroup.c
--- a/kernel/cgroup.c~seq_file-constify-seq_operations
+++ a/kernel/cgroup.c
@@ -2314,7 +2314,7 @@ static int cgroup_tasks_show(struct seq_
 	return seq_printf(s, "%d\n", *(int *)v);
 }
 
-static struct seq_operations cgroup_tasks_seq_operations = {
+static const struct seq_operations cgroup_tasks_seq_operations = {
 	.start = cgroup_tasks_start,
 	.stop = cgroup_tasks_stop,
 	.next = cgroup_tasks_next,
diff -puN kernel/kprobes.c~seq_file-constify-seq_operations kernel/kprobes.c
--- a/kernel/kprobes.c~seq_file-constify-seq_operations
+++ a/kernel/kprobes.c
@@ -1321,7 +1321,7 @@ static int __kprobes show_kprobe_addr(st
 	return 0;
 }
 
-static struct seq_operations kprobes_seq_ops = {
+static const struct seq_operations kprobes_seq_ops = {
 	.start = kprobe_seq_start,
 	.next  = kprobe_seq_next,
 	.stop  = kprobe_seq_stop,
diff -puN kernel/lockdep_proc.c~seq_file-constify-seq_operations kernel/lockdep_proc.c
--- a/kernel/lockdep_proc.c~seq_file-constify-seq_operations
+++ a/kernel/lockdep_proc.c
@@ -674,7 +674,7 @@ static int ls_show(struct seq_file *m, v
 	return 0;
 }
 
-static struct seq_operations lockstat_ops = {
+static const struct seq_operations lockstat_ops = {
 	.start	= ls_start,
 	.next	= ls_next,
 	.stop	= ls_stop,
diff -puN kernel/trace/ftrace.c~seq_file-constify-seq_operations kernel/trace/ftrace.c
--- a/kernel/trace/ftrace.c~seq_file-constify-seq_operations
+++ a/kernel/trace/ftrace.c
@@ -1522,7 +1522,7 @@ static int t_show(struct seq_file *m, vo
 	return 0;
 }
 
-static struct seq_operations show_ftrace_seq_ops = {
+static const struct seq_operations show_ftrace_seq_ops = {
 	.start = t_start,
 	.next = t_next,
 	.stop = t_stop,
@@ -2510,7 +2510,7 @@ static int g_show(struct seq_file *m, vo
 	return 0;
 }
 
-static struct seq_operations ftrace_graph_seq_ops = {
+static const struct seq_operations ftrace_graph_seq_ops = {
 	.start = g_start,
 	.next = g_next,
 	.stop = g_stop,
diff -puN kernel/trace/trace.c~seq_file-constify-seq_operations kernel/trace/trace.c
--- a/kernel/trace/trace.c~seq_file-constify-seq_operations
+++ a/kernel/trace/trace.c
@@ -1711,7 +1711,7 @@ static int s_show(struct seq_file *m, vo
 	return 0;
 }
 
-static struct seq_operations tracer_seq_ops = {
+static const struct seq_operations tracer_seq_ops = {
 	.start		= s_start,
 	.next		= s_next,
 	.stop		= s_stop,
@@ -1921,7 +1921,7 @@ static int t_show(struct seq_file *m, vo
 	return 0;
 }
 
-static struct seq_operations show_traces_seq_ops = {
+static const struct seq_operations show_traces_seq_ops = {
 	.start		= t_start,
 	.next		= t_next,
 	.stop		= t_stop,
diff -puN net/ipv6/ip6mr.c~seq_file-constify-seq_operations net/ipv6/ip6mr.c
--- a/net/ipv6/ip6mr.c~seq_file-constify-seq_operations
+++ a/net/ipv6/ip6mr.c
@@ -204,7 +204,7 @@ static int ip6mr_vif_seq_show(struct seq
 	return 0;
 }
 
-static struct seq_operations ip6mr_vif_seq_ops = {
+static const struct seq_operations ip6mr_vif_seq_ops = {
 	.start = ip6mr_vif_seq_start,
 	.next  = ip6mr_vif_seq_next,
 	.stop  = ip6mr_vif_seq_stop,
@@ -328,7 +328,7 @@ static int ipmr_mfc_seq_show(struct seq_
 	return 0;
 }
 
-static struct seq_operations ipmr_mfc_seq_ops = {
+static const struct seq_operations ipmr_mfc_seq_ops = {
 	.start = ipmr_mfc_seq_start,
 	.next  = ipmr_mfc_seq_next,
 	.stop  = ipmr_mfc_seq_stop,
diff -puN net/key/af_key.c~seq_file-constify-seq_operations net/key/af_key.c
--- a/net/key/af_key.c~seq_file-constify-seq_operations
+++ a/net/key/af_key.c
@@ -3705,7 +3705,7 @@ static void pfkey_seq_stop(struct seq_fi
 	read_unlock(&pfkey_table_lock);
 }
 
-static struct seq_operations pfkey_seq_ops = {
+static const struct seq_operations pfkey_seq_ops = {
 	.start	= pfkey_seq_start,
 	.next	= pfkey_seq_next,
 	.stop	= pfkey_seq_stop,
diff -puN security/integrity/ima/ima_fs.c~seq_file-constify-seq_operations security/integrity/ima/ima_fs.c
--- a/security/integrity/ima/ima_fs.c~seq_file-constify-seq_operations
+++ a/security/integrity/ima/ima_fs.c
@@ -146,7 +146,7 @@ static int ima_measurements_show(struct 
 	return 0;
 }
 
-static struct seq_operations ima_measurments_seqops = {
+static const struct seq_operations ima_measurments_seqops = {
 	.start = ima_measurements_start,
 	.next = ima_measurements_next,
 	.stop = ima_measurements_stop,
@@ -221,7 +221,7 @@ static int ima_ascii_measurements_show(s
 	return 0;
 }
 
-static struct seq_operations ima_ascii_measurements_seqops = {
+static const struct seq_operations ima_ascii_measurements_seqops = {
 	.start = ima_measurements_start,
 	.next = ima_measurements_next,
 	.stop = ima_measurements_stop,
diff -puN security/smack/smackfs.c~seq_file-constify-seq_operations security/smack/smackfs.c
--- a/security/smack/smackfs.c~seq_file-constify-seq_operations
+++ a/security/smack/smackfs.c
@@ -187,7 +187,7 @@ static void load_seq_stop(struct seq_fil
 	/* No-op */
 }
 
-static struct seq_operations load_seq_ops = {
+static const struct seq_operations load_seq_ops = {
 	.start = load_seq_start,
 	.next  = load_seq_next,
 	.show  = load_seq_show,
@@ -503,7 +503,7 @@ static void cipso_seq_stop(struct seq_fi
 	/* No-op */
 }
 
-static struct seq_operations cipso_seq_ops = {
+static const struct seq_operations cipso_seq_ops = {
 	.start = cipso_seq_start,
 	.stop  = cipso_seq_stop,
 	.next  = cipso_seq_next,
@@ -697,7 +697,7 @@ static void netlbladdr_seq_stop(struct s
 	/* No-op */
 }
 
-static struct seq_operations netlbladdr_seq_ops = {
+static const struct seq_operations netlbladdr_seq_ops = {
 	.start = netlbladdr_seq_start,
 	.stop  = netlbladdr_seq_stop,
 	.next  = netlbladdr_seq_next,
diff -puN drivers/staging/rtl8192e/ieee80211/proc.c~seq_file-constify-seq_operations drivers/staging/rtl8192e/ieee80211/proc.c
--- a/drivers/staging/rtl8192e/ieee80211/proc.c~seq_file-constify-seq_operations
+++ a/drivers/staging/rtl8192e/ieee80211/proc.c
@@ -87,7 +87,7 @@ static int c_show(struct seq_file *m, vo
 	return 0;
 }
 
-static struct seq_operations crypto_seq_ops = {
+static const struct seq_operations crypto_seq_ops = {
 	.start		= c_start,
 	.next		= c_next,
 	.stop		= c_stop,
_

Patches currently in -mm which might be from jmorris@namei.org are

origin.patch
linux-next.patch
seq_file-constify-seq_operations.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch

