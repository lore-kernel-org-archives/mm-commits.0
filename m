Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C2B446AB
	for <mm-commits@vger.kernel.org>; Sun,  9 Jun 2024 21:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717967436; cv=none; b=OY9wDEpIOPGi6y6GMHujAqUUaMMO27465eouT40krAVyGFgveRbPsVXF0vSg7CGKCekfEwvtSoEXm7uolf+0AkBvG5LQKdD8+9N5jP++H1/OXFnFLhSv35OAuBQCf1Gf10X/hgwmQbhsy4rNJTWDXb+9JyYP/F/7SKlr7nBqN04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717967436; c=relaxed/simple;
	bh=0Uahb944hLMyUeKKQnPW1eSSdnt9lpJV054v9+LZr7U=;
	h=Date:To:From:Subject:Message-Id; b=SYcyvHbiB4o6E4G75k/cqeJ3hsqiPGI+mFz8NaL/p135RkaVGIwk9DIR1z7rR91IljqT5iY7E6cU38ESDH3rAQOqo9vEo2DwIKZOMBV0KaWQWQ8GX9WgV8YMl2NN6ckmacA+Giyf2v3SSNbMTGE0fD7g7MBTjK+NPGgshpKAm00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RjO29Feo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RjO29Feo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DF5C2BD10;
	Sun,  9 Jun 2024 21:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717967435;
	bh=0Uahb944hLMyUeKKQnPW1eSSdnt9lpJV054v9+LZr7U=;
	h=Date:To:From:Subject:From;
	b=RjO29Feox1r09CnQPPxIbyjkwOCB/duEjopp7HmwsPIsooy2a9hS7VD0if8fOHjDi
	 zL6AX/uLc80QohAUtkKKgYnLzMNNLw702vw7AuG7Ytk8KLAkGCVgbEglzcOuvM7Nxi
	 bWfL5gvoUQHyWGavThpiM0YhbuakZwEe6CgNUG14=
Date: Sun, 09 Jun 2024 14:10:34 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rostedt@goodmis.org,rachelmenge@linux.microsoft.com,qiang.zhang1211@gmail.com,paulmck@kernel.org,neeraj.upadhyay@kernel.org,mjguzik@gmail.com,michael.christie@oracle.com,mathieu.desnoyers@efficios.com,josh@joshtriplett.org,joel@joelfernandes.org,jiangshanlai@gmail.com,j.granados@samsung.com,fuweid89@gmail.com,frederic@kernel.org,brauner@kernel.org,boqun.feng@gmail.com,axboe@kernel.dk,apais@linux.microsoft.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zap_pid_ns_processes-clear-tif_notify_signal-along-with-tif_sigpending.patch added to mm-hotfixes-unstable branch
Message-Id: <20240609211035.78DF5C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zap_pid_ns_processes: clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     zap_pid_ns_processes-clear-tif_notify_signal-along-with-tif_sigpending.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zap_pid_ns_processes-clear-tif_notify_signal-along-with-tif_sigpending.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: zap_pid_ns_processes: clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING
Date: Sat, 8 Jun 2024 14:06:16 +0200

kernel_wait4() doesn't sleep and returns -EINTR if there is no
eligible child and signal_pending() is true.

That is why zap_pid_ns_processes() clears TIF_SIGPENDING but this is not
enough, it should also clear TIF_NOTIFY_SIGNAL to make signal_pending()
return false and avoid a busy-wait loop.

Link: https://lkml.kernel.org/r/20240608120616.GB7947@redhat.com
Fixes: 12db8b690010 ("entry: Add support for TIF_NOTIFY_SIGNAL")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Rachel Menge <rachelmenge@linux.microsoft.com>
Closes: https://lore.kernel.org/all/1386cd49-36d0-4a5c-85e9-bc42056a5a38@linux.microsoft.com/
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Tested-By: Wei Fu <fuweid89@gmail.com>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Zqiang <qiang.zhang1211@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/pid_namespace.c~zap_pid_ns_processes-clear-tif_notify_signal-along-with-tif_sigpending
+++ a/kernel/pid_namespace.c
@@ -218,6 +218,7 @@ void zap_pid_ns_processes(struct pid_nam
 	 */
 	do {
 		clear_thread_flag(TIF_SIGPENDING);
+		clear_thread_flag(TIF_NOTIFY_SIGNAL);
 		rc = kernel_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
_

Patches currently in -mm which might be from oleg@redhat.com are

zap_pid_ns_processes-clear-tif_notify_signal-along-with-tif_sigpending.patch
zap_pid_ns_processes-dont-send-sigkill-to-sub-threads.patch

