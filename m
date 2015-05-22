From: akpm@linux-foundation.org
Subject: + scripts-gdb-remove-useless-global-instruction.patch added to
 -mm tree
Date: Fri, 22 May 2015 12:32:44 -0700
Message-ID: <555f845c.Mq6eOKZ6gOoXwuTi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201AbbEVTcp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 May 2015 15:32:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thiebaud@weksteen.fr, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: remove useless global instruction
has been added to the -mm tree.  Its filename is
     scripts-gdb-remove-useless-global-instruction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-remove-useless=
-global-instruction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-remove-useless=
-global-instruction.patch

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
=46rom: Thi=E9baud Weksteen <thiebaud@weksteen.fr>
Subject: scripts/gdb: remove useless global instruction

Signed-off-by: Thi=E9baud Weksteen <thiebaud@weksteen.fr>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/tasks.py |    2 --
 1 file changed, 2 deletions(-)

diff -puN scripts/gdb/linux/tasks.py~scripts-gdb-remove-useless-global-=
instruction scripts/gdb/linux/tasks.py
--- a/scripts/gdb/linux/tasks.py~scripts-gdb-remove-useless-global-inst=
ruction
+++ a/scripts/gdb/linux/tasks.py
@@ -20,7 +20,6 @@ task_type =3D utils.CachedType("struct tas
=20
=20
 def task_lists():
-    global task_type
     task_ptr_type =3D task_type.get_type().pointer()
     init_task =3D gdb.parse_and_eval("init_task").address
     t =3D g =3D init_task
@@ -89,7 +88,6 @@ ia64_task_size =3D None
=20
=20
 def get_thread_info(task):
-    global thread_info_type
     thread_info_ptr_type =3D thread_info_type.get_type().pointer()
     if utils.is_target_arch("ia64"):
         global ia64_task_size
_

Patches currently in -mm which might be from thiebaud@weksteen.fr are

scripts-gdb-add-command-to-check-list-consistency.patch
scripts-gdb-also-allow-list_head-pointer-as-lx-list-check-paramter.patc=
h
scripts-gdb-enable-completion-for-lx-list-check-parameter.patch
scripts-gdb-fix-typo-in-exception-name.patch
scripts-gdb-fix-pep8-compliance.patch
scripts-gdb-add-ps-command.patch
scripts-gdb-remove-useless-global-instruction.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
