Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B1CCCA485
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiGRAdf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbiGRAdJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:33:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD13114D12
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A4DF60F4A
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2598C3411E;
        Mon, 18 Jul 2022 00:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104370;
        bh=26QoFQJkE1i0V6rQ5IsEKxAFPd9MV11dcGaHt9hWwDw=;
        h=Date:To:From:Subject:From;
        b=KupEzQIbo03nV7f/1IDE2nJEWElshERZ/E6kzuKE43shlliv3ExPVuRKcbnHMACvQ
         GSQtlNj76oftl2mRZxSnpR9fGoXQ3XUkkn2083blNG60ya3KEFJ5K78h8vKwqky8A/
         /MSf4CIreIrhOWGUImwria8aaiMLUxVXH3w9VRbY=
Date:   Sun, 17 Jul 2022 17:32:50 -0700
To:     mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk,
        miklos@szeredi.hu, dhowells@redhat.com, raven@themaw.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] autofs-add-comment-about-autofs_mountpoint_changed.patch removed from -mm tree
Message-Id: <20220718003250.C2598C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: autofs: add comment about autofs_mountpoint_changed()
has been removed from the -mm tree.  Its filename was
     autofs-add-comment-about-autofs_mountpoint_changed.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs: add comment about autofs_mountpoint_changed()
Date: Fri, 08 Jul 2022 09:43:18 +0800

The function autofs_mountpoint_changed() is unusual, add a comment about
two cases for which it is needed.

Link: https://lkml.kernel.org/r/165724459804.30914.10974834416046555127.stgit@donald.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/root.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/fs/autofs/root.c~autofs-add-comment-about-autofs_mountpoint_changed
+++ a/fs/autofs/root.c
@@ -291,9 +291,26 @@ static struct dentry *autofs_mountpoint_
 	struct dentry *dentry = path->dentry;
 	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
 
-	/*
-	 * If this is an indirect mount the dentry could have gone away
-	 * as a result of an expire and a new one created.
+	/* If this is an indirect mount the dentry could have gone away
+	 * and a new one created.
+	 *
+	 * This is unusual and I can't remember the case for which it
+	 * was originally added now. But an example of how this can
+	 * happen is an autofs indirect mount that has the "browse"
+	 * option set and also has the "symlink" option in the autofs
+	 * map entry. In this case the daemon will remove the browse
+	 * directory and create a symlink as the mount leaving the
+	 * struct path stale.
+	 *
+	 * Another not so obvious case is when a mount in an autofs
+	 * indirect mount that uses the "nobrowse" option is being
+	 * expired at the same time as a path walk. If the mount has
+	 * been umounted but the mount point directory seen before
+	 * becoming unhashed (during a lockless path walk) when a stat
+	 * family system call is made the mount won't be re-mounted as
+	 * it should. In this case the mount point that's been removed
+	 * (by the daemon) will be stale and the a new mount point
+	 * dentry created.
 	 */
 	if (autofs_type_indirect(sbi->type) && d_unhashed(dentry)) {
 		struct dentry *parent = dentry->d_parent;
_

Patches currently in -mm which might be from raven@themaw.net are


