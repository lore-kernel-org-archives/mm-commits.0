From: akpm@linux-foundation.org
Subject: - autofs4-detect-invalid-direct-mount-requests.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:29:34 -0700
Message-ID: <200807242329.m6ONTYDO011391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756825AbYGXX3z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     autofs4: detect invalid direct mount requests
has been removed from the -mm tree.  Its filename was
     autofs4-detect-invalid-direct-mount-requests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: detect invalid direct mount requests
From: Ian Kent <raven@themaw.net>

autofs v5 direct and offset mounts within an autofs filesystem are
triggered by existing autofs triger mounts so the mount point dentry must
be positive.  If the mount point dentry is negative then the trigger
doesn't exist so we can return fail immediately.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/waitq.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/autofs4/waitq.c~autofs4-detect-invalid-direct-mount-requests fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-detect-invalid-direct-mount-requests
+++ a/fs/autofs4/waitq.c
@@ -328,6 +328,10 @@ int autofs4_wait(struct autofs_sb_info *
 	if (sbi->catatonic)
 		return -ENOENT;
 
+	if (!dentry->d_inode &&
+	    (sbi->type & (AUTOFS_TYPE_DIRECT | AUTOFS_TYPE_OFFSET)))
+		return -ENOENT;
+
 	name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
 	if (!name)
 		return -ENOMEM;
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch

