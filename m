From: akpm@linux-foundation.org
Subject: + debugfs-make-__create_file-static.patch added to -mm tree
Date: Thu, 16 Aug 2012 13:15:42 -0700
Message-ID: <20120816201542.A9D5A1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:49112 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030338Ab2HPUPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 16:15:43 -0400
Received: by obbwc20 with SMTP id wc20so2207899obb.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 13:15:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chrisw@sous-sol.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: debugfs: make __create_file() static
has been added to the -mm tree.  Its filename is
     debugfs-make-__create_file-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Wright <chrisw@sous-sol.org>
Subject: debugfs: make __create_file() static

It's only used locally, no need to pollute global namespace.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/debugfs/inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/debugfs/inode.c~debugfs-make-__create_file-static fs/debugfs/inode.c
--- a/fs/debugfs/inode.c~debugfs-make-__create_file-static
+++ a/fs/debugfs/inode.c
@@ -291,9 +291,9 @@ static struct file_system_type debug_fs_
 	.kill_sb =	kill_litter_super,
 };
 
-struct dentry *__create_file(const char *name, umode_t mode,
-				   struct dentry *parent, void *data,
-				   const struct file_operations *fops)
+static struct dentry *__create_file(const char *name, umode_t mode,
+				    struct dentry *parent, void *data,
+				    const struct file_operations *fops)
 {
 	struct dentry *dentry = NULL;
 	int error;
_

Patches currently in -mm which might be from chrisw@sous-sol.org are

debugfs-make-__create_file-static.patch

