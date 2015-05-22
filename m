From: akpm@linux-foundation.org
Subject: +
 scripts-gdb-also-allow-list_head-pointer-as-lx-list-check-paramter.patch
 added to -mm tree
Date: Fri, 22 May 2015 12:32:34 -0700
Message-ID: <555f8452.4IzbQffgoTu9v2u5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674AbbEVTcf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 May 2015 15:32:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, thiebaud@weksteen.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: also allow list_head pointer as lx-list-chec=
k paramter
has been added to the -mm tree.  Its filename is
     scripts-gdb-also-allow-list_head-pointer-as-lx-list-check-paramter=
=2Epatch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-also-allow-lis=
t_head-pointer-as-lx-list-check-paramter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-also-allow-lis=
t_head-pointer-as-lx-list-check-paramter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-gdb-fix-lx-lsmod-refcnt.patch
scripts-gdb-add-command-to-check-list-consistency.patch
scripts-gdb-also-allow-list_head-pointer-as-lx-list-check-paramter.patc=
h
scripts-gdb-enable-completion-for-lx-list-check-parameter.patch
scripts-gdb-fix-typo-in-exception-name.patch
scripts-gdb-fix-pep8-compliance.patch
scripts-gdb-add-ps-command.patch
scripts-gdb-remove-useless-global-instruction.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
