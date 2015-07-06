From: akpm@linux-foundation.org
Subject: [merged]
 scripts-gdb-also-allow-list_head-pointer-as-lx-list-check-paramter.patch
 removed from -mm tree
Date: Mon, 06 Jul 2015 12:47:04 -0700
Message-ID: <559adb38.Mt4Es2wIcYW9uO/R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612AbbGFTrE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, thiebaud@weksteen.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: also allow list_head pointer as lx-list-chec=
k paramter
has been removed from the -mm tree.  Its filename was
     scripts-gdb-also-allow-list_head-pointer-as-lx-list-check-paramter=
=2Epatch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: also allow list_head pointer as lx-list-check par=
amter

This makes the usage more flexible.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thi=E9baud Weksteen <thiebaud@weksteen.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/lists.py |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN scripts/gdb/linux/lists.py~scripts-gdb-also-allow-list_head-p=
ointer-as-lx-list-check-paramter scripts/gdb/linux/lists.py
--- a/scripts/gdb/linux/lists.py~scripts-gdb-also-allow-list_head-point=
er-as-lx-list-check-paramter
+++ a/scripts/gdb/linux/lists.py
@@ -20,9 +20,11 @@ list_head =3D utils.CachedType("struct lis
=20
 def list_check(head):
     nb =3D 0
+    if (head.type =3D=3D list_head.get_type().pointer()):
+        head =3D head.dereference()
+    elif (head.type !=3D list_head.get_type()):
+        raise gdb.GdbError('argument must be of type (struct list_head=
 [*])')
     c =3D head
-    if (c.type !=3D list_head.get_type()):
-        raise gdb.GdbError('The argument should be of type (struct lis=
t_head)')
     try:
         gdb.write("Starting with: {}\n".format(c))
     except gdb.MemoryError:
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
