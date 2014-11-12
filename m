From: akpm@linux-foundation.org
Subject: [merged] param-fix-crash-on-bad-kernel-arguments.patch removed
 from -mm tree
Date: Wed, 12 Nov 2014 12:56:00 -0800
Message-ID: <5463c960.GDYfH73ppq86m7OA%akpm__9338.19305287234$1415825770$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbaKLU4B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 15:56:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.thompson@linaro.org, rusty@rustcorp.com.au, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: param: fix crash on bad kernel arguments
has been removed from the -mm tree.  Its filename was
     param-fix-crash-on-bad-kernel-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -544,7 +544,7 @@ asmlinkage __visible void __init start_k
 				  static_command_line, __start___param,
 				  __stop___param - __start___param,
 				  -1, -1, &unknown_bootoption);
-	if (after_dashes)
+	if (!IS_ERR_OR_NULL(after_dashes))
 		parse_args("Setting init args", after_dashes, NULL, 0, -1, -1,
 			   set_init_arg);
 
_

Patches currently in -mm which might be from daniel.thompson@linaro.org are

linux-next.patch

