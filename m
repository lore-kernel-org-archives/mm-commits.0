From: akpm@linux-foundation.org
Subject: + cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch added to -mm tree
Date: Wed, 05 Mar 2008 16:18:29 -0800
Message-ID: <200803060018.m260IUt0029830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751965AbYCFASm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 19:18:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, lizf@cn.fujitsu.com, pj@sgi.com


The patch titled
     Cpuset hardwall flag: switch cpusets to use the bulk cgroup_add_files() API
has been added to the -mm tree.  Its filename is
     cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Cpuset hardwall flag: switch cpusets to use the bulk cgroup_add_files() API
From: Paul Menage <menage@google.com>

Currently the cpusets mem_exclusive flag is overloaded to mean both
"no-overlapping" and "no GFP_KERNEL allocations outside this cpuset".

These patches add a new mem_hardwall flag with just the allocation restriction
part of the mem_exclusive semantics, without breaking backwards-compatibility
for those who continue to use just mem_exclusive.  Additionally, the cgroup
control file registration for cpusets is cleaned up to reduce boilerplate.


This patch:

This change tidies up the cpusets control file definitions, and reduces the
amount of boilerplate required to add/change control files in the future.

Signed-off-by: Paul Menage <menage@google.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |  149 ++++++++++++++++++++--------------------------
 1 file changed, 68 insertions(+), 81 deletions(-)

diff -puN kernel/cpuset.c~cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api
+++ a/kernel/cpuset.c
@@ -1397,46 +1397,69 @@ static u64 cpuset_read_u64(struct cgroup
  * for the common functions, 'private' gives the type of file
  */
 
-static struct cftype cft_cpus = {
-	.name = "cpus",
-	.read = cpuset_common_file_read,
-	.write = cpuset_common_file_write,
-	.private = FILE_CPULIST,
-};
-
-static struct cftype cft_mems = {
-	.name = "mems",
-	.read = cpuset_common_file_read,
-	.write = cpuset_common_file_write,
-	.private = FILE_MEMLIST,
-};
-
-static struct cftype cft_cpu_exclusive = {
-	.name = "cpu_exclusive",
-	.read_u64 = cpuset_read_u64,
-	.write_u64 = cpuset_write_u64,
-	.private = FILE_CPU_EXCLUSIVE,
-};
-
-static struct cftype cft_mem_exclusive = {
-	.name = "mem_exclusive",
-	.read_u64 = cpuset_read_u64,
-	.write_u64 = cpuset_write_u64,
-	.private = FILE_MEM_EXCLUSIVE,
-};
-
-static struct cftype cft_sched_load_balance = {
-	.name = "sched_load_balance",
-	.read_u64 = cpuset_read_u64,
-	.write_u64 = cpuset_write_u64,
-	.private = FILE_SCHED_LOAD_BALANCE,
-};
-
-static struct cftype cft_memory_migrate = {
-	.name = "memory_migrate",
-	.read_u64 = cpuset_read_u64,
-	.write_u64 = cpuset_write_u64,
-	.private = FILE_MEMORY_MIGRATE,
+static struct cftype files[] = {
+	{
+		.name = "cpus",
+		.read = cpuset_common_file_read,
+		.write = cpuset_common_file_write,
+		.private = FILE_CPULIST,
+	},
+
+	{
+		.name = "mems",
+		.read = cpuset_common_file_read,
+		.write = cpuset_common_file_write,
+		.private = FILE_MEMLIST,
+	},
+
+	{
+		.name = "cpu_exclusive",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_CPU_EXCLUSIVE,
+	},
+
+	{
+		.name = "mem_exclusive",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_MEM_EXCLUSIVE,
+	},
+
+	{
+		.name = "sched_load_balance",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SCHED_LOAD_BALANCE,
+	},
+
+	{
+		.name = "memory_migrate",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_MEMORY_MIGRATE,
+	},
+
+	{
+		.name = "memory_pressure",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_MEMORY_PRESSURE,
+	},
+
+	{
+		.name = "memory_spread_page",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SPREAD_PAGE,
+	},
+
+	{
+		.name = "memory_spread_slab",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SPREAD_SLAB,
+	},
 };
 
 static struct cftype cft_memory_pressure_enabled = {
@@ -1446,54 +1469,18 @@ static struct cftype cft_memory_pressure
 	.private = FILE_MEMORY_PRESSURE_ENABLED,
 };
 
-static struct cftype cft_memory_pressure = {
-	.name = "memory_pressure",
-	.read_u64 = cpuset_read_u64,
-	.write_u64 = cpuset_write_u64,
-	.private = FILE_MEMORY_PRESSURE,
-};
-
-static struct cftype cft_spread_page = {
-	.name = "memory_spread_page",
-	.read_u64 = cpuset_read_u64,
-	.write_u64 = cpuset_write_u64,
-	.private = FILE_SPREAD_PAGE,
-};
-
-static struct cftype cft_spread_slab = {
-	.name = "memory_spread_slab",
-	.read_u64 = cpuset_read_u64,
-	.write_u64 = cpuset_write_u64,
-	.private = FILE_SPREAD_SLAB,
-};
-
 static int cpuset_populate(struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	int err;
 
-	if ((err = cgroup_add_file(cont, ss, &cft_cpus)) < 0)
-		return err;
-	if ((err = cgroup_add_file(cont, ss, &cft_mems)) < 0)
-		return err;
-	if ((err = cgroup_add_file(cont, ss, &cft_cpu_exclusive)) < 0)
-		return err;
-	if ((err = cgroup_add_file(cont, ss, &cft_mem_exclusive)) < 0)
-		return err;
-	if ((err = cgroup_add_file(cont, ss, &cft_memory_migrate)) < 0)
-		return err;
-	if ((err = cgroup_add_file(cont, ss, &cft_sched_load_balance)) < 0)
-		return err;
-	if ((err = cgroup_add_file(cont, ss, &cft_memory_pressure)) < 0)
-		return err;
-	if ((err = cgroup_add_file(cont, ss, &cft_spread_page)) < 0)
-		return err;
-	if ((err = cgroup_add_file(cont, ss, &cft_spread_slab)) < 0)
+	err = cgroup_add_files(cont, ss, files, ARRAY_SIZE(files));
+	if (err)
 		return err;
 	/* memory_pressure_enabled is in root cpuset only */
-	if (err == 0 && !cont->parent)
+	if (!cont->parent)
 		err = cgroup_add_file(cont, ss,
-					 &cft_memory_pressure_enabled);
-	return 0;
+				      &cft_memory_pressure_enabled);
+	return err;
 }
 
 /*
_

Patches currently in -mm which might be from menage@google.com are

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
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch
cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets.patch
add-a-refcount-check-in-dput.patch

