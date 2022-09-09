Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F785ECAAD3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 21:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiIIVIW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 17:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbiIIVIF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 17:08:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE847115CC6
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 14:08:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB69AB8261C
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 21:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5CDC433D6;
        Fri,  9 Sep 2022 21:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662757681;
        bh=CmRWjwqsA879VQKrgfOb7Ykz6zohA21cyaYetineNQQ=;
        h=Date:To:From:Subject:From;
        b=s9WCj8/jtfmGnKZ5pT7T4DNZDOKV5Q8CjuEUeDvDqBGHkP8f59j1sV8Pki3065/cu
         6NigJTCjQWWhGIbOilgwr+gpYoI1nefLJnW6q7sX7mbXv4Q5HY7oCDzkQW4aglw85W
         ubtgwM/bo0OOgfLxKWY/7/AiGxMDAYq/W7un/TM4=
Date:   Fri, 09 Sep 2022 14:08:00 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        jlayton@kernel.org, hughd@google.com, chuck.lever@oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-uninline-inode_maybe_inc_iversion.patch added to mm-nonmm-unstable branch
Message-Id: <20220909210801.5C5CDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs> uninline inode_maybe_inc_iversion()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-uninline-inode_maybe_inc_iversion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-uninline-inode_maybe_inc_iversion.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs> uninline inode_maybe_inc_iversion()
Date: Fri Sep  9 01:57:41 PM PDT 2022

It has many callsites and is large.

   text	   data	    bss	    dec	    hex	filename
  91796	  15984	    512	 108292	  1a704	mm/shmem.o-before
  91180	  15984	    512	 107676	  1a49c	mm/shmem.o-after

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c               |   46 +++++++++++++++++++++++++++++++++++++
 include/linux/iversion.h |   46 -------------------------------------
 2 files changed, 47 insertions(+), 45 deletions(-)

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
@@ -1529,3 +1530,48 @@ void generic_set_encrypted_ci_d_ops(stru
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
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-fix.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
page_ext-introduce-boot-parameter-early_page_ext-fix.patch
mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch
add-sicode-to-proc-pid-stat-fix.patch
fs-uninline-inode_maybe_inc_iversion.patch

