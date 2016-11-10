From: akpm@linux-foundation.org
Subject: [patch 12/15] coredump: fix unfreezable coredumping task
Date: Thu, 10 Nov 2016 10:46:38 -0800
Message-ID: <5824c08e.p0TVQsoLVBIb7vsi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49390 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755791AbcKJSqj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2016 13:46:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aryabinin@virtuozzo.com, mhocko@kernel.org, oleg@redhat.com, pavel@ucw.cz, rjw@rjwysocki.net, stable@vger.kernel.org, tj@kernel.org, viro@zeniv.linux.org.uk

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
