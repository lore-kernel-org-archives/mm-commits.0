From: akpm@linux-foundation.org
Subject: [merged] devpts-correctly-set-default-options.patch removed from -mm tree
Date: Sun, 17 May 2009 09:54:43 -0700
Message-ID: <200905171654.n4HGshb9017307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029AbZEQQ4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 17 May 2009 12:56:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, eparis@redhat.com, hch@lst.de, hpa@zytor.com, marc.c.dionne@gmail.com, rjw@sisk.pl, serue@us.ibm.com, sukadev@us.ibm.com, viro@ze


The patch titled
     devpts: correctly set default options
has been removed from the -mm tree.  Its filename was
     devpts-correctly-set-default-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Tested-by: Marc Dionne <marc.c.dionne@gmail.com>
Reported-by: Eric Paris <eparis@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
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

pidns-make-create_pid_namespace-accept-parent-pidns.patch
pidns-rewrite-copy_pid_ns.patch

