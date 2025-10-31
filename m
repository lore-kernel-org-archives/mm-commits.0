Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CFC273803;
	Fri, 31 Oct 2025 04:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761884411; cv=none; b=h/j1ovDnkHqSUD7MyjSFd9i0rzMmx03/jltChqTjC54y3qGP+SxhodnDUqc51u2yIhWL1TBoLbTfQzxaA/fcovfM8iBd++L8Q5eFcLXzXNN9k3iCgO2YXoD7duzHftziLuuvD6FT+3rfAfnYkcfFW56uHz48dXdAfmMNNli5plA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761884411; c=relaxed/simple;
	bh=RpWLEx/hY1HUCYETjsc6DQVxiV1NBa7nSxNwgCcxgNk=;
	h=Date:To:From:Subject:Message-Id; b=u+pC/QmQGeMgoYCS8GRKuIxmSaHeELA2c8FDPFwDEJzdQoapujrRrMDuJ/mJHHjOwizHDLRd1qNe4lVpt8IzOd5zvzJRiaO0TLbrA2EW97SUaqiW3lLPJlWycxwEl9K4evqfUmzn0b/h5ED0aavvIEhk9Ya9sFaGcm1Vu/7JFEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HWBxe1fx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HWBxe1fx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764EEC4CEE7;
	Fri, 31 Oct 2025 04:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761884410;
	bh=RpWLEx/hY1HUCYETjsc6DQVxiV1NBa7nSxNwgCcxgNk=;
	h=Date:To:From:Subject:From;
	b=HWBxe1fxUGw92nexDm4N0E3wEmEx0geilB3w2iSvJBxKfVgV3SxiuDl6eD/UkVIQ+
	 lDy7ZgFZRHk3NPqcwxRvG6H9mSDMBY17Gss7ZWTkBgC1opWlOI4L8kF6EsFTRpB+o1
	 +mfKJ74WzEhqWoo0noyz9NwTvPMFOvqiL/tDXZoI=
Date: Thu, 30 Oct 2025 21:20:09 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,eadavis@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-avoid-having-an-active-sc_timer-before-freeing-sci.patch added to mm-hotfixes-unstable branch
Message-Id: <20251031042010.764EEC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: avoid having an active sc_timer before freeing sci
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-avoid-having-an-active-sc_timer-before-freeing-sci.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-avoid-having-an-active-sc_timer-before-freeing-sci.patch

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
From: Edward Adam Davis <eadavis@qq.com>
Subject: nilfs2: avoid having an active sc_timer before freeing sci
Date: Thu, 30 Oct 2025 07:51:52 +0900

Because kthread_stop did not stop sc_task properly and returned -EINTR,
the sc_timer was not properly closed, ultimately causing the problem [1]
reported by syzbot when freeing sci due to the sc_timer not being closed.

Because the thread sc_task main function nilfs_segctor_thread() returns 0
when it succeeds, when the return value of kthread_stop() is not 0 in
nilfs_segctor_destroy(), we believe that it has not properly closed
sc_timer.

We use timer_shutdown_sync() to sync wait for sc_timer to shutdown, and
set the value of sc_task to NULL under the protection of lock
sc_state_lock, so as to avoid the issue caused by sc_timer not being
properly shutdowned.

[1]
ODEBUG: free active (active state 0) object: 00000000dacb411a object type: timer_list hint: nilfs_construction_timeout
Call trace:
 nilfs_segctor_destroy fs/nilfs2/segment.c:2811 [inline]
 nilfs_detach_log_writer+0x668/0x8cc fs/nilfs2/segment.c:2877
 nilfs_put_super+0x4c/0x12c fs/nilfs2/super.c:509

Link: https://lkml.kernel.org/r/20251029225226.16044-1-konishi.ryusuke@gmail.com
Fixes: 3f66cc261ccb ("nilfs2: use kthread_create and kthread_stop for the log writer thread")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=24d8b70f039151f65590
Tested-by: syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Cc: <stable@vger.kernel.org>	[6.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/segment.c~nilfs2-avoid-having-an-active-sc_timer-before-freeing-sci
+++ a/fs/nilfs2/segment.c
@@ -2768,7 +2768,12 @@ static void nilfs_segctor_destroy(struct
 
 	if (sci->sc_task) {
 		wake_up(&sci->sc_wait_daemon);
-		kthread_stop(sci->sc_task);
+		if (kthread_stop(sci->sc_task)) {
+			spin_lock(&sci->sc_state_lock);
+			sci->sc_task = NULL;
+			timer_shutdown_sync(&sci->sc_timer);
+			spin_unlock(&sci->sc_state_lock);
+		}
 	}
 
 	spin_lock(&sci->sc_state_lock);
_

Patches currently in -mm which might be from eadavis@qq.com are

nilfs2-avoid-having-an-active-sc_timer-before-freeing-sci.patch

