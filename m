From: akpm@linux-foundation.org
Subject: - make-cgroup_enable_task_cg_lists-static.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:04 -0700
Message-ID: <200804300542.m3U5g4Ee029114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757790AbYD3Fmz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:42:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, menage@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     make cgroup_enable_task_cg_lists() static
has been removed from the -mm tree.  Its filename was
     make-cgroup_enable_task_cg_lists-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make cgroup_enable_task_cg_lists() static
From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global cgroup_enable_task_cg_lists() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cgroup.c~make-cgroup_enable_task_cg_lists-static kernel/cgroup.c
--- a/kernel/cgroup.c~make-cgroup_enable_task_cg_lists-static
+++ a/kernel/cgroup.c
@@ -1715,7 +1715,7 @@ static void cgroup_advance_iter(struct c
  * The tasklist_lock is not held here, as do_each_thread() and
  * while_each_thread() are protected by RCU.
  */
-void cgroup_enable_task_cg_lists(void)
+static void cgroup_enable_task_cg_lists(void)
 {
 	struct task_struct *p, *g;
 	write_lock(&css_set_lock);
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

