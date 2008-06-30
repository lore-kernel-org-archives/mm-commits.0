From: akpm@linux-foundation.org
Subject: + ext3-kill-2-useless-magic-numbers.patch added to -mm tree
Date: Mon, 30 Jun 2008 15:14:06 -0700
Message-ID: <200806302214.m5UMED2r028334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760284AbYF3WOV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 18:14:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, adilger@sun.com


The patch titled
     ext3: kill 2 useless magic numbers
has been added to the -mm tree.  Its filename is
     ext3-kill-2-useless-magic-numbers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: kill 2 useless magic numbers
From: Li Zefan <lizf@cn.fujitsu.com>

dx_root_limit() will never return 20, and I can't figure out what 20
stands for.  This function has never changed since htree directory
indexing was merged.

Similar for dx_node_limit() and the magic 22.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext3/namei.c~ext3-kill-2-useless-magic-numbers fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-kill-2-useless-magic-numbers
+++ a/fs/ext3/namei.c
@@ -240,13 +240,13 @@ static inline unsigned dx_root_limit (st
 {
 	unsigned entry_space = dir->i_sb->s_blocksize - EXT3_DIR_REC_LEN(1) -
 		EXT3_DIR_REC_LEN(2) - infosize;
-	return 0? 20: entry_space / sizeof(struct dx_entry);
+	return entry_space / sizeof(struct dx_entry);
 }
 
 static inline unsigned dx_node_limit (struct inode *dir)
 {
 	unsigned entry_space = dir->i_sb->s_blocksize - EXT3_DIR_REC_LEN(0);
-	return 0? 22: entry_space / sizeof(struct dx_entry);
+	return entry_space / sizeof(struct dx_entry);
 }
 
 /*
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

call_usermodehelper-increase-reliability.patch
rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix.patch
ext3-kill-2-useless-magic-numbers.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-handle-swap-cache-fix-shmem-page-migration-incorrectness-on-memcgroup.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch

