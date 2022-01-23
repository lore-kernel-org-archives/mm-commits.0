Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF6BC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbiAWX6R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240514AbiAWX6O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:58:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2675C06173B
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 15:58:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7163660C34
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EEAC340E3;
        Sun, 23 Jan 2022 23:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982292;
        bh=ynUjxNiChRi0BxEzhvetB/mg6YHeytj3GeRUvh815i0=;
        h=Date:From:To:Subject:From;
        b=F4rBUi1DErzwMlXqj+q0WRXnkI/Pe6sBvLL+wpwa0VZVZ7RQ2LtTU2iQubbZ27G+a
         WffnYPQxdJdeIxCRoXOMRH6nKFUV0JaLRDsxjGMEk8wRrUVaBUBTFMahts1Zd3kh4U
         sllC6RXa/IziAhIPj9Jqz8I33uOkh/UYtn1qe8aI=
Date:   Sun, 23 Jan 2022 15:58:12 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, christian.brauner@ubuntu.com,
        gladkov.alexey@gmail.com, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com
Subject:  [merged]
 fs-proc-store-pde-data-into-inode-i_private.patch removed from -mm tree
Message-ID: <20220123235812.zRg-KQsSH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: proc: store PDE()->data into inode->i_private
has been removed from the -mm tree.  Its filename was
     fs-proc-store-pde-data-into-inode-i_private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: fs: proc: store PDE()->data into inode->i_private

PDE_DATA(inode) is introduced to get user private data and hide the layout
of struct proc_dir_entry.  The inode->i_private is used to do the same
thing as well.  Save a copy of user private data to inode-> i_private when
proc inode is allocated.  This means the user also can get their private
data by inode->i_private.

Introduce pde_data() to wrap inode->i_private so that we can remove
PDE_DATA() from fs/proc/generic.c and make PTE_DATE() as a wrapper of
pde_data().  It will be easier if we decide to remove PDE_DATE() in the
future.

Link: https://lkml.kernel.org/r/20211124081956.87711-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |    6 ------
 fs/proc/inode.c         |    1 +
 fs/proc/internal.h      |    5 -----
 include/linux/proc_fs.h |   13 ++++++++++++-
 4 files changed, 13 insertions(+), 12 deletions(-)

--- a/fs/proc/generic.c~fs-proc-store-pde-data-into-inode-i_private
+++ a/fs/proc/generic.c
@@ -791,12 +791,6 @@ void proc_remove(struct proc_dir_entry *
 }
 EXPORT_SYMBOL(proc_remove);
 
-void *PDE_DATA(const struct inode *inode)
-{
-	return __PDE_DATA(inode);
-}
-EXPORT_SYMBOL(PDE_DATA);
-
 /*
  * Pull a user buffer into memory and pass it to the file's write handler if
  * one is supplied.  The ->write() method is permitted to modify the
--- a/fs/proc/inode.c~fs-proc-store-pde-data-into-inode-i_private
+++ a/fs/proc/inode.c
@@ -650,6 +650,7 @@ struct inode *proc_get_inode(struct supe
 		return NULL;
 	}
 
+	inode->i_private = de->data;
 	inode->i_ino = de->low_ino;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
 	PROC_I(inode)->pde = de;
--- a/fs/proc/internal.h~fs-proc-store-pde-data-into-inode-i_private
+++ a/fs/proc/internal.h
@@ -115,11 +115,6 @@ static inline struct proc_dir_entry *PDE
 	return PROC_I(inode)->pde;
 }
 
-static inline void *__PDE_DATA(const struct inode *inode)
-{
-	return PDE(inode)->data;
-}
-
 static inline struct pid *proc_pid(const struct inode *inode)
 {
 	return PROC_I(inode)->pid;
--- a/include/linux/proc_fs.h~fs-proc-store-pde-data-into-inode-i_private
+++ a/include/linux/proc_fs.h
@@ -110,7 +110,18 @@ extern struct proc_dir_entry *proc_creat
 struct proc_dir_entry *proc_create(const char *name, umode_t mode, struct proc_dir_entry *parent, const struct proc_ops *proc_ops);
 extern void proc_set_size(struct proc_dir_entry *, loff_t);
 extern void proc_set_user(struct proc_dir_entry *, kuid_t, kgid_t);
-extern void *PDE_DATA(const struct inode *);
+
+/*
+ * Obtain the private data passed by user through proc_create_data() or
+ * related.
+ */
+static inline void *pde_data(const struct inode *inode)
+{
+	return inode->i_private;
+}
+
+#define PDE_DATA(i)	pde_data(i)
+
 extern void *proc_get_parent_data(const struct inode *);
 extern void proc_remove(struct proc_dir_entry *);
 extern void remove_proc_entry(const char *, struct proc_dir_entry *);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch

