From: akpm@linux-foundation.org
Subject: + poweroff-fix-bug-in-orderly_poweroff.patch added to -mm tree
Date: Wed, 19 Sep 2012 12:12:39 -0700
Message-ID: <20120919191240.2DDC120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:44961 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab2ISTMm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Sep 2012 15:12:42 -0400
Received: by faet1 with SMTP id t1so83957fae.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Sep 2012 12:12:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hongfeng@marvell.com, ebiederm@xmission.com, keescook@chromium.org, rjw@sisk.pl, serge.hallyn@canonical.com


The patch titled
     Subject: poweroff: fix bug in orderly_poweroff()
has been added to the -mm tree.  Its filename is
     poweroff-fix-bug-in-orderly_poweroff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: hongfeng <hongfeng@marvell.com>
Subject: poweroff: fix bug in orderly_poweroff()

orderly_poweroff is trying to poweroff platform by two steps:

step 1: Call userspace application to poweroff

step 2: If userspace poweroff fail, then do a force power off if force
param is set.

The bug here is, step 1 is always successful with param UMH_NO_WAIT,
should change to UMH_WAIT_EXEC which will monitor whether user application
successful run.

Signed-off-by: Feng Hong <hongfeng@marvell.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
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

poweroff-fix-bug-in-orderly_poweroff.patch

