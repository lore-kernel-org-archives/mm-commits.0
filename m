Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956B72E8E0E;
	Mon, 10 Nov 2025 05:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762752038; cv=none; b=IfwGslDiLHk7OEQDL9Pf6rM8pJ8ub3iKFgKL4ToJc13tV648Z49PUK4SDdsmMEPpYIJDa1vQyHGdWdkyy4RUkY4Agw/H4bssUzxJdI7zth6qPQ3UFXi1svQF+XPBbTuFGZcbqHD0bb7T+oTNbnRTp5dEIQsjqs4a1su+M7dgWSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762752038; c=relaxed/simple;
	bh=pInCiCxkDcQYWrWAtQbpqpHMi5LtMkj5GzO46o/XGzM=;
	h=Date:To:From:Subject:Message-Id; b=Dx3dum833d/z1tH3Si6wgjtq9hVeVNi8W5KEo25HpPJvQYzsOzmgoIDF4aHpfABlu9SIIKkvSWa2yQlFCmYuMktfYS5E6nJZIF/NyqQg9N3tWWQE/koQBaLPLBA2m5Z1MkpnWMBk/tLNGOb2p3QOW4h1w2JwapMWLyF5loptjw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=leZG2w7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="leZG2w7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A01C19422;
	Mon, 10 Nov 2025 05:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762752038;
	bh=pInCiCxkDcQYWrWAtQbpqpHMi5LtMkj5GzO46o/XGzM=;
	h=Date:To:From:Subject:From;
	b=leZG2w7/gNrGUB5Z8SLFuwlG/SsGe3XQ0iI0fjD5dhu44xJe5Q4i2UQ0t+TDWHref
	 gbyCFbmCpQMMXMN8i3PE2CN13UEpGXEi8ZxI7bxS2hxT6nhcEwZ9SHqc8LRkU33eEX
	 KW5nH3qOrrWHSkrXCGQugbv95SropJlIiHRD5U/k=
Date: Sun, 09 Nov 2025 21:20:37 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,eadavis@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-avoid-having-an-active-sc_timer-before-freeing-sci.patch removed from -mm tree
Message-Id: <20251110052038.61A01C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: avoid having an active sc_timer before freeing sci
has been removed from the -mm tree.  Its filename was
     nilfs2-avoid-having-an-active-sc_timer-before-freeing-sci.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


