Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE20C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AB1261289
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbhEGBDR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:03:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233982AbhEGBDQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:03:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78706611ED;
        Fri,  7 May 2021 01:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349336;
        bh=/Scj3jTXyxO/Ty9xjsH7YrSb6DO0PkfL0dEKyTTBGm0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qB3wfEh3Uyg94IaUJxw8dDffuOQ8ykJ6ZQ7GzNFAeMJl2dpFewxo0evSScp+HFyi2
         MsLz199HOJ+Ewak8cdae5O7Guqph1uTKXyFtPRmznH23rVUQ29mM2RS6SBoBxor7nO
         pm4499PvNgtyNwy14o1UrWx9xNNVf+t2fEnoTlW4=
Date:   Thu, 06 May 2021 18:02:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 05/91] proc: mandate ->proc_lseek in "struct
 proc_ops"
Message-ID: <20210507010216.Q_Od6LaA1%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: mandate ->proc_lseek in "struct proc_ops"

Now that proc_ops are separate from file_operations and other operations
it easy to check all instances to have ->proc_lseek hook and remove check
in main code.

Note:
nonseekable_open() files naturally don't require ->proc_lseek.

Garbage collect pde_lseek() function.

[adobriyan@gmail.com: smoke test lseek()]
  Link: https://lkml.kernel.org/r/YG4OIhChOrVTPgdN@localhost.localdomain
Link: https://lkml.kernel.org/r/YFYX0Bzwxlc7aBa/@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/kcapi_proc.c                     |    1 
 drivers/net/wireless/intersil/hostap/hostap_proc.c |    1 
 drivers/scsi/esas2r/esas2r_main.c                  |    1 
 fs/proc/inode.c                                    |   14 +----------
 include/linux/proc_fs.h                            |    1 
 tools/testing/selftests/proc/read.c                |    4 ++-
 6 files changed, 9 insertions(+), 13 deletions(-)

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
@@ -616,6 +616,7 @@ static const struct file_operations esas
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
--- a/tools/testing/selftests/proc/read.c~proc-mandate-proc_lseek-in-struct-proc_ops
+++ a/tools/testing/selftests/proc/read.c
@@ -14,7 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 // Test
-// 1) read of every file in /proc
+// 1) read and lseek on every file in /proc
 // 2) readlink of every symlink in /proc
 // 3) recursively (1) + (2) for every directory in /proc
 // 4) write to /proc/*/clear_refs and /proc/*/task/*/clear_refs
@@ -45,6 +45,8 @@ static void f_reg(DIR *d, const char *fi
 	fd = openat(dirfd(d), filename, O_RDONLY|O_NONBLOCK);
 	if (fd == -1)
 		return;
+	/* struct proc_ops::proc_lseek is mandatory if file is seekable. */
+	(void)lseek(fd, 0, SEEK_SET);
 	rv = read(fd, buf, sizeof(buf));
 	assert((0 <= rv && rv <= sizeof(buf)) || rv == -1);
 	close(fd);
_
