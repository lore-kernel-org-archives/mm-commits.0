From: akpm@linux-foundation.org
Subject: [merged] sys_prctl-arg2-is-unsigned-long-which-is-never-0.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:39:50 -0800
Message-ID: <20130222203950.A30925A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:52400 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011Ab3BVUjv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:39:51 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so103817ggi.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:39:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gang.chen@asianux.com, gorcunov@openvz.org, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sys_prctl(): arg2 is unsigned long which is never < 0
has been removed from the -mm tree.  Its filename was
     sys_prctl-arg2-is-unsigned-long-which-is-never-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: sys_prctl(): arg2 is unsigned long which is never < 0

arg2 will never < 0, for its type is 'unsigned long'

Also, use the provided macros.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/sys.c~sys_prctl-arg2-is-unsigned-long-which-is-never-0 kernel/sys.c
--- a/kernel/sys.c~sys_prctl-arg2-is-unsigned-long-which-is-never-0
+++ a/kernel/sys.c
@@ -47,6 +47,7 @@
 #include <linux/syscalls.h>
 #include <linux/kprobes.h>
 #include <linux/user_namespace.h>
+#include <linux/binfmts.h>
 
 #include <linux/kmsg_dump.h>
 /* Move somewhere else to avoid recompiling? */
@@ -2026,7 +2027,8 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			error = get_dumpable(me->mm);
 			break;
 		case PR_SET_DUMPABLE:
-			if (arg2 < 0 || arg2 > 1) {
+			if (arg2 != SUID_DUMP_DISABLE &&
+			    arg2 != SUID_DUMP_USER) {
 				error = -EINVAL;
 				break;
 			}
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
linux-next.patch
coredump-remove-redundant-defines-for-dumpable-states.patch

