From: akpm@linux-foundation.org
Subject: [obsolete] kernel-sysc-use-the-simpler-call_usermodehelper.patch removed from -mm tree
Date: Thu, 14 Mar 2013 15:29:45 -0700
Message-ID: <20130314222945.5EC1A5A41D7@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:64354 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab3CNW3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 18:29:46 -0400
Received: by mail-ve0-f201.google.com with SMTP id 14so282033vea.2
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 15:29:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lucas.demarchi@profusion.mobi, dhowells@redhat.com, james.l.morris@oracle.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: use the simpler call_usermodehelper()
has been removed from the -mm tree.  Its filename was
     kernel-sysc-use-the-simpler-call_usermodehelper.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: kernel/sys.c: use the simpler call_usermodehelper()

Commit 7ff6764 ("usermodehelper: cleanup/fix __orderly_poweroff() &&
argv_free()") simplified __orderly_poweroff() removing the need to use
call_usermodehelper_fns().

Since we are not passing any callback, it's simpler to use
call_usermodehelper().

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/sys.c~kernel-sysc-use-the-simpler-call_usermodehelper kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-use-the-simpler-call_usermodehelper
+++ a/kernel/sys.c
@@ -2217,8 +2217,7 @@ static int __orderly_poweroff(void)
 		return -ENOMEM;
 	}
 
-	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_WAIT_EXEC,
-				      NULL, NULL, NULL);
+	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
 	argv_free(argv);
 
 	return ret;
_

Patches currently in -mm which might be from lucas.demarchi@profusion.mobi are

poweroff-change-orderly_poweroff-to-use-schedule_work.patch
usermodehelper-export-_exec-and-_setup-functions.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch

