Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C99C4332F
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:14:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiAVGOW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233005AbiAVGOW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:14:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00840C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:14:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9368860FB0
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA266C004E1;
        Sat, 22 Jan 2022 06:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832061;
        bh=FwOaahKxnLQfUoTS7NSSqTh8/NdIS5m4lBZ7wtW3vUs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bqLbufOVSLND9KPzG7gck6I8tslgWttpL7Ow/fZLuatf1JOE5D+iR8GJI9OftTIkf
         /WNdzBAClcEGp19BX2nMLrmlFufXckiTlZhbH/t2TyfKRLbrK0qkmAnbj3LCsKsxmG
         n0JSyAZ77PsChat8WaL0YM2CjxkBC7JZNtHOxzLs=
Date:   Fri, 21 Jan 2022 22:14:20 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        christian.brauner@ubuntu.com, gladkov.alexey@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, torvalds@linux-foundation.org
Subject:  [patch 53/69] fs: proc: store PDE()->data into
 inode->i_private
Message-ID: <20220122061420.re6CYbW_S%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
