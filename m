Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA7DAC433DB
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0B7A6191C
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhC1WP2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 18:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231258AbhC1WPZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 18:15:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB0FF6191C;
        Sun, 28 Mar 2021 22:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616969724;
        bh=xczpk5X31HQ60yzsUJSyeXNnV7d5vCf2Wwh7q8LeVtM=;
        h=Date:From:To:Subject:From;
        b=vybYpeyCH6YjB+KmJMdyG4pwgeyujKke0Yi3KCK8DElCeZ5vuWAMQLrUK2oVv9Xrl
         L4vwak+Zt1eC5GR+bwCxPCrMSDkfmQ9ft3s8GmQ5NRGAVnJkrcgD7g+lD5SEw5KVX7
         1QyTA88owSx0pq80K4sK4Q7H++Z3F0Gj+WVAj+sg=
Date:   Sun, 28 Mar 2021 15:15:24 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org
Subject:  + proc-mandate-proc_lseek-in-struct-proc_ops.patch added
 to -mm tree
Message-ID: <20210328221524.ukfuztGsl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: mandate ->proc_lseek in "struct proc_ops"
has been added to the -mm tree.  Its filename is
     proc-mandate-proc_lseek-in-struct-proc_ops.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-mandate-proc_lseek-in-struct-proc_ops.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-mandate-proc_lseek-in-struct-proc_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: mandate ->proc_lseek in "struct proc_ops"

Now that proc_ops are separate from file_operations and other operations
it easy to check all instances to have ->proc_lseek hook and remove check
in main code.

Note:
nonseekable_open() files naturally don't require ->proc_lseek.

Garbage collect pde_lseek() function.

Link: https://lkml.kernel.org/r/YFYX0Bzwxlc7aBa/@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/kcapi_proc.c                     |    1 
 drivers/net/wireless/intersil/hostap/hostap_proc.c |    1 
 drivers/scsi/esas2r/esas2r_main.c                  |    1 
 fs/proc/inode.c                                    |   14 +----------
 include/linux/proc_fs.h                            |    1 
 5 files changed, 6 insertions(+), 12 deletions(-)

--- a/drivers/isdn/capi/kcapi_proc.c~proc-mandate-proc_lseek-in-struct-proc_ops
+++ a/drivers/isdn/capi/kcapi_proc.c
@@ -201,6 +201,7 @@ static ssize_t empty_read(struct file *f
 
 static const struct proc_ops empty_proc_ops = {
 	.proc_read	= empty_read,
+	.proc_lseek	= default_llseek,
 };
 
 // ---------------------------------------------------------------------------
--- a/drivers/net/wireless/intersil/hostap/hostap_proc.c~proc-mandate-proc_lseek-in-struct-proc_ops
+++ a/drivers/net/wireless/intersil/hostap/hostap_proc.c
@@ -227,6 +227,7 @@ static ssize_t prism2_aux_dump_proc_no_r
 
 static const struct proc_ops prism2_aux_dump_proc_ops = {
 	.proc_read	= prism2_aux_dump_proc_no_read,
+	.proc_lseek	= default_llseek,
 };
 
 
--- a/drivers/scsi/esas2r/esas2r_main.c~proc-mandate-proc_lseek-in-struct-proc_ops
+++ a/drivers/scsi/esas2r/esas2r_main.c
@@ -617,6 +617,7 @@ static const struct file_operations esas
 };
 
 static const struct proc_ops esas2r_proc_ops = {
+	.proc_lseek		= default_llseek,
 	.proc_ioctl		= esas2r_proc_ioctl,
 #ifdef CONFIG_COMPAT
 	.proc_compat_ioctl	= compat_ptr_ioctl,
--- a/fs/proc/inode.c~proc-mandate-proc_lseek-in-struct-proc_ops
+++ a/fs/proc/inode.c
@@ -273,25 +273,15 @@ void proc_entry_rundown(struct proc_dir_
 	spin_unlock(&de->pde_unload_lock);
 }
 
-static loff_t pde_lseek(struct proc_dir_entry *pde, struct file *file, loff_t offset, int whence)
-{
-	typeof_member(struct proc_ops, proc_lseek) lseek;
-
-	lseek = pde->proc_ops->proc_lseek;
-	if (!lseek)
-		lseek = default_llseek;
-	return lseek(file, offset, whence);
-}
-
 static loff_t proc_reg_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	loff_t rv = -EINVAL;
 
 	if (pde_is_permanent(pde)) {
-		return pde_lseek(pde, file, offset, whence);
+		return pde->proc_ops->proc_lseek(file, offset, whence);
 	} else if (use_pde(pde)) {
-		rv = pde_lseek(pde, file, offset, whence);
+		rv = pde->proc_ops->proc_lseek(file, offset, whence);
 		unuse_pde(pde);
 	}
 	return rv;
--- a/include/linux/proc_fs.h~proc-mandate-proc_lseek-in-struct-proc_ops
+++ a/include/linux/proc_fs.h
@@ -32,6 +32,7 @@ struct proc_ops {
 	ssize_t	(*proc_read)(struct file *, char __user *, size_t, loff_t *);
 	ssize_t (*proc_read_iter)(struct kiocb *, struct iov_iter *);
 	ssize_t	(*proc_write)(struct file *, const char __user *, size_t, loff_t *);
+	/* mandatory unless nonseekable_open() or equivalent is used */
 	loff_t	(*proc_lseek)(struct file *, loff_t, int);
 	int	(*proc_release)(struct inode *, struct file *);
 	__poll_t (*proc_poll)(struct file *, struct poll_table_struct *);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-mandate-proc_lseek-in-struct-proc_ops.patch
proc-delete-redundant-subset=pid-check.patch
proc-test-subset=pid.patch

