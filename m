From: akpm@linux-foundation.org
Subject: [merged] usermodehelper-cleanup-fix-__orderly_poweroff-argv_free.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:10:50 -0800
Message-ID: <20130228201050.B387C31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:39685 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1UKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:10:52 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so244658ves.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:10:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dhowells@redhat.com, hongfeng@marvell.com, james.l.morris@oracle.com, lucas.demarchi@profusion.mobi, mm-commits@vger.kernel.org


The patch titled
     Subject: usermodehelper: cleanup/fix __orderly_poweroff() && argv_free()
has been removed from the -mm tree.  Its filename was
     usermodehelper-cleanup-fix-__orderly_poweroff-argv_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: usermodehelper: cleanup/fix __orderly_poweroff() && argv_free()

__orderly_poweroff() does argv_free() if call_usermodehelper_fns() returns
-ENOMEM.  As Lucas pointed out, this can be wrong if -ENOMEM was not
triggered by the failing call_usermodehelper_setup(), in this case both
__orderly_poweroff() and argv_cleanup() can do kfree().

Kill argv_cleanup() and change __orderly_poweroff() to call argv_free()
unconditionally like do_coredump() does.  This info->cleanup() is not
needed (and wrong) since 6c0c0d4d "fix bug in orderly_poweroff() which did
the UMH_NO_WAIT => UMH_WAIT_EXEC change, we can rely on the fact that
CLONE_VFORK can't return until do_execve() succeeds/fails.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: hongfeng <hongfeng@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN kernel/sys.c~usermodehelper-cleanup-fix-__orderly_poweroff-argv_free kernel/sys.c
--- a/kernel/sys.c~usermodehelper-cleanup-fix-__orderly_poweroff-argv_free
+++ a/kernel/sys.c
@@ -2185,11 +2185,6 @@ SYSCALL_DEFINE3(getcpu, unsigned __user 
 
 char poweroff_cmd[POWEROFF_CMD_PATH_LEN] = "/sbin/poweroff";
 
-static void argv_cleanup(struct subprocess_info *info)
-{
-	argv_free(info->argv);
-}
-
 static int __orderly_poweroff(void)
 {
 	int argc;
@@ -2209,9 +2204,8 @@ static int __orderly_poweroff(void)
 	}
 
 	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_WAIT_EXEC,
-				      NULL, argv_cleanup, NULL);
-	if (ret == -ENOMEM)
-		argv_free(argv);
+				      NULL, NULL, NULL);
+	argv_free(argv);
 
 	return ret;
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch

