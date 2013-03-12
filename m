From: akpm@linux-foundation.org
Subject: + kernel-sysc-use-the-simpler-call_usermodehelper.patch added to -mm tree
Date: Tue, 12 Mar 2013 13:32:30 -0700
Message-ID: <20130312203230.DF1F35A4260@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:44241 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab3CLUcc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 16:32:32 -0400
Received: by mail-qa0-f74.google.com with SMTP id o13so47426qaj.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 13:32:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lucas.demarchi@profusion.mobi, dhowells@redhat.com, james.l.morris@oracle.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: kernel/sys.c: use the simpler call_usermodehelper()
has been added to the -mm tree.  Its filename is
     kernel-sysc-use-the-simpler-call_usermodehelper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kernel-sysc-use-the-simpler-call_usermodehelper.patch
usermodehelper-export-_exec-and-_setup-functions.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch

