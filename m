From: akpm@linux-foundation.org
Subject: [merged] coredump-fix-unfreezable-coredumping-task.patch removed
 from -mm tree
Date: Mon, 14 Nov 2016 12:03:29 -0800
Message-ID: <582a1891.InpF7GZmDI5X+twC%akpm__17896.1870413788$1479153854$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38018 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935195AbcKNUDa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2016 15:03:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, mhocko@kernel.org, oleg@redhat.com, pavel@ucw.cz, rjw@rjwysocki.net, stable@vger.kernel.org, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: fix unfreezable coredumping task
has been removed from the -mm tree.  Its filename was
     coredump-fix-unfreezable-coredumping-task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: coredump: fix unfreezable coredumping task

It could be not possible to freeze coredumping task when it waits for
'core_state->startup' completion, because threads are frozen in
get_signal() before they got a chance to complete 'core_state->startup'.

Inability to freeze a task during suspend will cause suspend to fail. 
Also CRIU uses cgroup freezer during dump operation.  So with an
unfreezable task the CRIU dump will fail because it waits for a
transition from 'FREEZING' to 'FROZEN' state which will never happen.

Use freezer_do_not_count() to tell freezer to ignore coredumping task
while it waits for core_state->startup completion.

Link: http://lkml.kernel.org/r/1475225434-3753-1-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/coredump.c~coredump-fix-unfreezable-coredumping-task fs/coredump.c
--- a/fs/coredump.c~coredump-fix-unfreezable-coredumping-task
+++ a/fs/coredump.c
@@ -1,6 +1,7 @@
 #include <linux/slab.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
+#include <linux/freezer.h>
 #include <linux/mm.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
@@ -423,7 +424,9 @@ static int coredump_wait(int exit_code,
 	if (core_waiters > 0) {
 		struct core_thread *ptr;
 
+		freezer_do_not_count();
 		wait_for_completion(&core_state->startup);
+		freezer_count();
 		/*
 		 * Wait for all the threads to become inactive, so that
 		 * all the thread context (extended register state, like
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are


