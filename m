From: akpm@linux-foundation.org
Subject: [merged] poweroff-fix-bug-in-orderly_poweroff.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:14:03 -0700
Message-ID: <20121005201403.F185B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:34492 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab2JEUOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:14:04 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so235045ggm.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:14:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hongfeng@marvell.com, ebiederm@xmission.com, keescook@chromium.org, rjw@sisk.pl, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: poweroff: fix bug in orderly_poweroff()
has been removed from the -mm tree.  Its filename was
     poweroff-fix-bug-in-orderly_poweroff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: hongfeng <hongfeng@marvell.com>
Subject: poweroff: fix bug in orderly_poweroff()

orderly_poweroff is trying to poweroff platform in two steps:

step 1: Call user space application to poweroff
step 2: If user space poweroff fail, then do a force power off if force param
        is set.

The bug here is, step 1 is always successful with param UMH_NO_WAIT, which obey
the design goal of orderly_poweroff.

We have two choices here:
UMH_WAIT_EXEC which means wait for the exec, but not the process;
UMH_WAIT_PROC which means wait for the process to complete.
we need to trade off the two choices:

If using UMH_WAIT_EXEC, there is potential issue comments by Serge E. 
Hallyn: The exec will have started, but may for whatever (very unlikely)
reason fail.

If using UMH_WAIT_PROC, there is potential issue comments by Eric W. 
Biederman: If the caller is not running in a kernel thread then we can
easily get into a case where the user space caller will block waiting for
us when we are waiting for the user space caller.

Thanks for their excellent ideas, based on the above discussion, we
finally choose UMH_WAIT_EXEC, which is much more safe, if the user
application really fails, we just complain the application itself, it
seems a better choice here.

Signed-off-by: Feng Hong <hongfeng@marvell.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sys.c~poweroff-fix-bug-in-orderly_poweroff kernel/sys.c
--- a/kernel/sys.c~poweroff-fix-bug-in-orderly_poweroff
+++ a/kernel/sys.c
@@ -2205,7 +2205,7 @@ static int __orderly_poweroff(void)
 		return -ENOMEM;
 	}
 
-	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_NO_WAIT,
+	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_WAIT_EXEC,
 				      NULL, argv_cleanup, NULL);
 	if (ret == -ENOMEM)
 		argv_free(argv);
_

Patches currently in -mm which might be from hongfeng@marvell.com are

origin.patch

