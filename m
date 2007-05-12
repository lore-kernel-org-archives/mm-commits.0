From: akpm@linux-foundation.org
Subject: - afs-fix-interminable-loop-in-afs_write_back_from_locked_page.patch removed from -mm tree
Date: Fri, 11 May 2007 22:32:47 -0700
Message-ID: <200705120532.l4C5WlUh002060@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756989AbXELFdE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:33:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mikukkon@iki.fi, mm-commits@vger.kernel.org


The patch titled
     AFS: fix interminable loop in afs_write_back_from_locked_page()
has been removed from the -mm tree.  Its filename was
     afs-fix-interminable-loop-in-afs_write_back_from_locked_page.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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
 1 file changed, 3 insertions(+), 2 deletions(-)

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
remove-slab_ctor_constructor.patch
split-usermodehelper-setup-from-execution.patch
mutex-subsystem-synchro-test-module.patch
