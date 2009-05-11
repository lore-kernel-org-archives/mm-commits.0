From: akpm@linux-foundation.org
Subject: + devpts-correctly-set-default-options.patch added to -mm tree
Date: Mon, 11 May 2009 15:40:54 -0700
Message-ID: <200905112240.n4BMesns017086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758245AbZEKWry (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 18:47:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, eparis@redhat.com, hch@lst.de, hpa@zytor.com, marc.c.dionne@gmail.com, rjw@sisk.pl, serue@us.ibm.com, sukadev@us.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     devpts: correctly set default options
has been added to the -mm tree.  Its filename is
     devpts-correctly-set-default-options.patch

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
Subject: devpts: correctly set default options
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

devpts_get_sb() calls memset(0) to clear mount options and calls
parse_mount_options() if user specified any mount options.  The memset(0)
is bogus since the 'mode' and 'ptmxmode' options are non-zero by default. 
parse_mount_options() restores options to default anyway and can properly
deal with NULL mount options.

So in devpts_get_sb() remove memset(0) and call parse_mount_options() even
for NULL mount options.

Bug reported by Eric Paris: http://lkml.org/lkml/2009/5/7/448.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Marc Dionne <marc.c.dionne@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN fs/devpts/inode.c~devpts-correctly-set-default-options fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-correctly-set-default-options
+++ a/fs/devpts/inode.c
@@ -90,6 +90,15 @@ static inline struct super_block *pts_sb
 #define PARSE_MOUNT	0
 #define PARSE_REMOUNT	1
 
+/*
+ * parse_mount_options():
+ * 	Set @opts to mount options specified in @data. If an option is not
+ * 	specified in @data, set it to its default value. The exception is
+ * 	'newinstance' option which can only be set/cleared on a mount (i.e.
+ * 	cannot be changed during remount).
+ *
+ * Note: @data may be NULL (in which case all options are set to default).
+ */
 static int parse_mount_options(char *data, int op, struct pts_mount_opts *opts)
 {
 	char *p;
@@ -355,12 +364,9 @@ static int devpts_get_sb(struct file_sys
 	struct pts_mount_opts opts;
 	struct super_block *s;
 
-	memset(&opts, 0, sizeof(opts));
-	if (data) {
-		error = parse_mount_options(data, PARSE_MOUNT, &opts);
-		if (error)
-			return error;
-	}
+	error = parse_mount_options(data, PARSE_MOUNT, &opts);
+	if (error)
+		return error;
 
 	if (opts.newinstance)
 		s = sget(fs_type, NULL, set_anon_super, NULL);
_

Patches currently in -mm which might be from sukadev@linux.vnet.ibm.com are

devpts-correctly-set-default-options.patch
pidns-make-create_pid_namespace-accept-parent-pidns.patch
pidns-rewrite-copy_pid_ns.patch

