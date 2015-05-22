From: akpm@linux-foundation.org
Subject: + scripts-gdb-enable-completion-for-lx-list-check-parameter.patch added to -mm tree
Date: Fri, 22 May 2015 12:32:36 -0700
Message-ID: <555f8454.ppIdNJjiywsH4h/4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201AbbEVTch (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 May 2015 15:32:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, thiebaud@weksteen.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: enable completion for lx-list-check paramete=
r
has been added to the -mm tree.  Its filename is
     scripts-gdb-enable-completion-for-lx-list-check-parameter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-enable-complet=
ion-for-lx-list-check-parameter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-enable-complet=
ion-for-lx-list-check-parameter.patch

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
