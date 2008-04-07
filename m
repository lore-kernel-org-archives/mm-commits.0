From: akpm@linux-foundation.org
Subject: - cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch removed from -mm tree
Date: Mon, 07 Apr 2008 13:01:39 -0700
Message-ID: <200804072001.m37K1dEp022754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244AbYDGUHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 16:07:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, rientjes@google.com, skumar@linux.vnet.ibm.com, xemul@openvz.org


The patch titled
     cgroups: add cgroup support for enabling controllers at boot time
has been removed from the -mm tree.  Its filename was
     cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: add cgroup support for enabling controllers at boot time
From: Paul Menage <menage@google.com>

The effects of cgroup_disable=foo are:

- foo isn't auto-mounted if you mount all cgroups in a single hierarchy
- foo isn't visible as an individually mountable subsystem

As a result there will only ever be one call to foo->create(), at init time;
all processes will stay in this group, and the group will never be mounted on
a visible hierarchy.  Any additional effects (e.g.  not allocating metadata)
are up to the foo subsystem.

This doesn't handle early_init subsystems (their "disabled" bit isn't set be,
but it could easily be extended to do so if any of the early_init systems
wanted it - I think it would just involve some nastier parameter processing
since it would occur before the command-line argument parser had been run.

Hugh said:

  Ballpark figures, I'm trying to get this question out rather than
  processing the exact numbers: CONFIG_CGROUP_MEM_RES_CTLR adds 15% overhead
  to the affected paths, booting with cgroup_disable=memory cuts that back to
  1% overhead (due to slightly bigger struct page).

  I'm no expert on distros, they may have no interest whatever in
  CONFIG_CGROUP_MEM_RES_CTLR=y; and the rest of us can easily build with or
  without it, or apply the cgroup_disable=memory patches.


Unix bench's execl test result on x86_64 was

== just after boot without mounting any cgroup fs.==
mem_cgorup=off : Execl Throughput       43.0     3150.1      732.6
mem_cgroup=on  : Execl Throughput       43.0     2932.6      682.0
==

[lizf@cn.fujitsu.com: fix boot option parsing]
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    4 ++
 include/linux/cgroup.h              |    1 
 kernel/cgroup.c                     |   42 ++++++++++++++++++++++----
 3 files changed, 42 insertions(+), 5 deletions(-)

diff -puN Documentation/kernel-parameters.txt~cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time
+++ a/Documentation/kernel-parameters.txt
@@ -375,6 +375,10 @@ and is between 256 and 4096 characters. 
 	ccw_timeout_log [S390]
 			See Documentation/s390/CommonIO for details.
 
+	cgroup_disable= [KNL] Disable a particular controller
+			Format: {name of the controller(s) to disable}
+				{Currently supported controllers - "memory"}
+
 	checkreqprot	[SELINUX] Set initial checkreqprot flag value.
 			Format: { "0" | "1" }
 			See security/selinux/Kconfig help text.
diff -puN include/linux/cgroup.h~cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time
+++ a/include/linux/cgroup.h
@@ -256,6 +256,7 @@ struct cgroup_subsys {
 	void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
 	int subsys_id;
 	int active;
+	int disabled;
 	int early_init;
 #define MAX_CGROUP_TYPE_NAMELEN 32
 	const char *name;
diff -puN kernel/cgroup.c~cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time
+++ a/kernel/cgroup.c
@@ -782,7 +782,14 @@ static int parse_cgroupfs_options(char *
 		if (!*token)
 			return -EINVAL;
 		if (!strcmp(token, "all")) {
-			opts->subsys_bits = (1 << CGROUP_SUBSYS_COUNT) - 1;
+			/* Add all non-disabled subsystems */
+			int i;
+			opts->subsys_bits = 0;
+			for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+				struct cgroup_subsys *ss = subsys[i];
+				if (!ss->disabled)
+					opts->subsys_bits |= 1ul << i;
+			}
 		} else if (!strcmp(token, "noprefix")) {
 			set_bit(ROOT_NOPREFIX, &opts->flags);
 		} else if (!strncmp(token, "release_agent=", 14)) {
@@ -800,7 +807,8 @@ static int parse_cgroupfs_options(char *
 			for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 				ss = subsys[i];
 				if (!strcmp(token, ss->name)) {
-					set_bit(i, &opts->subsys_bits);
+					if (!ss->disabled)
+						set_bit(i, &opts->subsys_bits);
 					break;
 				}
 			}
@@ -2600,13 +2608,13 @@ static int proc_cgroupstats_show(struct 
 {
 	int i;
 
-	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\n");
+	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\tenabled\n");
 	mutex_lock(&cgroup_mutex);
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
-		seq_printf(m, "%s\t%lu\t%d\n",
+		seq_printf(m, "%s\t%lu\t%d\t%d\n",
 			   ss->name, ss->root->subsys_bits,
-			   ss->root->number_of_cgroups);
+			   ss->root->number_of_cgroups, !ss->disabled);
 	}
 	mutex_unlock(&cgroup_mutex);
 	return 0;
@@ -3010,3 +3018,27 @@ static void cgroup_release_agent(struct 
 	spin_unlock(&release_list_lock);
 	mutex_unlock(&cgroup_mutex);
 }
+
+static int __init cgroup_disable(char *str)
+{
+	int i;
+	char *token;
+
+	while ((token = strsep(&str, ",")) != NULL) {
+		if (!*token)
+			continue;
+
+		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+			struct cgroup_subsys *ss = subsys[i];
+
+			if (!strcmp(token, ss->name)) {
+				ss->disabled = 1;
+				printk(KERN_INFO "Disabling %s control group"
+					" subsystem\n", ss->name);
+				break;
+			}
+		}
+	}
+	return 1;
+}
+__setup("cgroup_disable=", cgroup_disable);
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods.patch
cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file.patch
cgroup-annotate-cgroup_init_subsys-with-__init.patch
cgroup-switch-to-proc_create.patch
cgroups-add-the-trigger-callback-to-struct-cftype.patch
cgroups-implement-device-whitelist-v6.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-doc.patch
cgroups-implement-device-whitelist-v6-fix.patch
cgroups-use-a-hash-table-for-css_set-finding.patch
cgroups-simplify-init_subsys.patch
cgroups-remove-the-css_set-linked-list.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
memcgroup-use-triggers-in-force_empty-and-max_usage-files.patch
memcgroup-implement-failcounter-reset.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch
cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets.patch
add-a-refcount-check-in-dput.patch

