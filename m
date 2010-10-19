From: akpm@linux-foundation.org
Subject: + hostfs-fix-uml-crash-remove-f_spare-from-hostfs.patch added to -mm tree
Date: Tue, 19 Oct 2010 14:27:59 -0700
Message-ID: <201010192127.o9JLRxun002142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754761Ab0JSVaZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Oct 2010 17:30:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, hch@lst.de, jdike@addtoit.com, toralf.foerster@gmx.de, viro@zeniv.linux.org.uk


The patch titled
     hostfs: fix UML crash: remove f_spare from hostfs
has been added to the -mm tree.  Its filename is
     hostfs-fix-uml-crash-remove-f_spare-from-hostfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: hostfs: fix UML crash: remove f_spare from hostfs
=46rom: Richard Weinberger <richard@nod.at>

365b1818 ("add f_flags to struct statfs(64)") resized f_spare within
struct statfs which caused a UML crash.  There is no need to copy f_spa=
re.

Signed-off-by: Richard Weinberger <richard@nod.at>
Reported-by: Toralf F=F6rster <toralf.foerster@gmx.de>
Tested-by: Toralf F=F6rster <toralf.foerster@gmx.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs.h      |    3 +--
 fs/hostfs/hostfs_kern.c |    2 +-
 fs/hostfs/hostfs_user.c |    9 ++-------
 3 files changed, 4 insertions(+), 10 deletions(-)

diff -puN fs/hostfs/hostfs.h~hostfs-fix-uml-crash-remove-f_spare-from-h=
ostfs fs/hostfs/hostfs.h
--- a/fs/hostfs/hostfs.h~hostfs-fix-uml-crash-remove-f_spare-from-hostf=
s
+++ a/fs/hostfs/hostfs.h
@@ -96,7 +96,6 @@ extern int rename_file(char *from, char=20
 extern int do_statfs(char *root, long *bsize_out, long long *blocks_ou=
t,
 		     long long *bfree_out, long long *bavail_out,
 		     long long *files_out, long long *ffree_out,
-		     void *fsid_out, int fsid_size, long *namelen_out,
-		     long *spare_out);
+		     void *fsid_out, int fsid_size, long *namelen_out);
=20
 #endif
diff -puN fs/hostfs/hostfs_kern.c~hostfs-fix-uml-crash-remove-f_spare-f=
rom-hostfs fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~hostfs-fix-uml-crash-remove-f_spare-from-=
hostfs
+++ a/fs/hostfs/hostfs_kern.c
@@ -217,7 +217,7 @@ int hostfs_statfs(struct dentry *dentry,
 	err =3D do_statfs(dentry->d_sb->s_fs_info,
 			&sf->f_bsize, &f_blocks, &f_bfree, &f_bavail, &f_files,
 			&f_ffree, &sf->f_fsid, sizeof(sf->f_fsid),
-			&sf->f_namelen, sf->f_spare);
+			&sf->f_namelen);
 	if (err)
 		return err;
 	sf->f_blocks =3D f_blocks;
diff -puN fs/hostfs/hostfs_user.c~hostfs-fix-uml-crash-remove-f_spare-f=
rom-hostfs fs/hostfs/hostfs_user.c
--- a/fs/hostfs/hostfs_user.c~hostfs-fix-uml-crash-remove-f_spare-from-=
hostfs
+++ a/fs/hostfs/hostfs_user.c
@@ -364,8 +364,7 @@ int rename_file(char *from, char *to)
 int do_statfs(char *root, long *bsize_out, long long *blocks_out,
 	      long long *bfree_out, long long *bavail_out,
 	      long long *files_out, long long *ffree_out,
-	      void *fsid_out, int fsid_size, long *namelen_out,
-	      long *spare_out)
+	      void *fsid_out, int fsid_size, long *namelen_out)
 {
 	struct statfs64 buf;
 	int err;
@@ -384,10 +383,6 @@ int do_statfs(char *root, long *bsize_ou
 	       sizeof(buf.f_fsid) > fsid_size ? fsid_size :
 	       sizeof(buf.f_fsid));
 	*namelen_out =3D buf.f_namelen;
-	spare_out[0] =3D buf.f_spare[0];
-	spare_out[1] =3D buf.f_spare[1];
-	spare_out[2] =3D buf.f_spare[2];
-	spare_out[3] =3D buf.f_spare[3];
-	spare_out[4] =3D buf.f_spare[4];
+
 	return 0;
 }
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
um-fix-global-timer-issue-when-using-config_no_hz.patch
um-remove-page_size-alignment-in-linker-script-causing-kernel-segfault.=
patch
hostfs-fix-uml-crash-remove-f_spare-from-hostfs.patch
um-migrate-from-__do_irq-to-generic_handle_irq.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
