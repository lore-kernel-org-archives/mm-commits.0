From: akpm@linux-foundation.org
Subject: [merged] proc-use-kzalloc-instead-of-kmalloc-and-memset.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:19:58 -0700
Message-ID: <20121005201959.1A6525C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:37923 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUUA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:20:00 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so57973wib.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:19:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clouds.yan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: use kzalloc instead of kmalloc and memset
has been removed from the -mm tree.  Its filename was
     proc-use-kzalloc-instead-of-kmalloc-and-memset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: yan <clouds.yan@gmail.com>
Subject: proc: use kzalloc instead of kmalloc and memset

Part of the memory will be written twice after this change, but that
should be negligible.

[akpm@linux-foundation.org: fix __proc_create() coding-style issues, remove unneeded zero-initialisations]
Signed-off-by: yan <clouds.yan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN fs/proc/generic.c~proc-use-kzalloc-instead-of-kmalloc-and-memset fs/proc/generic.c
--- a/fs/proc/generic.c~proc-use-kzalloc-instead-of-kmalloc-and-memset
+++ a/fs/proc/generic.c
@@ -605,7 +605,8 @@ static struct proc_dir_entry *__proc_cre
 	unsigned int len;
 
 	/* make sure name is valid */
-	if (!name || !strlen(name)) goto out;
+	if (!name || !strlen(name))
+		goto out;
 
 	if (xlate_proc_name(name, parent, &fn) != 0)
 		goto out;
@@ -616,20 +617,18 @@ static struct proc_dir_entry *__proc_cre
 
 	len = strlen(fn);
 
-	ent = kmalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
-	if (!ent) goto out;
+	ent = kzalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
+	if (!ent)
+		goto out;
 
-	memset(ent, 0, sizeof(struct proc_dir_entry));
 	memcpy(ent->name, fn, len + 1);
 	ent->namelen = len;
 	ent->mode = mode;
 	ent->nlink = nlink;
 	atomic_set(&ent->count, 1);
-	ent->pde_users = 0;
 	spin_lock_init(&ent->pde_unload_lock);
-	ent->pde_unload_completion = NULL;
 	INIT_LIST_HEAD(&ent->pde_openers);
- out:
+out:
 	return ent;
 }
 
_

Patches currently in -mm which might be from clouds.yan@gmail.com are

origin.patch
fs-debugsfs-remove-unnecessary-inode-i_private-initialization.patch
fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget.patch
fs-fs-writebackc-remove-unneccesary-parameter-of-__writeback_single_inode.patch

