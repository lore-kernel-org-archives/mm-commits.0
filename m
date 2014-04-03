From: akpm@linux-foundation.org
Subject: [folded-merged]
 fanotify-use-fanotify-event-structure-for-permission-response-processing-fix.patch removed from -mm tree
Date: Thu, 03 Apr 2014 14:02:12 -0700
Message-ID: <533dcc54.hdlhN11cBB/in0Ln%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbaDCVCN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:02:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, fengguang.wu@intel.com, eparis@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] fanotify-use-fanotify-event-structure-for-permission-response-processing-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,eparis@redhat.com,fengguang.wu@intel.com,jack@suse.cz,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:02:12 -0700


The patch titled
     Subject: fanotify-use-fanotify-event-structure-for-permission-response-processing-fix
has been removed from the -mm tree.  Its filename was
     fanotify-use-fanotify-event-structure-for-permission-response-processing-fix.patch

This patch was dropped because it was folded into fanotify-use-fanotify-event-structure-for-permission-response-processing.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fanotify-use-fanotify-event-structure-for-permission-response-processing-fix

fix build

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-use-fanotify-event-structure-for-permission-response-processing-fix fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-use-fanotify-event-structure-for-permission-response-processing-fix
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -209,9 +209,12 @@ static ssize_t copy_event_to_user(struct
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	if (event->mask & FAN_ALL_PERM_EVENTS) {
-		FANOTIFY_PE(event)->fd = fd;
+		struct fanotify_perm_event_info *pevent;
+
+		pevent = FANOTIFY_PE(event);
+		pevent->fd = fd;
 		mutex_lock(&group->fanotify_data.access_mutex);
-		list_add_tail(&event->fae.fse.list,
+		list_add_tail(&pevent->fae.fse.list,
 			      &group->fanotify_data.access_list);
 		mutex_unlock(&group->fanotify_data.access_mutex);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch
ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed-checkpatch-fixes.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
xattr-guard-against-simultaneous-glibc-header-inclusion-v2.patch
lib-syscallc-unexport-task_current_syscall.patch
scripts-checkpatchpl-__gfp_nofail-isnt-going-away.patch
checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments-fix.patch
rtc-fixed-potential-race-condition-checkpatch-fixes.patch
befs-logging-clean-up-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch

