From: akpm@linux-foundation.org
Subject: - couple-fixes-to-fs-ecryptfs-inodec.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:19 -0700
Message-ID: <200707172305.l6HN5Jtc011911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936298AbXGQXPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikukkon@miku.homelinux.net, mhalcrow@us.ibm.com, mikukkon@iki.fi, mm-commits@vger.kernel.org


The patch titled
     Couple fixes to fs/ecryptfs/inode.c
has been removed from the -mm tree.  Its filename was
     couple-fixes-to-fs-ecryptfs-inodec.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: Couple fixes to fs/ecryptfs/inode.c
=46rom: Mika Kukkonen <mikukkon@miku.homelinux.net>

=46ollowing was uncovered by compiling the kernel with '-W' flag:

  CC [M]  fs/ecryptfs/inode.o
fs/ecryptfs/inode.c: In function =E2=80=98ecryptfs_lookup=E2=80=99:
fs/ecryptfs/inode.c:304: warning: comparison of unsigned expression < 0=
 is always false
fs/ecryptfs/inode.c: In function =E2=80=98ecryptfs_symlink=E2=80=99:
fs/ecryptfs/inode.c:486: warning: comparison of unsigned expression < 0=
 is always false

=46unction ecryptfs_encode_filename() can return -ENOMEM, so change the
variables to plain int, as in the first case the only real use actually
expects int, and in latter case there is no use beoynd the error check.

Signed-off-by: Mika Kukkonen <mikukkon@iki.fi>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ecryptfs/inode.c~couple-fixes-to-fs-ecryptfs-inodec fs/ecr=
yptfs/inode.c
--- a/fs/ecryptfs/inode.c~couple-fixes-to-fs-ecryptfs-inodec
+++ a/fs/ecryptfs/inode.c
@@ -282,7 +282,7 @@ static struct dentry *ecryptfs_lookup(st
 	struct dentry *lower_dentry;
 	struct vfsmount *lower_mnt;
 	char *encoded_name;
-	unsigned int encoded_namelen;
+	int encoded_namelen;
 	struct ecryptfs_crypt_stat *crypt_stat =3D NULL;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
 	char *page_virt =3D NULL;
@@ -473,7 +473,7 @@ static int ecryptfs_symlink(struct inode
 	struct dentry *lower_dir_dentry;
 	umode_t mode;
 	char *encoded_symname;
-	unsigned int encoded_symlen;
+	int encoded_symlen;
 	struct ecryptfs_crypt_stat *crypt_stat =3D NULL;
=20
 	lower_dentry =3D ecryptfs_dentry_to_lower(dentry);
_

Patches currently in -mm which might be from mikukkon@miku.homelinux.ne=
t are

origin.patch
