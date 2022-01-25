Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 097D0C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 03:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240995AbiAYDq3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 22:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415829AbiAYBwW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 20:52:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2090AC09B046
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 17:15:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0E6961208
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 01:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66F6C340E4;
        Tue, 25 Jan 2022 01:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643073320;
        bh=ZdS1LXgngzQr7jwpJreT/Ch1VG/4TGUuTVl4tn0AOTw=;
        h=Date:From:To:Subject:From;
        b=hcFkwk4CqXyCiRLBqNlzczY5hsTrN318o6u/W7iEPFNUyTb6zs/0c8OjZN7yawp6U
         ogKWxVZ6TJITl23TXzkW/faDLqihoCa9D+CQFVM4F1O3qfwz3pyZ1LGM2XZ73Njm+V
         rSwnJ5IixTK4vwT9uvcwaoRLUCNLgjnftUL1KtNI=
Date:   Mon, 24 Jan 2022 17:15:19 -0800
From:   akpm@linux-foundation.org
To:     dave@stgolabs.net, dhowells@redhat.com, longman@redhat.com,
        manfred@colorfullife.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  + ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch
 added to -mm tree
Message-ID: <20220125011519.T2EyhsPPg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue: use get_tree_nodev() in mqueue_get_tree()
has been added to the -mm tree.  Its filename is
     ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

After testing with added instrumentation code, it was found that the the
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

ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch

