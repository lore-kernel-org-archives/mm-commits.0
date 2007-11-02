From: akpm@linux-foundation.org
Subject: + mnt_unbindable-fix.patch added to -mm tree
Date: Fri, 02 Nov 2007 13:39:48 -0700
Message-ID: <200711022039.lA2Kdmw3009982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38224 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940AbXKBUku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 16:40:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Andries.Brouwer@cwi.nl, linuxram@us.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     MNT_UNBINDABLE fix
has been added to the -mm tree.  Its filename is
     mnt_unbindable-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: MNT_UNBINDABLE fix
=46rom: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>

Some time ago ( http://lkml.org/lkml/2007/6/19/128 ) I wrote about
MNT_UNBINDABLE that it felt like a bug that it is not reset by "mount
--make-private".

Today I happened to see mount(8) and Documentation/sharedsubtree.txt an=
d
both document the version obtained by applying the little patch given i=
n
the above (and again below).

So, the present kernel code is not according to specs and must be regar=
ded
as buggy.

Specification in Documentation/sharedsubtree.txt:
See state diagram: unbindable should become private upon make-private.

Specification in mount(8):
    ...  It's
    also possible to  set  up  uni-directional  propagation  (with  --m=
ake-
    slave),  to  make  a  mount  point unavailable for --bind/--rbind (=
with
    --make-unbindable), and to undo any  of  these  (with  --make-priva=
te).

Repeat of old fix-shared-subtrees-make-private.patch
(due to Dirk Gerrits, Ren=E9 Gabri=EBls, Peter Kooijmans):

Acked-by: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pnode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/pnode.c~mnt_unbindable-fix fs/pnode.c
--- a/fs/pnode.c~mnt_unbindable-fix
+++ a/fs/pnode.c
@@ -83,6 +83,8 @@ void change_mnt_propagation(struct vfsmo
 		mnt->mnt_master =3D NULL;
 		if (type =3D=3D MS_UNBINDABLE)
 			mnt->mnt_flags |=3D MNT_UNBINDABLE;
+		else
+			mnt->mnt_flags &=3D ~MNT_UNBINDABLE;
 	}
 }
=20
_

Patches currently in -mm which might be from Andries.Brouwer@cwi.nl are

mnt_unbindable-fix.patch
