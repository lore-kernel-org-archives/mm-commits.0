From: akpm@linux-foundation.org
Subject: + sysrq-use-send_sig_forced-instead-of-force_sig.patch added to -mm tree
Date: Mon, 26 Mar 2012 15:42:11 -0700
Message-ID: <20120326224211.A6B8AA023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:44163 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2CZWmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 18:42:13 -0400
Received: by eaaq10 with SMTP id q10so294719eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 15:42:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton.vorontsov@linaro.org, alan@linux.intel.com, gregkh@linuxfoundation.org, oleg@redhat.com


The patch titled
     Subject: sysrq: use SEND_SIG_FORCED instead of force_sig()
has been added to the -mm tree.  Its filename is
     sysrq-use-send_sig_forced-instead-of-force_sig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: sysrq: use SEND_SIG_FORCED instead of force_sig()

Change send_sig_all() to use do_send_sig_info(SEND_SIG_FORCED)
instead of force_sig(SIGKILL). With the recent changes we do not
need force_ to kill the CLONE_NEWPID tasks.

And this is more correct. force_sig() can race with the exiting
thread, while do_send_sig_info(group => true) kill the whole
process.

Some more notes from Oleg Nesterov:

> Just one note. This change makes no difference for sysrq_handle_kill().
> But it obviously changes the behaviour sysrq_handle_term(). I think
> this is fine, if you want to really kill the task which blocks/ignores
> SIGTERM you can use sysrq_handle_kill().
>
> Even ignoring the reasons why force_sig() is simply wrong here,
> force_sig(SIGTERM) looks strange. The task won't be killed if it has
> a handler, but SIG_IGN can't help. However if it has the handler
> but blocks SIGTERM temporary (this is very common) it will be killed.

Also,

> force_sig() can't kill the process if the main thread has already
> exited. IOW, it is trivial to create the process which can't be
> killed by sysrq.

So, this patch fixes the issue.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/tty/sysrq.c~sysrq-use-send_sig_forced-instead-of-force_sig drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~sysrq-use-send_sig_forced-instead-of-force_sig
+++ a/drivers/tty/sysrq.c
@@ -327,7 +327,7 @@ static void send_sig_all(int sig)
 		if (is_global_init(p))
 			continue;
 
-		force_sig(sig, p);
+		do_send_sig_info(sig, SEND_SIG_FORCED, p, true);
 	}
 	read_unlock(&tasklist_lock);
 }
_
Subject: Subject: sysrq: use SEND_SIG_FORCED instead of force_sig()

Patches currently in -mm which might be from anton.vorontsov@linaro.org are

origin.patch
linux-next.patch
sysrq-use-send_sig_forced-instead-of-force_sig.patch

