Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41541C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 05:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 165ED61BFA
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 05:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhKPFNk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Nov 2021 00:13:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:39376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230231AbhKPFMy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Nov 2021 00:12:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C53AE61A6C;
        Tue, 16 Nov 2021 05:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637039397;
        bh=w551Y4dQbT36UXBqN8t9b730Dbh9eZNijyBiiLOFZ0I=;
        h=Date:From:To:Subject:From;
        b=sy92MfE/Mg1N1jomKscbrhyK33UTEb/YyCG4S4C3WkTwcrVSIwNhEw9rEUFsQe88r
         eqOB3Qg5Aijy0atuEYv9hAUja6XXKzsp6I+kwUa6UpKv44sBRGTqm312jCyvExT4v7
         xQ/WGxnLBlchp5hInO67knTRcr0mzNrqdRRIBLHk=
Date:   Mon, 15 Nov 2021 21:09:57 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, gladkov.alexey@gmail.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  + fs-proc-remove-pde_data.patch added to -mm tree
Message-ID: <20211116050957.uGEbwc2fx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: proc: remove PDE_DATA()
has been added to the -mm tree.  Its filename is
     fs-proc-remove-pde_data.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-proc-remove-pde_data.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-remove-pde_data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -183,7 +182,6 @@ static inline struct proc_dir_entry *pro
 
 static inline void proc_set_size(struct proc_dir_entry *de, loff_t size) {}
 static inline void proc_set_user(struct proc_dir_entry *de, kuid_t uid, kgid_t gid) {}
-static inline void *PDE_DATA(const struct inode *inode) {BUG(); return NULL;}
 static inline void *proc_get_parent_data(const struct inode *inode) { BUG(); return NULL; }
 
 static inline void proc_remove(struct proc_dir_entry *de) {}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-slab-make-slab-iterator-functions-static.patch
mm-memcontrol-make-cgroup_memory_nokmem-static.patch
fs-proc-store-pde-data-into-inode-i_private.patch
fs-proc-replace-pde_datainode-with-inode-i_private.patch
fs-proc-remove-pde_data.patch
fs-proc-use-define_proc_show_attribute-to-simplify-the-code.patch

