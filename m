Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BC89475;
	Tue, 21 May 2024 23:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716334719; cv=none; b=JD3XyKtgOfEvJ/JUqv6uGovRYeQEz4prD3dfYEs4s6lfiaOjTuOFmKt2JRm5CgdbLCwdYr8Soj535n6SkjB9xexn7HK0tLLTtOkd2WdCMeO/zbwULHK6RK2lnY8/Icukyl8MTcbg47cT72QJTlennUYxScpmNdF+3O3ElOOxX90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716334719; c=relaxed/simple;
	bh=PREz0aYf4CT1lY11PijxN5ZsN6o2KgHYTWFMtQNhSAo=;
	h=Date:To:From:Subject:Message-Id; b=LV8DnNx8VNIJ8j0vxHk1bu3zY58P0FpgN0it0uRIzqkHlNWwUA592IasFtHiKBJaWgEeGovTbYNDzbAiqQlSl7i8etmW1WqKhH0n0KDzpXChv00qAyCRhe3zttr2G9zguF+YG34PzY8Ke8iZPIxUb41R9XEZVjLwsc4MKfh93mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZCgV2BMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZCgV2BMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FEDC2BD11;
	Tue, 21 May 2024 23:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716334718;
	bh=PREz0aYf4CT1lY11PijxN5ZsN6o2KgHYTWFMtQNhSAo=;
	h=Date:To:From:Subject:From;
	b=ZCgV2BMlwxUPRExCwaENrx9WwtGg/Ow4vmHqCy2kbOT9yCqbkvPDyZF9JE4vEexsf
	 nTN/euE7QSnOeY5MzgWIyyehxuUFw73e7N8FXgzVv1HtSAMMDh+r87irL66x3DMFad
	 UEhkUZZsswgxDoYK7Nnimo0vBGDGzLDlkQhD5RKI=
Date: Tue, 21 May 2024 16:38:37 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sjb7183@psu.edu,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-potential-hang-in-nilfs_detach_log_writer.patch added to mm-hotfixes-unstable branch
Message-Id: <20240521233838.62FEDC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix potential hang in nilfs_detach_log_writer()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-potential-hang-in-nilfs_detach_log_writer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-potential-hang-in-nilfs_detach_log_writer.patch

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix potential hang in nilfs_detach_log_writer()
Date: Mon, 20 May 2024 22:26:21 +0900

Syzbot has reported a potential hang in nilfs_detach_log_writer() called
during nilfs2 unmount.

Analysis revealed that this is because nilfs_segctor_sync(), which
synchronizes with the log writer thread, can be called after
nilfs_segctor_destroy() terminates that thread, as shown in the call trace
below:

nilfs_detach_log_writer
  nilfs_segctor_destroy
    nilfs_segctor_kill_thread  --> Shut down log writer thread
    flush_work
      nilfs_iput_work_func
        nilfs_dispose_list
          iput
            nilfs_evict_inode
              nilfs_transaction_commit
                nilfs_construct_segment (if inode needs sync)
                  nilfs_segctor_sync  --> Attempt to synchronize with
                                          log writer thread
                           *** DEADLOCK ***

Fix this issue by changing nilfs_segctor_sync() so that the log writer
thread returns normally without synchronizing after it terminates, and by
forcing tasks that are already waiting to complete once after the thread
terminates.

The skipped inode metadata flushout will then be processed together in the
subsequent cleanup work in nilfs_segctor_destroy().

Link: https://lkml.kernel.org/r/20240520132621.4054-4-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+e3973c409251e136fdd0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e3973c409251e136fdd0
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Cc: "Bai, Shuangpeng" <sjb7183@psu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-fix-potential-hang-in-nilfs_detach_log_writer
+++ a/fs/nilfs2/segment.c
@@ -2190,6 +2190,14 @@ static int nilfs_segctor_sync(struct nil
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
+		/*
+		 * Synchronize only while the log writer thread is alive.
+		 * Leave flushing out after the log writer thread exits to
+		 * the cleanup work in nilfs_segctor_destroy().
+		 */
+		if (!sci->sc_task)
+			break;
+
 		if (atomic_read(&wait_req.done)) {
 			err = wait_req.err;
 			break;
@@ -2205,7 +2213,7 @@ static int nilfs_segctor_sync(struct nil
 	return err;
 }
 
-static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err)
+static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err, bool force)
 {
 	struct nilfs_segctor_wait_request *wrq, *n;
 	unsigned long flags;
@@ -2213,7 +2221,7 @@ static void nilfs_segctor_wakeup(struct
 	spin_lock_irqsave(&sci->sc_wait_request.lock, flags);
 	list_for_each_entry_safe(wrq, n, &sci->sc_wait_request.head, wq.entry) {
 		if (!atomic_read(&wrq->done) &&
-		    nilfs_cnt32_ge(sci->sc_seq_done, wrq->seq)) {
+		    (force || nilfs_cnt32_ge(sci->sc_seq_done, wrq->seq))) {
 			wrq->err = err;
 			atomic_set(&wrq->done, 1);
 		}
@@ -2362,7 +2370,7 @@ static void nilfs_segctor_notify(struct
 	if (mode == SC_LSEG_SR) {
 		sci->sc_state &= ~NILFS_SEGCTOR_COMMIT;
 		sci->sc_seq_done = sci->sc_seq_accepted;
-		nilfs_segctor_wakeup(sci, err);
+		nilfs_segctor_wakeup(sci, err, false);
 		sci->sc_flush_request = 0;
 	} else {
 		if (mode == SC_FLUSH_FILE)
@@ -2746,6 +2754,13 @@ static void nilfs_segctor_destroy(struct
 		|| sci->sc_seq_request != sci->sc_seq_done);
 	spin_unlock(&sci->sc_state_lock);
 
+	/*
+	 * Forcibly wake up tasks waiting in nilfs_segctor_sync(), which can
+	 * be called from delayed iput() via nilfs_evict_inode() and can race
+	 * with the above log writer thread termination.
+	 */
+	nilfs_segctor_wakeup(sci, 0, true);
+
 	if (flush_work(&sci->sc_iput_work))
 		flag = true;
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-use-after-free-of-timer-for-log-writer-thread.patch
nilfs2-fix-unexpected-freezing-of-nilfs_segctor_sync.patch
nilfs2-fix-potential-hang-in-nilfs_detach_log_writer.patch

