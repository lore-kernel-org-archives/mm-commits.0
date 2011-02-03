From: akpm@linux-foundation.org
Subject: + fs-devpts-inodec-correctly-check-d_alloc_name-return-code-in-devpts_pty_new.patch added to -mm tree
Date: Thu, 03 Feb 2011 15:33:28 -0800
Message-ID: <201102032333.p13NXSgq031345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754193Ab1BCXdb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 18:33:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avagin@openvz.org


The patch titled
     fs/devpts/inode.c: correctly check d_alloc_name() return code in devpts_pty_new()
has been added to the -mm tree.  Its filename is
     fs-devpts-inodec-correctly-check-d_alloc_name-return-code-in-devpts_pty_new.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/devpts/inode.c: correctly check d_alloc_name() return code in devpts_pty_new()
From: Andrey Vagin <avagin@openvz.org>

d_alloc_name return NULL in case error, but we expect errno in
devpts_pty_new.

Addresses http://bugzilla.openvz.org/show_bug.cgi?id=1758

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/devpts/inode.c~fs-devpts-inodec-correctly-check-d_alloc_name-return-code-in-devpts_pty_new fs/devpts/inode.c
--- a/fs/devpts/inode.c~fs-devpts-inodec-correctly-check-d_alloc_name-return-code-in-devpts_pty_new
+++ a/fs/devpts/inode.c
@@ -501,7 +501,7 @@ int devpts_pty_new(struct inode *ptmx_in
 	mutex_lock(&root->d_inode->i_mutex);
 
 	dentry = d_alloc_name(root, s);
-	if (!IS_ERR(dentry)) {
+	if (dentry) {
 		d_add(dentry, inode);
 		fsnotify_create(root->d_inode, dentry);
 	}
_

Patches currently in -mm which might be from avagin@openvz.org are

fs-devpts-inodec-correctly-check-d_alloc_name-return-code-in-devpts_pty_new.patch

