Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C1FC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbiEJEZb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236240AbiEJEYs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:24:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66C14C413
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C743B81AFD
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40062C385C5;
        Tue, 10 May 2022 04:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156289;
        bh=vHmqCgVU1/qkAH2c91OalmWVcVXbUdgvDVaqfeyPhl8=;
        h=Date:To:From:Subject:From;
        b=PUuRH6B4uZIgBJaq23I3B3Qfzs9m9ZBplPpxsZ98d+h7qzHKPIwRYoXSJIoL8mV+z
         zlQ/XTmy8r8FhLm4M97rPiUwT6s+VwKpdwHxuRhLLjo3rfakz7d+JMVfOSCdbK12wR
         qNEYbgv/E4r8YiHO6YyRF31ciz7HL2SXNmO6WM8o=
Date:   Mon, 09 May 2022 21:18:08 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        manfred@colorfullife.com, dhowells@redhat.com, dave@stgolabs.net,
        longman@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch removed from -mm tree
Message-Id: <20220510041809.40062C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ipc/mqueue: use get_tree_nodev() in mqueue_get_tree()
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: ipc/mqueue: use get_tree_nodev() in mqueue_get_tree()

When running the stress-ng clone benchmark with multiple testing threads,
it was found that there were significant spinlock contention in sget_fc().
The contended spinlock was the sb_lock.  It is under heavy contention
because the following code in the critcal section of sget_fc():

  hlist_for_each_entry(old, &fc->fs_type->fs_supers, s_instances) {
      if (test(old, fc))
          goto share_extant_sb;
  }

After testing with added instrumentation code, it was found that the
benchmark could generate thousands of ipc namespaces with the
corresponding number of entries in the mqueue's fs_supers list where the
namespaces are the key for the search.  This leads to excessive time in
scanning the list for a match.

Looking back at the mqueue calling sequence leading to sget_fc():

  mq_init_ns()
  => mq_create_mount()
  => fc_mount()
  => vfs_get_tree()
  => mqueue_get_tree()
  => get_tree_keyed()
  => vfs_get_super()
  => sget_fc()

Currently, mq_init_ns() is the only mqueue function that will indirectly
call mqueue_get_tree() with a newly allocated ipc namespace as the key for
searching.  As a result, there will never be a match with the exising ipc
namespaces stored in the mqueue's fs_supers list.

So using get_tree_keyed() to do an existing ipc namespace search is just a
waste of time.  Instead, we could use get_tree_nodev() to eliminate the
useless search.  By doing so, we can greatly reduce the sb_lock hold time
and avoid the spinlock contention problem in case a large number of ipc
namespaces are present.

Of course, if the code is modified in the future to allow
mqueue_get_tree() to be called with an existing ipc namespace instead of a
new one, we will have to use get_tree_keyed() in this case.

The following stress-ng clone benchmark command was run on a 2-socket
48-core Intel system:

./stress-ng --clone 32 --verbose --oomable --metrics-brief -t 20

The "bogo ops/s" increased from 5948.45 before patch to 9137.06 after
patch. This is an increase of 54% in performance.

Link: https://lkml.kernel.org/r/20220121172315.19652-1-longman@redhat.com
Fixes: 935c6912b198 ("ipc: Convert mqueue fs to fs_context")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/ipc/mqueue.c~ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree
+++ a/ipc/mqueue.c
@@ -45,6 +45,7 @@
 
 struct mqueue_fs_context {
 	struct ipc_namespace	*ipc_ns;
+	bool			 newns;	/* Set if newly created ipc namespace */
 };
 
 #define MQUEUE_MAGIC	0x19800202
@@ -427,6 +428,14 @@ static int mqueue_get_tree(struct fs_con
 {
 	struct mqueue_fs_context *ctx = fc->fs_private;
 
+	/*
+	 * With a newly created ipc namespace, we don't need to do a search
+	 * for an ipc namespace match, but we still need to set s_fs_info.
+	 */
+	if (ctx->newns) {
+		fc->s_fs_info = ctx->ipc_ns;
+		return get_tree_nodev(fc, mqueue_fill_super);
+	}
 	return get_tree_keyed(fc, mqueue_fill_super, ctx->ipc_ns);
 }
 
@@ -454,6 +463,10 @@ static int mqueue_init_fs_context(struct
 	return 0;
 }
 
+/*
+ * mq_init_ns() is currently the only caller of mq_create_mount().
+ * So the ns parameter is always a newly created ipc namespace.
+ */
 static struct vfsmount *mq_create_mount(struct ipc_namespace *ns)
 {
 	struct mqueue_fs_context *ctx;
@@ -465,6 +478,7 @@ static struct vfsmount *mq_create_mount(
 		return ERR_CAST(fc);
 
 	ctx = fc->fs_private;
+	ctx->newns = true;
 	put_ipc_ns(ctx->ipc_ns);
 	ctx->ipc_ns = get_ipc_ns(ns);
 	put_user_ns(fc->user_ns);
_

Patches currently in -mm which might be from longman@redhat.com are


