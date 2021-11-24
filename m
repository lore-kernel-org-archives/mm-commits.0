Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B7CC433FE
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 22:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245131AbhKXWVr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:21:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243516AbhKXWVq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 17:21:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92F9C60F55;
        Wed, 24 Nov 2021 22:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637792316;
        bh=lruKnRJSWmhWgFF1H/ROgYKIq/1Rlr3utPI72dsXJYc=;
        h=Date:From:To:Subject:From;
        b=SJFnEjJU4vDTcKgDp/lEwif4z0krvSmwbqp9thegoa/e7zxqLa7abuheywYv6bWfD
         Suf765BGj4RQWw/jdYczH2esTjbDZxyixqW+tyNhNbfXQBDnlKo/vg/kHoWiOw26Fh
         jbyKkWfndu6swbPW9mK0Y9h/rVXbj1lwsdCpUz4E=
Date:   Wed, 24 Nov 2021 14:18:36 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, gladkov.alexey@gmail.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  [to-be-updated] fs-proc-remove-pde_data.patch removed
 from -mm tree
Message-ID: <20211124221836.S-Gpn4brK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: proc: remove PDE_DATA()
has been removed from the -mm tree.  Its filename was
     fs-proc-remove-pde_data.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: fs: proc: remove PDE_DATA()

There are no users of PDE_DATA() and we do not need it anymore, just
remove it.

Link: https://lkml.kernel.org/r/20211101093518.86845-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |    6 ------
 fs/proc/internal.h      |    5 -----
 include/linux/proc_fs.h |    2 --
 3 files changed, 13 deletions(-)

--- a/fs/proc/generic.c~fs-proc-remove-pde_data
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
--- a/fs/proc/internal.h~fs-proc-remove-pde_data
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
--- a/include/linux/proc_fs.h~fs-proc-remove-pde_data
+++ a/include/linux/proc_fs.h
@@ -110,7 +110,6 @@ extern struct proc_dir_entry *proc_creat
 struct proc_dir_entry *proc_create(const char *name, umode_t mode, struct proc_dir_entry *parent, const struct proc_ops *proc_ops);
 extern void proc_set_size(struct proc_dir_entry *, loff_t);
 extern void proc_set_user(struct proc_dir_entry *, kuid_t, kgid_t);
-extern void *PDE_DATA(const struct inode *);
 extern void *proc_get_parent_data(const struct inode *);
 extern void proc_remove(struct proc_dir_entry *);
 extern void remove_proc_entry(const char *, struct proc_dir_entry *);
@@ -191,7 +190,6 @@ proc_create_data(const char *name, umode
 
 static inline void proc_set_size(struct proc_dir_entry *de, loff_t size) {}
 static inline void proc_set_user(struct proc_dir_entry *de, kuid_t uid, kgid_t gid) {}
-static inline void *PDE_DATA(const struct inode *inode) {BUG(); return NULL;}
 static inline void *proc_get_parent_data(const struct inode *inode) { BUG(); return NULL; }
 
 static inline void proc_remove(struct proc_dir_entry *de) {}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-slab-make-slab-iterator-functions-static.patch
mm-memcontrol-make-cgroup_memory_nokmem-static.patch
mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch
fs-proc-store-pde-data-into-inode-i_private.patch
proc-remove-pde_data-completely.patch
fs-proc-use-define_proc_show_attribute-to-simplify-the-code.patch

