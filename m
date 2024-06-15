Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10EA1EB3D
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 17:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473435; cv=none; b=JO2H6e48pAvXuU6ibNgpPWGhKdjMWdhGHcqaMSQaYWrmRLFrS8qor+8osCExTS5DKf1NZhEuV2Gg+TBycavjQgvtM1feZgmXC90z8b6KoGDn8qEcVM3j/2UNqPAYeGYVc7akXxZowuk08zvaMwBdYWQUIBjtUzIb9ci0jXhpvTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473435; c=relaxed/simple;
	bh=oa80byD9RfO9odtUOn5jAl0ypJPjMUyX8s4md+OoMpw=;
	h=Date:To:From:Subject:Message-Id; b=OLdoCCVnL6b5LWkWLUcVO/1dQ4NJQ2qVJqoF6OO5lvVyZvkyB/biW4NggOM0mmlrs7pDAe/j1mpZdLirs1IqJv9BHfZG64MPCZVjn8/9MPQTMaBMU1RoWQ0t2njoFffalZF7I+d7zChYOUEvSjFlWySn+oMS0nBsUaoEuEQs56Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=meBjCkaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="meBjCkaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753A0C116B1;
	Sat, 15 Jun 2024 17:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473435;
	bh=oa80byD9RfO9odtUOn5jAl0ypJPjMUyX8s4md+OoMpw=;
	h=Date:To:From:Subject:From;
	b=meBjCkaziFGXbdngkNfLgNu0X4qBCQYS4TQhX7ZoyHn3q9V/nMbaHNEU3Wjx/lVym
	 dW9h82UG3oS3tKMnkQElH6+OmnQKHjrnk0+sjgBM8ZQB8eLFLV8jCVdga/AJtKevAv
	 sh/IY8c0Lh9rak2kEkCKQgwqV/RWfaW8a0QQTrwI=
Date: Sat, 15 Jun 2024 10:43:54 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rostedt@goodmis.org,rachelmenge@linux.microsoft.com,qiang.zhang1211@gmail.com,paulmck@kernel.org,neeraj.upadhyay@kernel.org,mjguzik@gmail.com,michael.christie@oracle.com,mathieu.desnoyers@efficios.com,josh@joshtriplett.org,joel@joelfernandes.org,jiangshanlai@gmail.com,j.granados@samsung.com,fuweid89@gmail.com,frederic@kernel.org,brauner@kernel.org,boqun.feng@gmail.com,axboe@kernel.dk,apais@linux.microsoft.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] zap_pid_ns_processes-clear-tif_notify_signal-along-with-tif_sigpending.patch removed from -mm tree
Message-Id: <20240615174355.753A0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zap_pid_ns_processes: clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING
has been removed from the -mm tree.  Its filename was
     zap_pid_ns_processes-clear-tif_notify_signal-along-with-tif_sigpending.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Tested-by: Wei Fu <fuweid89@gmail.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
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

zap_pid_ns_processes-dont-send-sigkill-to-sub-threads.patch

