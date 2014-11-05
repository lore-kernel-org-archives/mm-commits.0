From: akpm@linux-foundation.org
Subject: + param-fix-crash-on-bad-kernel-arguments.patch added to -mm tree
Date: Wed, 05 Nov 2014 14:13:35 -0800
Message-ID: <545aa10f.qA8awqx4syhdIUgp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaKEWNe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2014 17:13:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.thompson@linaro.org, rusty@rustcorp.com.au, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: param: fix crash on bad kernel arguments
has been added to the -mm tree.  Its filename is
     param-fix-crash-on-bad-kernel-arguments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/param-fix-crash-on-bad-kernel-arguments.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/param-fix-crash-on-bad-kernel-arguments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: param: fix crash on bad kernel arguments

Currently if the user passes an invalid value on the kernel command line
then the kernel will crash during argument parsing.  On most systems this
is very hard to debug because the console hasn't been initialized yet.

This is a regression due to commit 51e158c12aca ("param: hand arguments
after -- straight to init") which, in response to the systemd debug
controversy, made it possible to explicitly pass arguments to init.  To
achieve this parse_args() was extended from simply returning an error code
to returning a pointer.  Regretably the new init args logic does not
perform a proper validity check on the pointer resulting in a crash.

This patch fixes the validity check.  Should the check fail then no
arguments will be passed to init.  This is reasonable and matches how the
kernel treats its own arguments (i.e.  no error recovery).

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/main.c~param-fix-crash-on-bad-kernel-arguments init/main.c
--- a/init/main.c~param-fix-crash-on-bad-kernel-arguments
+++ a/init/main.c
@@ -538,7 +538,7 @@ asmlinkage __visible void __init start_k
 				  static_command_line, __start___param,
 				  __stop___param - __start___param,
 				  -1, -1, &unknown_bootoption);
-	if (after_dashes)
+	if (!IS_ERR_OR_NULL(after_dashes))
 		parse_args("Setting init args", after_dashes, NULL, 0, -1, -1,
 			   set_init_arg);
 
_

Patches currently in -mm which might be from daniel.thompson@linaro.org are

param-fix-crash-on-bad-kernel-arguments.patch
kgdb-timeout-if-secondary-cpus-ignore-the-roundup.patch
linux-next.patch

