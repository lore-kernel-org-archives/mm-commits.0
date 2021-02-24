Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60457C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 209BD64E2B
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbhBXUCc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:02:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235136AbhBXUCK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0608D64F18;
        Wed, 24 Feb 2021 20:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196849;
        bh=89S/3DP/jXqKVG70oQMz27dwJmzmZuhNqPwHhZvwuFk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZnHn4RkM4NwMBpCs3LCs++zBAIGErFQcHgb0oZBhOtxOWnRJX/nAs2KzjiTcsjtYa
         57Gyyf4VeruoVfjlHIhS+vjLDnozO7T3v0D6aSt+beRpVHPQdylub1F63dqAFG3kXb
         WClN09sTMRS02HiKr+j/aEs1ZU5uG88UuanLsVso=
Date:   Wed, 24 Feb 2021 12:00:48 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [patch 012/173] fs: delete repeated words in comments
Message-ID: <20210224200048.4ZoIcq1Pf%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -1270,7 +1270,7 @@ rescan:
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
@@ -2176,8 +2176,8 @@ EXPORT_SYMBOL(d_obtain_root);
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
@@ -462,7 +462,7 @@ static inline void dio_cleanup(struct di
  * Wait for the next BIO to complete.  Remove it and return it.  NULL is
  * returned once all BIOs have been completed.  This must only be called once
  * all bios have been issued so that dio->refcount can only decrease.  This
- * requires that that the caller hold a reference on the dio.
+ * requires that the caller hold a reference on the dio.
  */
 static struct bio *dio_await_one(struct dio *dio)
 {
@@ -1279,7 +1279,7 @@ do_blockdev_direct_IO(struct kiocb *iocb
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
@@ -1455,7 +1455,7 @@ EXPORT_SYMBOL(finalize_exec);
 /*
  * Prepare credentials and lock ->cred_guard_mutex.
  * setup_new_exec() commits the new creds and drops the lock.
- * Or, if exec fails before, free_bprm() should release ->cred and
+ * Or, if exec fails before, free_bprm() should release ->cred
  * and unlock.
  */
 static int prepare_bprm_creds(struct linux_binprm *bprm)
@@ -1841,7 +1841,7 @@ static int bprm_execve(struct linux_binp
 
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
