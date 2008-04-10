From: akpm@linux-foundation.org
Subject: - sctp-fix-wrong-debug-counting-of-datamsg.patch removed from -mm tree
Date: Thu, 10 Apr 2008 13:01:35 -0700
Message-ID: <200804102001.m3AK1ZJa014985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754544AbYDJUMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:12:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, sri@us.ibm.com, vladislav.yasevich@hp.com, mm-commits@vger.kernel.org


The patch titled
     sctp: fix wrong debug counting of datamsg
has been removed from the -mm tree.  Its filename was
     sctp-fix-wrong-debug-counting-of-datamsg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sctp: fix wrong debug counting of datamsg
From: Li Zefan <lizf@cn.fujitsu.com>

Should not count it if the allocation of this object failed.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/chunk.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN net/sctp/chunk.c~sctp-fix-wrong-debug-counting-of-datamsg net/sctp/chunk.c
--- a/net/sctp/chunk.c~sctp-fix-wrong-debug-counting-of-datamsg
+++ a/net/sctp/chunk.c
@@ -66,9 +66,10 @@ SCTP_STATIC struct sctp_datamsg *sctp_da
 {
 	struct sctp_datamsg *msg;
 	msg = kmalloc(sizeof(struct sctp_datamsg), gfp);
-	if (msg)
+	if (msg) {
 		sctp_datamsg_init(msg);
-	SCTP_DBG_OBJCNT_INC(datamsg);
+		SCTP_DBG_OBJCNT_INC(datamsg);
+	}
 	return msg;
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
git-ia64.patch
git-net.patch
oom_kill-remove-unused-parameter-in-badness.patch
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
cgroup-annotate-cgroup_init_subsys-with-__init.patch
cgroup-switch-to-proc_create.patch
cgroups-implement-device-whitelist-v6.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-doc.patch
cgroups-implement-device-whitelist-v6-fix.patch
cgroups-use-a-hash-table-for-css_set-finding.patch
cgroups-simplify-init_subsys.patch
cgroups-remove-the-css_set-linked-list.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch

