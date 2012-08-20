From: akpm@linux-foundation.org
Subject: [merged] debugfs-make-__create_file-static.patch removed from -mm tree
Date: Mon, 20 Aug 2012 12:56:42 -0700
Message-ID: <20120820195643.1768D200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:45267 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab2HTT4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 15:56:45 -0400
Received: by mail-lb0-f202.google.com with SMTP id ge1so313971lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 12:56:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrisw@sous-sol.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: debugfs: make __create_file() static
has been removed from the -mm tree.  Its filename was
     debugfs-make-__create_file-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

