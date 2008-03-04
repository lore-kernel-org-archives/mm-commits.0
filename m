From: akpm@linux-foundation.org
Subject: - udf-fix-anchor-point-detection.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:08:40 -0800
Message-ID: <200803042008.m24K8eFl026696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275AbYCDUJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:09:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, Andrew.Neporada@acronis.com, Max.Lyadvinsky@acronis.com, Vladimir.Simonov@acronis.com, Yuri.Per@acronis.com, dev@openvz.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     UDF: fix anchor point detection
has been removed from the -mm tree.  Its filename was
     udf-fix-anchor-point-detection.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: UDF: fix anchor point detection
From: Pavel Emelyanov <xemul@openvz.org>

According to ECMA 167 rev.  3 (see 3/8.4.2.1), Anchor Volume Descriptor
Pointer should be recorded at two or more anchor points located at sectors
256, N, N - 256, where N - is a largest logical sector number at volume
space.

So we should always try to detect N on UDF volume before trying to find
Anchor Volume Descriptor (i.e.  calling to udf_find_anchor()).

That said, all this patch does is updates the s_last_block even if the
udf_vrs() returns positive value.

Originally written and tested by Yuri Per, ported on latest mainline by me.

Signed-off-by: Yuri Per <Yuri.Per@acronis.com>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Max Lyadvinsky <Max.Lyadvinsky@acronis.com>
Cc: Vladimir Simonov <Vladimir.Simonov@acronis.com>
Cc: Andrew Neporada <Andrew.Neporada@acronis.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN fs/udf/super.c~udf-fix-anchor-point-detection fs/udf/super.c
--- a/fs/udf/super.c~udf-fix-anchor-point-detection
+++ a/fs/udf/super.c
@@ -1488,16 +1488,17 @@ static int udf_check_valid(struct super_
 	/* Check that it is NSR02 compliant */
 	/* Process any "CD-ROM Volume Descriptor Set" (ECMA 167 2/8.3.1) */
 	else {
+		struct udf_sb_info *sbi = UDF_SB(sb);
+
 		block = udf_vrs(sb, silent);
-		if (block == -1) {
-			struct udf_sb_info *sbi = UDF_SB(sb);
+		if (block == -1)
 			udf_debug("Failed to read byte 32768. Assuming open "
 				  "disc. Skipping validity check\n");
-			if (!sbi->s_last_block)
-				sbi->s_last_block = udf_get_last_block(sb);
-			return 0;
-		} else
-			return !block;
+
+		if (block && !sbi->s_last_block)
+			sbi->s_last_block = udf_get_last_block(sb);
+
+		return !block;
 	}
 }
 
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
control-groups-add-paul-menage-a-maintainer.patch
add-balbir-as-the-maintainer-for-memory-resource-controller.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
git-net.patch
udf-fix-anchor-point-detection.patch
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
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
deprecate-find_task_by_pid-warning-fix.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

