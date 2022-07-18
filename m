Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B141CCA481
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbiGRAdf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbiGRAdJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:33:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D009214D25
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CC5B60FC0
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE70DC341C0;
        Mon, 18 Jul 2022 00:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104371;
        bh=wD7O28c1uDKDjbvLS1KTmVUhJVcDXA8gv5qM92WNybw=;
        h=Date:To:From:Subject:From;
        b=wRFl7vQwVt/H4wPPat4pEnhvyHpywPd+HLf7eU4ZAsWLDL3yAOF0KyhSOu/3YQx0k
         i9L53r2tkevFipp6uisZ6XV42agcnOhhyOQEsuCkNnnu5VInGfwL8jbL/y/U7gKu/z
         m34VSh9v+y/fiezqU0INTEdewl0vOg+YlMh9gUIk=
Date:   Sun, 17 Jul 2022 17:32:51 -0700
To:     mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk,
        miklos@szeredi.hu, dhowells@redhat.com, raven@themaw.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] autofs-remove-unused-ino-field-inode.patch removed from -mm tree
Message-Id: <20220718003251.BE70DC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: autofs: remove unused ino field inode
has been removed from the -mm tree.  Its filename was
     autofs-remove-unused-ino-field-inode.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs: remove unused ino field inode
Date: Fri, 08 Jul 2022 09:43:23 +0800

Remove the unused inode field of the autofs dentry info structure.

Link: https://lkml.kernel.org/r/165724460393.30914.6511330213821246793.stgit@donald.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/autofs_i.h |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/autofs/autofs_i.h~autofs-remove-unused-ino-field-inode
+++ a/fs/autofs/autofs_i.h
@@ -51,8 +51,6 @@ extern struct file_system_type autofs_fs
  */
 struct autofs_info {
 	struct dentry	*dentry;
-	struct inode	*inode;
-
 	int		flags;
 
 	struct completion expire_complete;
_

Patches currently in -mm which might be from raven@themaw.net are


