From: akpm@linux-foundation.org
Subject: [merged]
 scripts-gdb-enable-completion-for-lx-list-check-parameter.patch removed
 from -mm tree
Date: Mon, 06 Jul 2015 12:47:06 -0700
Message-ID: <559adb3a.xd8HjlfPvyjhc6lv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbbGFTrG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, thiebaud@weksteen.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: enable completion for lx-list-check paramete=
r
has been removed from the -mm tree.  Its filename was
     scripts-gdb-enable-completion-for-lx-list-check-parameter.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: enable completion for lx-list-check parameter

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thi=E9baud Weksteen <thiebaud@weksteen.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/lists.py |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/gdb/linux/lists.py~scripts-gdb-enable-completion-for-=
lx-list-check-parameter scripts/gdb/linux/lists.py
--- a/scripts/gdb/linux/lists.py~scripts-gdb-enable-completion-for-lx-l=
ist-check-parameter
+++ a/scripts/gdb/linux/lists.py
@@ -80,7 +80,8 @@ class LxListChk(gdb.Command):
     """Verify a list consistency"""
=20
     def __init__(self):
-        super(LxListChk, self).__init__("lx-list-check", gdb.COMMAND_D=
ATA)
+        super(LxListChk, self).__init__("lx-list-check", gdb.COMMAND_D=
ATA,
+                                        gdb.COMPLETE_EXPRESSION)
=20
     def invoke(self, arg, from_tty):
         argv =3D gdb.string_to_argv(arg)
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
