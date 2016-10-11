From: akpm@linux-foundation.org
Subject: [patch 031/102] autofs: test autofs versions first on sb
 initialization
Date: Tue, 11 Oct 2016 13:52:31 -0700
Message-ID: <57fd510f.mDPQm7J0AjqcbiL9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37864 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753038AbcJKUxE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kusumi.tomohiro@gmail.com, raven@themaw.net

From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: autofs: test autofs versions first on sb initialization

This patch does what the below comment says.  It could be and it's
considered better to do this first before various functions get called
during initialization.

/* Couldn't this be tested earlier? */

Link: http://lkml.kernel.org/r/20160812024744.12352.43075.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/inode.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN fs/autofs4/inode.c~autofs-test-autofs-versions-first-on-sb-initialization fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs-test-autofs-versions-first-on-sb-initialization
+++ a/fs/autofs4/inode.c
@@ -274,6 +274,23 @@ int autofs4_fill_super(struct super_bloc
 		goto fail_dput;
 	}
 
+	/* Test versions first */
+	if (sbi->max_proto < AUTOFS_MIN_PROTO_VERSION ||
+	    sbi->min_proto > AUTOFS_MAX_PROTO_VERSION) {
+		pr_err("kernel does not match daemon version "
+		       "daemon (%d, %d) kernel (%d, %d)\n",
+		       sbi->min_proto, sbi->max_proto,
+		       AUTOFS_MIN_PROTO_VERSION, AUTOFS_MAX_PROTO_VERSION);
+		goto fail_dput;
+	}
+
+	/* Establish highest kernel protocol version */
+	if (sbi->max_proto > AUTOFS_MAX_PROTO_VERSION)
+		sbi->version = AUTOFS_MAX_PROTO_VERSION;
+	else
+		sbi->version = sbi->max_proto;
+	sbi->sub_version = AUTOFS_PROTO_SUBVERSION;
+
 	if (pgrp_set) {
 		sbi->oz_pgrp = find_get_pid(pgrp);
 		if (!sbi->oz_pgrp) {
@@ -291,23 +308,6 @@ int autofs4_fill_super(struct super_bloc
 	root_inode->i_fop = &autofs4_root_operations;
 	root_inode->i_op = &autofs4_dir_inode_operations;
 
-	/* Couldn't this be tested earlier? */
-	if (sbi->max_proto < AUTOFS_MIN_PROTO_VERSION ||
-	    sbi->min_proto > AUTOFS_MAX_PROTO_VERSION) {
-		pr_err("kernel does not match daemon version "
-		       "daemon (%d, %d) kernel (%d, %d)\n",
-		       sbi->min_proto, sbi->max_proto,
-		       AUTOFS_MIN_PROTO_VERSION, AUTOFS_MAX_PROTO_VERSION);
-		goto fail_dput;
-	}
-
-	/* Establish highest kernel protocol version */
-	if (sbi->max_proto > AUTOFS_MAX_PROTO_VERSION)
-		sbi->version = AUTOFS_MAX_PROTO_VERSION;
-	else
-		sbi->version = sbi->max_proto;
-	sbi->sub_version = AUTOFS_PROTO_SUBVERSION;
