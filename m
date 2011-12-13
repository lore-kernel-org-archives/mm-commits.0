From: akpm@linux-foundation.org
Subject: + fs-ncpfs-fix-error-paths-and-goto-statements-in-ncp_fill_super.patch added to -mm tree
Date: Tue, 13 Dec 2011 15:52:52 -0800
Message-ID: <201112132352.pBDNqq1U001531@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:33614 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab1LMXxC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Dec 2011 18:53:02 -0500
Received: by eekc1 with SMTP id c1so9130eek.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Dec 2011 15:53:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tixxdz@opendz.org, lucas.demarchi@profusion.mobi, npiggin@kernel.dk, petr@vandrovec.name, tj@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/ncpfs: fix error paths and goto statements in ncp_fill_super()
has been added to the -mm tree.  Its filename is
     fs-ncpfs-fix-error-paths-and-goto-statements-in-ncp_fill_super.patch

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
From: Djalal Harouni <tixxdz@opendz.org>
Subject: fs/ncpfs: fix error paths and goto statements in ncp_fill_super()

The label 'out_bdi' should be followed by bdi_destroy() instead of fput()
which should be after the 'out_fput' label.

If bdi_setup_and_register() fails then jump to the 'out_fput' label
instead of the 'out_bdi' one.

If fget(data.info_fd) fails then jump to the previously fixed 'out_bdi'
label to call bdi_destroy() otherwise the bdi object will not be
destroyed.

Compile tested only.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Tejun Heo <tj@kernel.org>
Cc: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/inode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ncpfs/inode.c~fs-ncpfs-fix-error-paths-and-goto-statements-in-ncp_fill_super fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~fs-ncpfs-fix-error-paths-and-goto-statements-in-ncp_fill_super
+++ a/fs/ncpfs/inode.c
@@ -548,7 +548,7 @@ static int ncp_fill_super(struct super_b
 
 	error = bdi_setup_and_register(&server->bdi, "ncpfs", BDI_CAP_MAP_COPY);
 	if (error)
-		goto out_bdi;
+		goto out_fput;
 
 	server->ncp_filp = ncp_filp;
 	server->ncp_sock = sock;
@@ -559,7 +559,7 @@ static int ncp_fill_super(struct super_b
 		error = -EBADF;
 		server->info_filp = fget(data.info_fd);
 		if (!server->info_filp)
-			goto out_fput;
+			goto out_bdi;
 		error = -ENOTSOCK;
 		sock_inode = server->info_filp->f_path.dentry->d_inode;
 		if (!S_ISSOCK(sock_inode->i_mode))
@@ -746,9 +746,9 @@ out_nls:
 out_fput2:
 	if (server->info_filp)
 		fput(server->info_filp);
-out_fput:
-	bdi_destroy(&server->bdi);
 out_bdi:
+	bdi_destroy(&server->bdi);
+out_fput:
 	/* 23/12/1998 Marcin Dalecki <dalecki@cs.net.pl>:
 	 * 
 	 * The previously used put_filp(ncp_filp); was bogus, since
_
Subject: Subject: fs/ncpfs: fix error paths and goto statements in ncp_fill_super()

Patches currently in -mm which might be from tixxdz@opendz.org are

linux-next.patch
fs-ncpfs-fix-error-paths-and-goto-statements-in-ncp_fill_super.patch

