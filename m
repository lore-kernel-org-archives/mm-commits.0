From: akpm@linux-foundation.org
Subject: + uml-hostfs-fix-double-free.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:26:24 -0800
Message-ID: <200703060426.l264QOuT011736@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50187 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933940AbXCFE0a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:26:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: blaisorblade@yahoo.it, jdike@addtoit.com, wstearns@pobox.com


The patch titled
     uml: hostfs: fix double free
has been added to the -mm tree.  Its filename is
     uml-hostfs-fix-double-free.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: hostfs: fix double free
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Fix double free in the error path - when name is assigned into root_inode we
do not own it any more and we must not kfree() it - see patch for details.

Thanks to William Stearns for the initial report.

CC: William Stearns <wstearns@pobox.com>
Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_kern.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/hostfs/hostfs_kern.c~uml-hostfs-fix-double-free fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~uml-hostfs-fix-double-free
+++ a/fs/hostfs/hostfs_kern.c
@@ -966,6 +966,9 @@ static int hostfs_fill_sb_common(struct 
 		goto out_put;
 
 	HOSTFS_I(root_inode)->host_filename = name;
+	/* Avoid that in the error path, iput(root_inode) frees again name through
+	 * hostfs_destroy_inode! */
+	name = NULL;
 
 	err = -ENOMEM;
 	sb->s_root = d_alloc_root(root_inode);
@@ -977,7 +980,7 @@ static int hostfs_fill_sb_common(struct 
                 /* No iput in this case because the dput does that for us */
                 dput(sb->s_root);
                 sb->s_root = NULL;
-		goto out_free;
+		goto out;
         }
 
 	return(0);
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
