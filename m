From: akpm@linux-foundation.org
Subject: + afs-fix-interminable-loop-in-afs_write_back_from_locked_page.patch added to -mm tree
Date: Thu, 10 May 2007 16:14:24 -0700
Message-ID: <200705102314.l4ANEOhf001035@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759338AbXEJXOk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 19:14:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, mikukkon@iki.fi


The patch titled
     AFS: fix interminable loop in afs_write_back_from_locked_page()
has been added to the -mm tree.  Its filename is
     afs-fix-interminable-loop-in-afs_write_back_from_locked_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: AFS: fix interminable loop in afs_write_back_from_locked_page(=
)
=46rom: David Howells <dhowells@redhat.com>

=46ollowing bug was uncovered by compiling with '-W' flag:

  CC [M]  fs/afs/write.o
fs/afs/write.c: In function =E2=80=98afs_write_back_from_locked_page=E2=
=80=99:
fs/afs/write.c:398: warning: comparison of unsigned expression >=3D 0 i=
s always true

Loop variable 'n' is unsigned, so wraps around happily as far as I can
see. Trival fix attached (compile tested only).

Signed-off-by: Mika Kukkonen <mikukkon@iki.fi>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/write.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/afs/write.c~afs-fix-interminable-loop-in-afs_write_back_fr=
om_locked_page fs/afs/write.c
--- a/fs/afs/write.c~afs-fix-interminable-loop-in-afs_write_back_from_l=
ocked_page
+++ a/fs/afs/write.c
@@ -395,8 +395,9 @@ static int afs_write_back_from_locked_pa
 		if (n =3D=3D 0)
 			goto no_more;
 		if (pages[0]->index !=3D start) {
-			for (n--; n >=3D 0; n--)
-				put_page(pages[n]);
+			do {
+				put_page(pages[--n]);
+			} while (n > 0);
 			goto no_more;
 		}
=20
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
git-net.patch
afs-fix-interminable-loop-in-afs_write_back_from_locked_page.patch
afs-fix-a-couple-of-problems-with-unlinking-afs-files.patch
introduce-freezer-flags-rev-2.patch
frv-gdb-use-__maybe_unused.patch
mutex-subsystem-synchro-test-module.patch
