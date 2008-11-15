From: akpm@linux-foundation.org
Subject: + quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables-fix.patch added to -mm tree
Date: Fri, 14 Nov 2008 20:44:21 -0800
Message-ID: <200811150444.mAF4iL9G016255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbYKOEoq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 23:44:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, cmm@us.ibm.com, hch@lst.de, jack@ucw.cz


The patch titled
     quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables-fix
has been added to the -mm tree.  Its filename is
     quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables-fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

fs/dquot.c:1391: error: redefinition of '__kcrctab_dquot_reserve_space'
fs/dquot.c:1352: error: previous definition of '__kcrctab_dquot_reserve_space' was here
fs/dquot.c:1391: error: redefinition of '__kstrtab_dquot_reserve_space'
fs/dquot.c:1352: error: previous definition of '__kstrtab_dquot_reserve_space' was here
fs/dquot.c:1391: error: redefinition of '__ksymtab_dquot_reserve_space'
fs/dquot.c:1352: error: previous definition of '__ksymtab_dquot_reserve_space' was here
fs/dquot.c:2101: error: redefinition of '__kcrctab_vfs_dq_quota_on_remount'
fs/dquot.c:1974: error: previous definition of '__kcrctab_vfs_dq_quota_on_remount' was here
fs/dquot.c:2101: error: redefinition of '__kstrtab_vfs_dq_quota_on_remount'
fs/dquot.c:1974: error: previous definition of '__kstrtab_vfs_dq_quota_on_remount' was here
fs/dquot.c:2101: error: redefinition of '__ksymtab_vfs_dq_quota_on_remount'
fs/dquot.c:1974: error: previous definition of '__ksymtab_vfs_dq_quota_on_remount' was here

Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@ucw.cz>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/dquot.c~quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables-fix fs/dquot.c
--- a/fs/dquot.c~quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables-fix
+++ a/fs/dquot.c
@@ -1388,7 +1388,7 @@ int dquot_claim_space(struct inode *inod
 	inode_add_bytes(inode, number);
 	return ret;
 }
-EXPORT_SYMBOL(dquot_reserve_space);
+EXPORT_SYMBOL(dquot_claim_space);
 
 /*
  * Release reserved quota space
@@ -1971,7 +1971,7 @@ static int vfs_quota_on_remount(struct s
 
 	return ret;
 }
-EXPORT_SYMBOL(vfs_dq_quota_on_remount);
+EXPORT_SYMBOL(vfs_quota_on_remount);
 
 int vfs_quota_on_path(struct super_block *sb, int type, int format_id,
 		      struct path *path)
@@ -2277,6 +2277,7 @@ out:
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return err;
 }
+EXPORT_SYMBOL(vfs_set_dqinfo);
 
 struct quotactl_ops vfs_quotactl_ops = {
 	.quota_on	= vfs_quota_on,
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cgroup-fix-potential-deadlock-in-pre_destroy-v2.patch
migration-fix-writepage-error.patch
quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables-fix.patch
cgroups-make-cgroup-config-a-submenu.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memcg-memory-hotplug-fix-for-notifier-callback.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-swap-cgroup-for-remembering-usage-fix.patch
memcg-memswap-controller-core.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch

