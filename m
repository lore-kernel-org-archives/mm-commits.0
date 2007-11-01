From: akpm@linux-foundation.org
Subject: + kernel-taskstatsc-fix-bogus-nlmsg_free.patch added to -mm tree
Date: Thu, 01 Nov 2007 00:36:59 -0700
Message-ID: <200711010736.lA17ax9O018501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36430 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753565AbXKAHhN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 03:37:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, balbir@linux.vnet.ibm


The patch titled
     kernel/taskstats.c: fix bogus nlmsg_free()
has been added to the -mm tree.  Its filename is
     kernel-taskstatsc-fix-bogus-nlmsg_free.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/taskstats.c: fix bogus nlmsg_free()
From: Adrian Bunk <bunk@kernel.org>

We'd better not nlmsg_free on a pointer containing an undefined value
(and without having anything allocated).

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff -puN kernel/taskstats.c~kernel-taskstatsc-fix-bogus-nlmsg_free kernel/taskstats.c
--- a/kernel/taskstats.c~kernel-taskstatsc-fix-bogus-nlmsg_free
+++ a/kernel/taskstats.c
@@ -398,31 +398,31 @@ static int cgroupstats_user_cmd(struct s
 
 	fd = nla_get_u32(info->attrs[CGROUPSTATS_CMD_ATTR_FD]);
 	file = fget_light(fd, &fput_needed);
-	if (file) {
-		size = nla_total_size(sizeof(struct cgroupstats));
+	if (!file)
+		return 0;
 
-		rc = prepare_reply(info, CGROUPSTATS_CMD_NEW, &rep_skb,
-					size);
-		if (rc < 0)
-			goto err;
-
-		na = nla_reserve(rep_skb, CGROUPSTATS_TYPE_CGROUP_STATS,
-					sizeof(struct cgroupstats));
-		stats = nla_data(na);
-		memset(stats, 0, sizeof(*stats));
+	size = nla_total_size(sizeof(struct cgroupstats));
 
-		rc = cgroupstats_build(stats, file->f_dentry);
-		if (rc < 0)
-			goto err;
+	rc = prepare_reply(info, CGROUPSTATS_CMD_NEW, &rep_skb,
+				size);
+	if (rc < 0)
+		goto err;
 
-		fput_light(file, fput_needed);
-		return send_reply(rep_skb, info->snd_pid);
+	na = nla_reserve(rep_skb, CGROUPSTATS_TYPE_CGROUP_STATS,
+				sizeof(struct cgroupstats));
+	stats = nla_data(na);
+	memset(stats, 0, sizeof(*stats));
+
+	rc = cgroupstats_build(stats, file->f_dentry);
+	if (rc < 0) {
+		nlmsg_free(rep_skb);
+		goto err;
 	}
 
+	rc = send_reply(rep_skb, info->snd_pid);
+
 err:
-	if (file)
-		fput_light(file, fput_needed);
-	nlmsg_free(rep_skb);
+	fput_light(file, fput_needed);
 	return rc;
 }
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-hwmon.patch
git-input.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
scsi-advansysc-make-3-functions-static.patch
git-block.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
scheduled-oss-driver-removal.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
