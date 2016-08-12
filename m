From: akpm@linux-foundation.org
Subject: + autofs-test-autofs-versions-first-on-sb-initialization.patch
 added to -mm tree
Date: Thu, 11 Aug 2016 20:07:03 -0700
Message-ID: <57ad3d57.w93kNihO2DSRbiap%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbcHLDHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 23:07:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: test autofs versions first on sb initialization
has been added to the -mm tree.  Its filename is
     autofs-test-autofs-versions-first-on-sb-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-test-autofs-versions-first-on-sb-initialization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-test-autofs-versions-first-on-sb-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
