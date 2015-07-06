From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-remove-useless-global-instruction.patch
 removed from -mm tree
Date: Mon, 06 Jul 2015 12:47:14 -0700
Message-ID: <559adb42.2p32fVbwAwi85p1s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbbGFTrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thiebaud@weksteen.fr, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: remove useless global instruction
has been removed from the -mm tree.  Its filename was
     scripts-gdb-remove-useless-global-instruction.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
