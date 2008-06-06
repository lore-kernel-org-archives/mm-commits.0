From: akpm@linux-foundation.org
Subject: - smack-fuse-mount-hang-fix.patch removed from -mm tree
Date: Fri, 06 Jun 2008 11:59:38 -0700
Message-ID: <200806061859.m56Ixc2j013865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755968AbYFFTAA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2008 15:00:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: casey@schaufler-ca.com, darwish.07@gmail.com, lcapitulino@mandriva.com.br, miklos@szeredi.hu, mm-commits@vger.kernel.org


The patch titled
     smack: fix fuse mount hang
has been removed from the -mm tree.  Its filename was
     smack-fuse-mount-hang-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smack: fix fuse mount hang
From: Casey Schaufler <casey@schaufler-ca.com>

The d_instantiate hook for Smack can hang on the root inode of a
filesystem if the file system code has not really done all the set-up. 
Fuse is known to encounter this problem.  This change detects an attempt
to instantiate a root inode and addresses it early in the processing,
before any attempt is made to do something that might hang.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Tested-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smack_lsm.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN security/smack/smack_lsm.c~smack-fuse-mount-hang-fix security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~smack-fuse-mount-hang-fix
+++ a/security/smack/smack_lsm.c
@@ -1893,6 +1893,18 @@ static void smack_d_instantiate(struct d
 	}
 
 	/*
+	 * If this is the root inode the superblock
+	 * may be in the process of initialization.
+	 * If that is the case use the root value out
+	 * of the superblock.
+	 */
+	if (opt_dentry->d_parent == opt_dentry) {
+		isp->smk_inode = sbsp->smk_root;
+		isp->smk_flags |= SMK_INODE_INSTANT;
+		goto unlockandout;
+	}
+
+	/*
 	 * This is pretty hackish.
 	 * Casey says that we shouldn't have to do
 	 * file system specific code, but it does help
_

Patches currently in -mm which might be from casey@schaufler-ca.com are

smack-fuse-mount-hang-fix.patch

