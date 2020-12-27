Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBBE7C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 27 Dec 2020 22:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F3132242A
	for <mm-commits@archiver.kernel.org>; Sun, 27 Dec 2020 22:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgL0WeX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Dec 2020 17:34:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:43774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgL0WeW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 27 Dec 2020 17:34:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B29DA2242A;
        Sun, 27 Dec 2020 22:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609108421;
        bh=hFaOEjGLcmqB3ncJoiJ0GvipXhTKB9/VBqQ6Li8Yz/Y=;
        h=Date:From:To:Subject:From;
        b=VA8CAvSlVPcv2F9hGBpNqS8ZIsFso0dM1OXy8xNj6jHAC8sIyqFX1lYNjW1gUc+j8
         bLwW0ge1AXwO9YcMNOfXyTqSMBQJ00qMDZfikgr/F7oicllRflhUT8rIJTvBnnmPEL
         c6HAl2l1voiCBp+pEg7qYkeJbXOSQAzWT1DXXsBk=
Date:   Sun, 27 Dec 2020 14:33:41 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, rdunlap@infradead.org
Subject:  + fs-delete-repeated-words-in-comments.patch added to -mm
 tree
Message-ID: <20201227223341.rhZGV%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: delete repeated words in comments
has been added to the -mm tree.  Its filename is
     fs-delete-repeated-words-in-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-delete-repeated-words-in-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-delete-repeated-words-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: fs: delete repeated words in comments

Delete duplicate words in fs/*.c.
The doubled words that are being dropped are:
  that, be, the, in, and, for

Link: https://lkml.kernel.org/r/20201224052810.25315-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    2 +-
 fs/dcache.c    |    4 ++--
 fs/direct-io.c |    4 ++--
 fs/exec.c      |    4 ++--
 fs/fhandle.c   |    2 +-
 fs/pipe.c      |    2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

--- a/fs/block_dev.c~fs-delete-repeated-words-in-comments
+++ a/fs/block_dev.c
@@ -1260,7 +1260,7 @@ rescan:
 	return ret;
 }
 /*
- * Only exported for for loop and dasd for historic reasons.  Don't use in new
+ * Only exported for loop and dasd for historic reasons.  Don't use in new
  * code!
  */
 EXPORT_SYMBOL_GPL(bdev_disk_changed);
--- a/fs/dcache.c~fs-delete-repeated-words-in-comments
+++ a/fs/dcache.c
@@ -2150,8 +2150,8 @@ EXPORT_SYMBOL(d_obtain_root);
  * same inode, only the actual correct case is stored in the dcache for
  * case-insensitive filesystems.
  *
- * For a case-insensitive lookup match and if the the case-exact dentry
- * already exists in in the dcache, use it and return it.
+ * For a case-insensitive lookup match and if the case-exact dentry
+ * already exists in the dcache, use it and return it.
  *
  * If no entry exists with the exact case name, allocate new dentry with
  * the exact case, and return the spliced entry.
--- a/fs/direct-io.c~fs-delete-repeated-words-in-comments
+++ a/fs/direct-io.c
@@ -460,7 +460,7 @@ static inline void dio_cleanup(struct di
  * Wait for the next BIO to complete.  Remove it and return it.  NULL is
  * returned once all BIOs have been completed.  This must only be called once
  * all bios have been issued so that dio->refcount can only decrease.  This
- * requires that that the caller hold a reference on the dio.
+ * requires that the caller hold a reference on the dio.
  */
 static struct bio *dio_await_one(struct dio *dio)
 {
@@ -1277,7 +1277,7 @@ do_blockdev_direct_IO(struct kiocb *iocb
 	if (retval == -ENOTBLK) {
 		/*
 		 * The remaining part of the request will be
-		 * be handled by buffered I/O when we return
+		 * handled by buffered I/O when we return
 		 */
 		retval = 0;
 	}
--- a/fs/exec.c~fs-delete-repeated-words-in-comments
+++ a/fs/exec.c
@@ -1454,7 +1454,7 @@ EXPORT_SYMBOL(finalize_exec);
 /*
  * Prepare credentials and lock ->cred_guard_mutex.
  * setup_new_exec() commits the new creds and drops the lock.
- * Or, if exec fails before, free_bprm() should release ->cred and
+ * Or, if exec fails before, free_bprm() should release ->cred
  * and unlock.
  */
 static int prepare_bprm_creds(struct linux_binprm *bprm)
@@ -1837,7 +1837,7 @@ static int bprm_execve(struct linux_binp
 
 out:
 	/*
-	 * If past the point of no return ensure the the code never
+	 * If past the point of no return ensure the code never
 	 * returns to the userspace process.  Use an existing fatal
 	 * signal if present otherwise terminate the process with
 	 * SIGSEGV.
--- a/fs/fhandle.c~fs-delete-repeated-words-in-comments
+++ a/fs/fhandle.c
@@ -173,7 +173,7 @@ static int handle_to_path(int mountdirfd
 
 	/*
 	 * With handle we don't look at the execute bit on the
-	 * the directory. Ideally we would like CAP_DAC_SEARCH.
+	 * directory. Ideally we would like CAP_DAC_SEARCH.
 	 * But we don't have that
 	 */
 	if (!capable(CAP_DAC_READ_SEARCH)) {
--- a/fs/pipe.c~fs-delete-repeated-words-in-comments
+++ a/fs/pipe.c
@@ -171,7 +171,7 @@ EXPORT_SYMBOL(generic_pipe_buf_try_steal
  *
  * Description:
  *	This function grabs an extra reference to @buf. It's used in
- *	in the tee() system call, when we duplicate the buffers in one
+ *	the tee() system call, when we duplicate the buffers in one
  *	pipe into another.
  */
 bool generic_pipe_buf_get(struct pipe_inode_info *pipe, struct pipe_buffer *buf)
_

Patches currently in -mm which might be from rdunlap@infradead.org are

zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc.patch
zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc-fix.patch
local64h-make-asm-local64h-mandatory.patch
fs-delete-repeated-words-in-comments.patch
mm-zswap-clean-up-confusing-comment.patch
lib-linear_ranges-fix-repeated-words-one-typo.patch

