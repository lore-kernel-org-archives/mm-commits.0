From: akpm@linux-foundation.org
Subject: - cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:22 -0700
Message-ID: <200804300543.m3U5hMea029311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758106AbYD3FoB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:44:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, lizf@cn.fujitsu.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Cpuset hardwall flag: switch cpusets to use the bulk cgroup_add_files() API
has been removed from the -mm tree.  Its filename was
     cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 kernel/cpuset.c |  166 ++++++++++++++++++++--------------------------
 1 file changed, 75 insertions(+), 91 deletions(-)

diff -puN kernel/cpuset.c~cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api
+++ a/kernel/cpuset.c
@@ -1444,53 +1444,76 @@ static u64 cpuset_read_u64(struct cgroup
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
-static struct cftype cft_sched_relax_domain_level = {
-	.name = "sched_relax_domain_level",
-	.read = cpuset_common_file_read,
-	.write = cpuset_common_file_write,
-	.private = FILE_SCHED_RELAX_DOMAIN_LEVEL,
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
+		.name = "sched_relax_domain_level",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SCHED_RELAX_DOMAIN_LEVEL,
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
@@ -1500,57 +1523,18 @@ static struct cftype cft_memory_pressure
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
-	if ((err = cgroup_add_file(cont, ss,
-					&cft_sched_relax_domain_level)) < 0)
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

origin.patch
disable-the-memory-controller-by-default-v3.patch
add-a-refcount-check-in-dput.patch

