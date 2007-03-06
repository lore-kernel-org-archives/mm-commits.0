From: akpm@linux-foundation.org
Subject: + uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:26:27 -0800
Message-ID: <200703060426.l264QRF7011740@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50185 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933939AbXCFE03 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:26:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: blaisorblade@yahoo.it, jdike@addtoit.com


The patch titled
     uml: hostfs: make hostfs= option work as a jail, as intended.
has been added to the -mm tree.  Its filename is
     uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: hostfs: make hostfs= option work as a jail, as intended.
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

When a given host directory is specified to be mounted both in hostfs=path1
and with mount option -o path2, we should give access to path1/path2, but this
does not happen.  Fix that in the simpler way.

Also, root_ino can be the empty string, since we use %s/%s as format.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_kern.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN fs/hostfs/hostfs_kern.c~uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended
+++ a/fs/hostfs/hostfs_kern.c
@@ -47,7 +47,7 @@ struct dentry_operations hostfs_dentry_o
 };
 
 /* Changed in hostfs_args before the kernel starts running */
-static char *root_ino = "/";
+static char *root_ino = "";
 static int append = 0;
 
 #define HOSTFS_SUPER_MAGIC 0x00c0ffee
@@ -947,15 +947,17 @@ static int hostfs_fill_sb_common(struct 
 	sb->s_magic = HOSTFS_SUPER_MAGIC;
 	sb->s_op = &hostfs_sbops;
 
-	if((data == NULL) || (*data == '\0'))
-		data = root_ino;
+	/* NULL is printed as <NULL> by sprintf: avoid that. */
+	if (data == NULL)
+		data = "";
 
 	err = -ENOMEM;
-	name = kmalloc(strlen(data) + 1, GFP_KERNEL);
+	name = kmalloc(strlen(root_ino) + 1
+			+ strlen(data) + 1, GFP_KERNEL);
 	if(name == NULL)
 		goto out;
 
-	strcpy(name, data);
+	sprintf(name, "%s/%s", root_ino, data);
 
 	root_inode = iget(sb, 0);
 	if(root_inode == NULL)
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

origin.patch
x86_64-fix-2618-regression-ptrace_oldsetoptions-should-be-accepted.patch
uml-hostfs-fix-double-free.patch
uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
uml-fix-a-memory-leak-in-the-multicast-driver.patch
uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
uml-mark-both-consoles-as-con_anytime.patch
uml-fix-confusion-irq-early-reenabling.patch
uml-activate_fd-return-enomem-only-when-appropriate.patch
uml-fix-errno-usage.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-fix-prototypes.patch
git-gccbug.patch
