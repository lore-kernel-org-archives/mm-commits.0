From: akpm@linux-foundation.org
Subject: + sys_prctl-arg2-is-unsigned-long-which-is-never-0.patch added to -mm tree
Date: Tue, 19 Feb 2013 15:14:26 -0800
Message-ID: <20130219231426.AC5DC31C03C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:58616 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932846Ab3BSXO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Feb 2013 18:14:28 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so735727vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 19 Feb 2013 15:14:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gang.chen@asianux.com, gorcunov@openvz.org, keescook@chromium.org


The patch titled
     Subject: sys_prctl(): arg2 is unsigned long which is never < 0
has been added to the -mm tree.  Its filename is
     sys_prctl-arg2-is-unsigned-long-which-is-never-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2027,7 +2028,8 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
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

linux-next.patch
sys_prctl-arg2-is-unsigned-long-which-is-never-0.patch
coredump-remove-redundant-defines-for-dumpable-states.patch

