Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C68A5C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiJCVaW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiJCV3w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:29:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123D4578BA
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:22:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7913CCE0E7C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6B8C433B5;
        Mon,  3 Oct 2022 21:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664832155;
        bh=DcQp8nXO2PbWmTxcwARZdYiohQXlU9DkUfZfUeUI36Y=;
        h=Date:To:From:Subject:From;
        b=LzVnNovfk5HcJuEmfB1Err49ZjIkDBz78JdqXgY7GoNafonLCcU9FQ8MfYOtKpnEw
         zZapOpWOF3/jPlKtOMnfQekkI3lRvLHnMyiBL3C7rgaNRwzu5g7R0zkD2qiwJq5mwn
         0dwrpJz51pykgsX09KzbtuR8rcFyUSQJR1Fpu8IQ=
Date:   Mon, 03 Oct 2022 14:22:34 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        jlayton@kernel.org, hughd@google.com, chuck.lever@oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-uninline-inode_maybe_inc_iversion.patch removed from -mm tree
Message-Id: <20221003212234.DA6B8C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs: uninline inode_maybe_inc_iversion()
has been removed from the -mm tree.  Its filename was
     fs-uninline-inode_maybe_inc_iversion.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs: uninline inode_maybe_inc_iversion()
Date: Fri Sep  9 01:57:41 PM PDT 2022

It has many callsites and is large.

   text	   data	    bss	    dec	    hex	filename
  91796	  15984	    512	 108292	  1a704	mm/shmem.o-before
  91180	  15984	    512	 107676	  1a49c	mm/shmem.o-after

Acked-by: Jeff Layton <jlayton@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c               |   46 +++++++++++++++++++++++++++++++++++++
 include/linux/iversion.h |   46 -------------------------------------
 2 files changed, 47 insertions(+), 45 deletions(-)

--- a/fs/libfs.c~fs-uninline-inode_maybe_inc_iversion
+++ a/fs/libfs.c
@@ -15,6 +15,7 @@
 #include <linux/mutex.h>
 #include <linux/namei.h>
 #include <linux/exportfs.h>
+#include <linux/iversion.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h> /* sync_mapping_buffers */
 #include <linux/fs_context.h>
@@ -1520,3 +1521,48 @@ void generic_set_encrypted_ci_d_ops(stru
 #endif
 }
 EXPORT_SYMBOL(generic_set_encrypted_ci_d_ops);
+
+/**
+ * inode_maybe_inc_iversion - increments i_version
+ * @inode: inode with the i_version that should be updated
+ * @force: increment the counter even if it's not necessary?
+ *
+ * Every time the inode is modified, the i_version field must be seen to have
+ * changed by any observer.
+ *
+ * If "force" is set or the QUERIED flag is set, then ensure that we increment
+ * the value, and clear the queried flag.
+ *
+ * In the common case where neither is set, then we can return "false" without
+ * updating i_version.
+ *
+ * If this function returns false, and no other metadata has changed, then we
+ * can avoid logging the metadata.
+ */
+bool inode_maybe_inc_iversion(struct inode *inode, bool force)
+{
+	u64 cur, new;
+
+	/*
+	 * The i_version field is not strictly ordered with any other inode
+	 * information, but the legacy inode_inc_iversion code used a spinlock
+	 * to serialize increments.
+	 *
+	 * Here, we add full memory barriers to ensure that any de-facto
+	 * ordering with other info is preserved.
+	 *
+	 * This barrier pairs with the barrier in inode_query_iversion()
+	 */
+	smp_mb();
+	cur = inode_peek_iversion_raw(inode);
+	do {
+		/* If flag is clear then we needn't do anything */
+		if (!force && !(cur & I_VERSION_QUERIED))
+			return false;
+
+		/* Since lowest bit is flag, add 2 to avoid it */
+		new = (cur & ~I_VERSION_QUERIED) + I_VERSION_INCREMENT;
+	} while (!atomic64_try_cmpxchg(&inode->i_version, &cur, new));
+	return true;
+}
+EXPORT_SYMBOL(inode_maybe_inc_iversion);
--- a/include/linux/iversion.h~fs-uninline-inode_maybe_inc_iversion
+++ a/include/linux/iversion.h
@@ -172,51 +172,7 @@ inode_set_iversion_queried(struct inode
 				I_VERSION_QUERIED);
 }
 
-/**
- * inode_maybe_inc_iversion - increments i_version
- * @inode: inode with the i_version that should be updated
- * @force: increment the counter even if it's not necessary?
- *
- * Every time the inode is modified, the i_version field must be seen to have
- * changed by any observer.
- *
- * If "force" is set or the QUERIED flag is set, then ensure that we increment
- * the value, and clear the queried flag.
- *
- * In the common case where neither is set, then we can return "false" without
- * updating i_version.
- *
- * If this function returns false, and no other metadata has changed, then we
- * can avoid logging the metadata.
- */
-static inline bool
-inode_maybe_inc_iversion(struct inode *inode, bool force)
-{
-	u64 cur, new;
-
-	/*
-	 * The i_version field is not strictly ordered with any other inode
-	 * information, but the legacy inode_inc_iversion code used a spinlock
-	 * to serialize increments.
-	 *
-	 * Here, we add full memory barriers to ensure that any de-facto
-	 * ordering with other info is preserved.
-	 *
-	 * This barrier pairs with the barrier in inode_query_iversion()
-	 */
-	smp_mb();
-	cur = inode_peek_iversion_raw(inode);
-	do {
-		/* If flag is clear then we needn't do anything */
-		if (!force && !(cur & I_VERSION_QUERIED))
-			return false;
-
-		/* Since lowest bit is flag, add 2 to avoid it */
-		new = (cur & ~I_VERSION_QUERIED) + I_VERSION_INCREMENT;
-	} while (!atomic64_try_cmpxchg(&inode->i_version, &cur, new));
-	return true;
-}
-
+bool inode_maybe_inc_iversion(struct inode *inode, bool force);
 
 /**
  * inode_inc_iversion - forcibly increment i_version
_

Patches currently in -mm which might be from akpm@linux-foundation.org are


