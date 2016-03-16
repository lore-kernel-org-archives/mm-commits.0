From: akpm@linux-foundation.org
Subject: [merged]
 autofs4-fix-coding-style-line-length-in-autofs4_wait.patch removed from -mm tree
Date: Wed, 16 Mar 2016 12:57:51 -0700
Message-ID: <56e9babf.kVTHNCXiAhaEPpMJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934130AbcCPT5w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: fix coding style line length in autofs4_wait()
has been removed from the -mm tree.  Its filename was
     autofs4-fix-coding-style-line-length-in-autofs4_wait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


