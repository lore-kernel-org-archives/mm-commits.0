From: akpm@linux-foundation.org
Subject: - cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:19 -0700
Message-ID: <200804300542.m3U5gJ66029135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757123AbYD3Fng (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:43:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, pj@sgi.com, xemul@openvz.org, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     CGroup API files: update cpusets to use cgroup structured file API
has been removed from the -mm tree.  Its filename was
     cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CGroup API files: update cpusets to use cgroup structured file API
From: Paul Menage <menage@google.com>

Many of the cpusets control files are simple integer values, which don't
require the overhead of memory allocations for reads and writes.

Move the handlers for these control files into cpuset_read_u64() and
cpuset_write_u64().

[akpm@linux-foundation.org: ad dmissing `break']
Signed-off-by: Paul Menage <menage@google.com>
Cc: "Li Zefan" <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |  160 +++++++++++++++++++++++-----------------------
 1 file changed, 83 insertions(+), 77 deletions(-)

diff -puN kernel/cpuset.c~cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api kernel/cpuset.c
--- a/kernel/cpuset.c~cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api
+++ a/kernel/cpuset.c
@@ -1023,19 +1023,6 @@ int current_cpuset_is_being_rebound(void
 	return task_cs(current) == cpuset_being_rebound;
 }
 
-/*
- * Call with cgroup_mutex held.
- */
-
-static int update_memory_pressure_enabled(struct cpuset *cs, char *buf)
-{
-	if (simple_strtoul(buf, NULL, 10) != 0)
-		cpuset_memory_pressure_enabled = 1;
-	else
-		cpuset_memory_pressure_enabled = 0;
-	return 0;
-}
-
 static int update_relax_domain_level(struct cpuset *cs, char *buf)
 {
 	int val = simple_strtol(buf, NULL, 10);
@@ -1063,15 +1050,13 @@ static int update_relax_domain_level(str
  * Call with cgroup_mutex held.
  */
 
-static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs, char *buf)
+static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
+		       int turning_on)
 {
-	int turning_on;
 	struct cpuset trialcs;
 	int err;
 	int cpus_nonempty, balance_flag_changed;
 
-	turning_on = (simple_strtoul(buf, NULL, 10) != 0);
-
 	trialcs = *cs;
 	if (turning_on)
 		set_bit(bit, &trialcs.flags);
@@ -1288,46 +1273,68 @@ static ssize_t cpuset_common_file_write(
 	case FILE_MEMLIST:
 		retval = update_nodemask(cs, buffer);
 		break;
+	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
+		retval = update_relax_domain_level(cs, buffer);
+		break;
+	default:
+		retval = -EINVAL;
+		goto out2;
+	}
+
+	if (retval == 0)
+		retval = nbytes;
+out2:
+	cgroup_unlock();
+out1:
+	kfree(buffer);
+	return retval;
+}
+
+static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
+{
+	int retval = 0;
+	struct cpuset *cs = cgroup_cs(cgrp);
+	cpuset_filetype_t type = cft->private;
+
+	cgroup_lock();
+
+	if (cgroup_is_removed(cgrp)) {
+		cgroup_unlock();
+		return -ENODEV;
+	}
+
+	switch (type) {
 	case FILE_CPU_EXCLUSIVE:
-		retval = update_flag(CS_CPU_EXCLUSIVE, cs, buffer);
+		retval = update_flag(CS_CPU_EXCLUSIVE, cs, val);
 		break;
 	case FILE_MEM_EXCLUSIVE:
-		retval = update_flag(CS_MEM_EXCLUSIVE, cs, buffer);
+		retval = update_flag(CS_MEM_EXCLUSIVE, cs, val);
 		break;
 	case FILE_SCHED_LOAD_BALANCE:
-		retval = update_flag(CS_SCHED_LOAD_BALANCE, cs, buffer);
-		break;
-	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
-		retval = update_relax_domain_level(cs, buffer);
+		retval = update_flag(CS_SCHED_LOAD_BALANCE, cs, val);
 		break;
 	case FILE_MEMORY_MIGRATE:
-		retval = update_flag(CS_MEMORY_MIGRATE, cs, buffer);
+		retval = update_flag(CS_MEMORY_MIGRATE, cs, val);
 		break;
 	case FILE_MEMORY_PRESSURE_ENABLED:
-		retval = update_memory_pressure_enabled(cs, buffer);
+		cpuset_memory_pressure_enabled = !!val;
 		break;
 	case FILE_MEMORY_PRESSURE:
 		retval = -EACCES;
 		break;
 	case FILE_SPREAD_PAGE:
-		retval = update_flag(CS_SPREAD_PAGE, cs, buffer);
+		retval = update_flag(CS_SPREAD_PAGE, cs, val);
 		cs->mems_generation = cpuset_mems_generation++;
 		break;
 	case FILE_SPREAD_SLAB:
-		retval = update_flag(CS_SPREAD_SLAB, cs, buffer);
+		retval = update_flag(CS_SPREAD_SLAB, cs, val);
 		cs->mems_generation = cpuset_mems_generation++;
 		break;
 	default:
 		retval = -EINVAL;
-		goto out2;
+		break;
 	}
-
-	if (retval == 0)
-		retval = nbytes;
-out2:
 	cgroup_unlock();
-out1:
-	kfree(buffer);
 	return retval;
 }
 
@@ -1389,33 +1396,9 @@ static ssize_t cpuset_common_file_read(s
 	case FILE_MEMLIST:
 		s += cpuset_sprintf_memlist(s, cs);
 		break;
-	case FILE_CPU_EXCLUSIVE:
-		*s++ = is_cpu_exclusive(cs) ? '1' : '0';
-		break;
-	case FILE_MEM_EXCLUSIVE:
-		*s++ = is_mem_exclusive(cs) ? '1' : '0';
-		break;
-	case FILE_SCHED_LOAD_BALANCE:
-		*s++ = is_sched_load_balance(cs) ? '1' : '0';
-		break;
 	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
 		s += sprintf(s, "%d", cs->relax_domain_level);
 		break;
-	case FILE_MEMORY_MIGRATE:
-		*s++ = is_memory_migrate(cs) ? '1' : '0';
-		break;
-	case FILE_MEMORY_PRESSURE_ENABLED:
-		*s++ = cpuset_memory_pressure_enabled ? '1' : '0';
-		break;
-	case FILE_MEMORY_PRESSURE:
-		s += sprintf(s, "%d", fmeter_getrate(&cs->fmeter));
-		break;
-	case FILE_SPREAD_PAGE:
-		*s++ = is_spread_page(cs) ? '1' : '0';
-		break;
-	case FILE_SPREAD_SLAB:
-		*s++ = is_spread_slab(cs) ? '1' : '0';
-		break;
 	default:
 		retval = -EINVAL;
 		goto out;
@@ -1428,8 +1411,31 @@ out:
 	return retval;
 }
 
-
-
+static u64 cpuset_read_u64(struct cgroup *cont, struct cftype *cft)
+{
+	struct cpuset *cs = cgroup_cs(cont);
+	cpuset_filetype_t type = cft->private;
+	switch (type) {
+	case FILE_CPU_EXCLUSIVE:
+		return is_cpu_exclusive(cs);
+	case FILE_MEM_EXCLUSIVE:
+		return is_mem_exclusive(cs);
+	case FILE_SCHED_LOAD_BALANCE:
+		return is_sched_load_balance(cs);
+	case FILE_MEMORY_MIGRATE:
+		return is_memory_migrate(cs);
+	case FILE_MEMORY_PRESSURE_ENABLED:
+		return cpuset_memory_pressure_enabled;
+	case FILE_MEMORY_PRESSURE:
+		return fmeter_getrate(&cs->fmeter);
+	case FILE_SPREAD_PAGE:
+		return is_spread_page(cs);
+	case FILE_SPREAD_SLAB:
+		return is_spread_slab(cs);
+	default:
+		BUG();
+	}
+}
 
 
 /*
@@ -1452,22 +1458,22 @@ static struct cftype cft_mems = {
 
 static struct cftype cft_cpu_exclusive = {
 	.name = "cpu_exclusive",
-	.read = cpuset_common_file_read,
-	.write = cpuset_common_file_write,
+	.read_u64 = cpuset_read_u64,
+	.write_u64 = cpuset_write_u64,
 	.private = FILE_CPU_EXCLUSIVE,
 };
 
 static struct cftype cft_mem_exclusive = {
 	.name = "mem_exclusive",
-	.read = cpuset_common_file_read,
-	.write = cpuset_common_file_write,
+	.read_u64 = cpuset_read_u64,
+	.write_u64 = cpuset_write_u64,
 	.private = FILE_MEM_EXCLUSIVE,
 };
 
 static struct cftype cft_sched_load_balance = {
 	.name = "sched_load_balance",
-	.read = cpuset_common_file_read,
-	.write = cpuset_common_file_write,
+	.read_u64 = cpuset_read_u64,
+	.write_u64 = cpuset_write_u64,
 	.private = FILE_SCHED_LOAD_BALANCE,
 };
 
@@ -1480,36 +1486,36 @@ static struct cftype cft_sched_relax_dom
 
 static struct cftype cft_memory_migrate = {
 	.name = "memory_migrate",
-	.read = cpuset_common_file_read,
-	.write = cpuset_common_file_write,
+	.read_u64 = cpuset_read_u64,
+	.write_u64 = cpuset_write_u64,
 	.private = FILE_MEMORY_MIGRATE,
 };
 
 static struct cftype cft_memory_pressure_enabled = {
 	.name = "memory_pressure_enabled",
-	.read = cpuset_common_file_read,
-	.write = cpuset_common_file_write,
+	.read_u64 = cpuset_read_u64,
+	.write_u64 = cpuset_write_u64,
 	.private = FILE_MEMORY_PRESSURE_ENABLED,
 };
 
 static struct cftype cft_memory_pressure = {
 	.name = "memory_pressure",
-	.read = cpuset_common_file_read,
-	.write = cpuset_common_file_write,
+	.read_u64 = cpuset_read_u64,
+	.write_u64 = cpuset_write_u64,
 	.private = FILE_MEMORY_PRESSURE,
 };
 
 static struct cftype cft_spread_page = {
 	.name = "memory_spread_page",
-	.read = cpuset_common_file_read,
-	.write = cpuset_common_file_write,
+	.read_u64 = cpuset_read_u64,
+	.write_u64 = cpuset_write_u64,
 	.private = FILE_SPREAD_PAGE,
 };
 
 static struct cftype cft_spread_slab = {
 	.name = "memory_spread_slab",
-	.read = cpuset_common_file_read,
-	.write = cpuset_common_file_write,
+	.read_u64 = cpuset_read_u64,
+	.write_u64 = cpuset_write_u64,
 	.private = FILE_SPREAD_SLAB,
 };
 
@@ -1642,7 +1648,7 @@ static void cpuset_destroy(struct cgroup
 	cpuset_update_task_memory_state();
 
 	if (is_sched_load_balance(cs))
-		update_flag(CS_SCHED_LOAD_BALANCE, cs, "0");
+		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
 	number_of_cpusets--;
 	kfree(cs);
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
disable-the-memory-controller-by-default-v3.patch
add-a-refcount-check-in-dput.patch

