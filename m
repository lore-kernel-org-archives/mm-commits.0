From: akpm@linux-foundation.org
Subject: + autofs4-fix-coding-style-line-length-in-autofs4_wait.patch
 added to -mm tree
Date: Tue, 02 Feb 2016 19:42:23 -0800
Message-ID: <56b1771f.i1DsvJe4IHyicZQs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823AbcBCDmY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 22:42:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: fix coding style line length in autofs4_wait()
has been added to the -mm tree.  Its filename is
     autofs4-fix-coding-style-line-length-in-autofs4_wait.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs4-fix-coding-style-line-length-in-autofs4_wait.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs4-fix-coding-style-line-length-in-autofs4_wait.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs4: fix coding style line length in autofs4_wait()

The need for this is questionable but checkpatch.pl complains about the
line length and it's a straightfoward change.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/waitq.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/autofs4/waitq.c~autofs4-fix-coding-style-line-length-in-autofs4_wait fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-fix-coding-style-line-length-in-autofs4_wait
+++ a/fs/autofs4/waitq.c
@@ -476,12 +476,14 @@ int autofs4_wait(struct autofs_sb_info *
 	 */
 	if (wq->name.name) {
 		/* Block all but "shutdown" signals while waiting */
-		sigset_t oldset;
+		unsigned long shutdown_sigs_mask;
 		unsigned long irqflags;
+		sigset_t oldset;
 
 		spin_lock_irqsave(&current->sighand->siglock, irqflags);
 		oldset = current->blocked;
-		siginitsetinv(&current->blocked, SHUTDOWN_SIGS & ~oldset.sig[0]);
+		shutdown_sigs_mask = SHUTDOWN_SIGS & ~oldset.sig[0];
+		siginitsetinv(&current->blocked, shutdown_sigs_mask);
 		recalc_sigpending();
 		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
 
_

Patches currently in -mm which might be from raven@themaw.net are

autofs4-coding-style-fixes.patch
autofs4-fix-coding-style-problem-in-autofs4_get_set_timeout.patch
autofs4-fix-coding-style-line-length-in-autofs4_wait.patch
autofs4-fix-invalid-ioctl-return-in-autofs4_root_ioctl_unlocked.patch
autofs4-fix-some-white-space-errors.patch
autofs4-fix-stringh-include-in-auto_dev-ioctlh.patch

