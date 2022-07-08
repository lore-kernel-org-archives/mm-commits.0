Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C2A5C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 20:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240219AbiGHUgI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 16:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240167AbiGHUgA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 16:36:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76E1CDA
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 13:35:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CE67B8296A
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 20:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D100C341C0;
        Fri,  8 Jul 2022 20:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657312555;
        bh=iNpxwjwDOBJ1Pg7GBIBGPubgwBKSTsDOKbkuDbYlpmM=;
        h=Date:To:From:Subject:From;
        b=HBldhGSWWzooCNJdANRJa4E+6NlEAXYm4W07gwtPga/MbOl5lWI9n3jqqRBqu9WXH
         UXF9n+1A+0P1AFq/qLvd5ckS1fz2x3xa7zPI2B+k1/SewlwBqpbBJS3IdnOqmqmxwh
         yVjHh6ES7hvBNeDoIaRb6V0aLs2rw0U8KuT9xldU=
Date:   Fri, 08 Jul 2022 13:35:54 -0700
To:     mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk,
        miklos@szeredi.hu, dhowells@redhat.com, raven@themaw.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + autofs-add-comment-about-autofs_mountpoint_changed.patch added to mm-nonmm-unstable branch
Message-Id: <20220708203555.2D100C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: add comment about autofs_mountpoint_changed()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     autofs-add-comment-about-autofs_mountpoint_changed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/autofs-add-comment-about-autofs_mountpoint_changed.patch

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

autofs-use-inode-permission-method-for-write-access.patch
autofs-make-dentry-info-count-consistent.patch
autofs-use-dentry-info-count-instead-of-simple_empty.patch
autofs-add-comment-about-autofs_mountpoint_changed.patch
autofs-remove-unused-ino-field-inode.patch

