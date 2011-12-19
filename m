From: akpm@linux-foundation.org
Subject: [merged] fs-ncpfs-fix-error-paths-and-goto-statements-in-ncp_fill_super.patch removed from -mm tree
Date: Mon, 19 Dec 2011 13:28:44 -0800
Message-ID: <20111219212845.487C05C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:64275 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab1LSV2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2011 16:28:48 -0500
Received: by eaad1 with SMTP id d1so176372eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2011 13:28:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tixxdz@opendz.org, lucas.demarchi@profusion.mobi, npiggin@kernel.dk, petr@vandrovec.name, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ncpfs: fix error paths and goto statements in ncp_fill_super()
has been removed from the -mm tree.  Its filename was
     fs-ncpfs-fix-error-paths-and-goto-statements-in-ncp_fill_super.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from tixxdz@opendz.org are

notify_change-check-that-i_mutex-is-held.patch

