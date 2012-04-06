From: akpm@linux-foundation.org
Subject: [merged] sysrq-use-send_sig_forced-instead-of-force_sig.patch removed from -mm tree
Date: Fri, 06 Apr 2012 11:48:44 -0700
Message-ID: <20120406184844.8D9C4A0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:51472 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2DFSsq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 14:48:46 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so142012wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 11:48:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton.vorontsov@linaro.org, alan@linux.intel.com, gregkh@linuxfoundation.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysrq: use SEND_SIG_FORCED instead of force_sig()
has been removed from the -mm tree.  Its filename was
     sysrq-use-send_sig_forced-instead-of-force_sig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from anton.vorontsov@linaro.org are

origin.patch

