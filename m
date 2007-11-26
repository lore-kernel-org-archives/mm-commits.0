From: akpm@linux-foundation.org
Subject: - fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch removed from -mm tree
Date: Mon, 26 Nov 2007 11:36:25 -0800
Message-ID: <200711261936.lAQJaPFw019308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53889 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174AbXKZTrB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 14:47:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     fix warnings in revoked_inode.c
has been removed from the -mm tree.  Its filename was
     fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-f=
ix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: fix warnings in revoked_inode.c
=46rom: Miklos Szeredi <mszeredi@suse.cz>

=46ix following warnings introduced by
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch

fs/revoked_inode.c:381: warning: =E2=80=98revoked_write_begin=E2=80=99 =
defined but not used
fs/revoked_inode.c:388: warning: =E2=80=98revoked_write_end=E2=80=99 de=
fined but not used

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoked_inode.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff -puN fs/revoked_inode.c~fs-introduce-write_begin-write_end-and-per=
form_write-aops-revoke-fix fs/revoked_inode.c
--- a/fs/revoked_inode.c~fs-introduce-write_begin-write_end-and-perform=
_write-aops-revoke-fix
+++ a/fs/revoked_inode.c
@@ -372,18 +372,6 @@ static int revoked_writepage(struct page
 	return -EIO;
 }
=20
-static int revoked_prepare_write(struct file *file, struct page *page,
-				 unsigned from, unsigned to)
-{
-	return -EIO;
-}
-
-static int revoked_commit_write(struct file *file, struct page *page,
-				unsigned from, unsigned to)
-{
-	return -EIO;
-}
-
 static int revoked_write_begin(struct file *file, struct address_space=
 *mapping,
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata)
@@ -408,8 +396,8 @@ static ssize_t revoked_direct_IO(int rw,
 static const struct address_space_operations revoked_aops =3D {
         .readpage       =3D revoked_readpage,
         .writepage      =3D revoked_writepage,
-        .prepare_write  =3D revoked_prepare_write,
-        .commit_write   =3D revoked_commit_write,
+	.write_begin	=3D revoked_write_begin,
+	.write_end	=3D revoked_write_end,
         .direct_IO      =3D revoked_direct_IO,
 };
=20
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-fix-reading-past-eof.patch
fuse-cleanup-add-fuse_get_attr_version.patch
fuse-pass-open-flags-to-read-and-write.patch
fuse-fix-fuse_file_ops-sending.patch
fuse-fix-uninitialized-field-in-fuse_inode.patch
fuse-fix-attribute-caching-after-rename.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.pa=
tch
