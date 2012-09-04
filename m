From: akpm@linux-foundation.org
Subject: + proc-no-need-to-initialize-proc_inode-fd-in-proc_get_inode.patch added to -mm tree
Date: Tue, 04 Sep 2012 15:49:50 -0700
Message-ID: <20120904224950.8D7491E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:47852 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab2IDWtv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Sep 2012 18:49:51 -0400
Received: by ghbz15 with SMTP id z15so788169ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Sep 2012 15:49:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clouds.yan@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: proc: no need to initialize proc_inode->fd in proc_get_inode()
has been added to the -mm tree.  Its filename is
     proc-no-need-to-initialize-proc_inode-fd-in-proc_get_inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: yan <clouds.yan@gmail.com>
Subject: proc: no need to initialize proc_inode->fd in proc_get_inode()

proc_get_inode() obtains the inode via a call to iget_locked(). 
iget_locked() calls alloc_inode() which will call proc_alloc_inode() which
clears proc_inode.fd, so there is no need to clear this field in
proc_get_inode().

If iget_locked() instead found the inode via find_inode_fast(), that inode
will not have I_NEW set so this change has no effect.

Signed-off-by: yan <clouds.yan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/proc/inode.c~proc-no-need-to-initialize-proc_inode-fd-in-proc_get_inode fs/proc/inode.c
--- a/fs/proc/inode.c~proc-no-need-to-initialize-proc_inode-fd-in-proc_get_inode
+++ a/fs/proc/inode.c
@@ -450,7 +450,6 @@ struct inode *proc_get_inode(struct supe
 		return NULL;
 	if (inode->i_state & I_NEW) {
 		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
-		PROC_I(inode)->fd = 0;
 		PROC_I(inode)->pde = de;
 
 		if (de->mode) {
_

Patches currently in -mm which might be from clouds.yan@gmail.com are

proc-return-enomem-when-inode-allocation-failed.patch
proc-no-need-to-initialize-proc_inode-fd-in-proc_get_inode.patch

