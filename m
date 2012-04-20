From: akpm@linux-foundation.org
Subject: + mm-fix-null-ptr-dereference-in-migrate_pages.patch added to -mm tree
Date: Fri, 20 Apr 2012 14:59:32 -0700
Message-ID: <20120420215932.81BB1A00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:51620 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab2DTV7e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 17:59:34 -0400
Received: by qcsp5 with SMTP id p5so1159781qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 14:59:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: levinsasha928@gmail.com, cl@linux.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     Subject: mm: fix NULL ptr dereference in migrate_pages
has been added to the -mm tree.  Its filename is
     mm-fix-null-ptr-dereference-in-migrate_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <levinsasha928@gmail.com>
Subject: mm: fix NULL ptr dereference in migrate_pages

Commit 3268c63 ("mm: fix move/migrate_pages() race on task struct") has
added an odd construct where 'mm' is checked for being NULL, and if it is,
it would get dereferenced anyways by mput()ing it.

This would lead to the following NULL ptr deref and BUG() when calling
migrate_pages() with a pid that has no mm struct:

[25904.193704] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
[25904.194235] IP: [<ffffffff810b0de7>] mmput+0x27/0xf0
[25904.194235] PGD 773e6067 PUD 77da0067 PMD 0
[25904.194235] Oops: 0002 [#1] PREEMPT SMP
[25904.194235] CPU 2
[25904.194235] Pid: 31608, comm: trinity Tainted: G        W    3.4.0-rc2-next-20120412-sasha #69
[25904.194235] RIP: 0010:[<ffffffff810b0de7>]  [<ffffffff810b0de7>] mmput+0x27/0xf0
[25904.194235] RSP: 0018:ffff880077d49e08  EFLAGS: 00010202
[25904.194235] RAX: 0000000000000286 RBX: 0000000000000000 RCX: 0000000000000000
[25904.194235] RDX: ffff880075ef8000 RSI: 000000000000023d RDI: 0000000000000286
[25904.194235] RBP: ffff880077d49e18 R08: 0000000000000001 R09: 0000000000000001
[25904.194235] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[25904.194235] R13: 00000000ffffffea R14: ffff880034287740 R15: ffff8800218d3010
[25904.194235] FS:  00007fc8b244c700(0000) GS:ffff880029800000(0000) knlGS:0000000000000000
[25904.194235] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25904.194235] CR2: 0000000000000050 CR3: 00000000767c6000 CR4: 00000000000406e0
[25904.194235] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[25904.194235] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[25904.194235] Process trinity (pid: 31608, threadinfo ffff880077d48000, task ffff880075ef8000)
[25904.194235] Stack:
[25904.194235]  ffff8800342876c0 0000000000000000 ffff880077d49f78 ffffffff811b8020
[25904.194235]  ffffffff811b7d91 ffff880075ef8000 ffff88002256d200 0000000000000000
[25904.194235]  00000000000003ff 0000000000000000 0000000000000000 0000000000000000
[25904.194235] Call Trace:
[25904.194235]  [<ffffffff811b8020>] sys_migrate_pages+0x340/0x3a0
[25904.194235]  [<ffffffff811b7d91>] ? sys_migrate_pages+0xb1/0x3a0
[25904.194235]  [<ffffffff8266cbb9>] system_call_fastpath+0x16/0x1b
[25904.194235] Code: c9 c3 66 90 55 31 d2 48 89 e5 be 3d 02 00 00 48 83 ec 10 48 89 1c 24 4c 89 64 24 08 48 89 fb 48 c7 c7 cf 0e e1 82 e8 69 18 03 00 <f0> ff 4b 50 0f 94 c0 84 c0 0f 84 aa 00 00 00 48 89 df e8 72 f1
[25904.194235] RIP  [<ffffffff810b0de7>] mmput+0x27/0xf0
[25904.194235]  RSP <ffff880077d49e08>
[25904.194235] CR2: 0000000000000050
[25904.348999] ---[ end trace a307b3ed40206b4b ]---

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/mempolicy.c~mm-fix-null-ptr-dereference-in-migrate_pages mm/mempolicy.c
--- a/mm/mempolicy.c~mm-fix-null-ptr-dereference-in-migrate_pages
+++ a/mm/mempolicy.c
@@ -1361,11 +1361,14 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 
 	mm = get_task_mm(task);
 	put_task_struct(task);
-	if (mm)
-		err = do_migrate_pages(mm, old, new,
-			capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
-	else
+
+	if (!mm) {
 		err = -EINVAL;
+		goto out;
+	}
+
+	err = do_migrate_pages(mm, old, new,
+		capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
 
 	mmput(mm);
 out:
_
Subject: Subject: mm: fix NULL ptr dereference in migrate_pages

Patches currently in -mm which might be from levinsasha928@gmail.com are

linux-next.patch
mm-fix-null-ptr-dereference-in-migrate_pages.patch
mm-fix-null-ptr-dereference-in-move_pages.patch
brlocks-lglocks-cleanups.patch

