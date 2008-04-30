From: akpm@linux-foundation.org
Subject: - kernel-cpusetc-make-3-functions-static.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:20 -0700
Message-ID: <200804300543.m3U5hKFJ029308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759072AbYD3GMO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     kernel/cpuset.c: make 3 functions static
has been removed from the -mm tree.  Its filename was
     kernel-cpusetc-make-3-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/cpuset.c: make 3 functions static
From: Adrian Bunk <bunk@kernel.org>

Make the following needlessly global functions static:

- cpuset_test_cpumask()
- cpuset_change_cpumask()
- cpuset_do_move_task()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/cpuset.c~kernel-cpusetc-make-3-functions-static kernel/cpuset.c
--- a/kernel/cpuset.c~kernel-cpusetc-make-3-functions-static
+++ a/kernel/cpuset.c
@@ -735,7 +735,8 @@ static inline int started_after(void *p1
  * Return nonzero if this tasks's cpus_allowed mask should be changed (in other
  * words, if its mask is not equal to its cpuset's mask).
  */
-int cpuset_test_cpumask(struct task_struct *tsk, struct cgroup_scanner *scan)
+static int cpuset_test_cpumask(struct task_struct *tsk,
+			       struct cgroup_scanner *scan)
 {
 	return !cpus_equal(tsk->cpus_allowed,
 			(cgroup_cs(scan->cg))->cpus_allowed);
@@ -752,7 +753,8 @@ int cpuset_test_cpumask(struct task_stru
  * We don't need to re-check for the cgroup/cpuset membership, since we're
  * holding cgroup_lock() at this point.
  */
-void cpuset_change_cpumask(struct task_struct *tsk, struct cgroup_scanner *scan)
+static void cpuset_change_cpumask(struct task_struct *tsk,
+				  struct cgroup_scanner *scan)
 {
 	set_cpus_allowed_ptr(tsk, &((cgroup_cs(scan->cg))->cpus_allowed));
 }
@@ -1713,7 +1715,8 @@ int __init cpuset_init(void)
  * Called by cgroup_scan_tasks() for each task in a cgroup.
  * Return nonzero to stop the walk through the tasks.
  */
-void cpuset_do_move_task(struct task_struct *tsk, struct cgroup_scanner *scan)
+static void cpuset_do_move_task(struct task_struct *tsk,
+				struct cgroup_scanner *scan)
 {
 	struct cpuset_hotplug_scanner *chsp;
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
git-x86.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
make-marker_debug-static.patch
reiser4.patch

