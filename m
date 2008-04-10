From: akpm@linux-foundation.org
Subject: - sctp-fix-wrong-debug-counting-of-bind_bucket.patch removed from -mm tree
Date: Thu, 10 Apr 2008 13:01:37 -0700
Message-ID: <200804102001.m3AK1bfL014990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757189AbYDJUC3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:02:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, sri@us.ibm.com, vladislav.yasevich@hp.com, mm-commits@vger.kernel.org


The patch titled
     sctp: fix wrong debug counting of bind_bucket
has been removed from the -mm tree.  Its filename was
     sctp-fix-wrong-debug-counting-of-bind_bucket.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sctp: fix wrong debug counting of bind_bucket
From: Li Zefan <lizf@cn.fujitsu.com>

Should not count it if the allocation of the object is failed.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/sctp/socket.c~sctp-fix-wrong-debug-counting-of-bind_bucket net/sctp/socket.c
--- a/net/sctp/socket.c~sctp-fix-wrong-debug-counting-of-bind_bucket
+++ a/net/sctp/socket.c
@@ -5761,8 +5761,8 @@ static struct sctp_bind_bucket *sctp_buc
 	struct sctp_bind_bucket *pp;
 
 	pp = kmem_cache_alloc(sctp_bucket_cachep, GFP_ATOMIC);
-	SCTP_DBG_OBJCNT_INC(bind_bucket);
 	if (pp) {
+		SCTP_DBG_OBJCNT_INC(bind_bucket);
 		pp->port = snum;
 		pp->fastreuse = 0;
 		INIT_HLIST_HEAD(&pp->owner);
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

