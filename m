From: akpm@linux-foundation.org
Subject: [merged] poll-select-initialize-triggered-field-of-struct-poll_wqueues.patch removed from -mm tree
Date: Mon, 17 Aug 2009 13:04:50 -0700
Message-ID: <200908172004.n7HK4pk4017437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756829AbZHQUGq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 16:06:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gknispel@proformatique.com, davidel@xmailserver.org, hch@infradead.org, mszeredi@suse.cz, stable@kernel.org, tglx@linutronix.de, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vge


The patch titled
     poll/select: initialize triggered field of struct poll_wqueues
has been removed from the -mm tree.  Its filename was
     poll-select-initialize-triggered-field-of-struct-poll_wqueues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: poll/select: initialize triggered field of struct poll_wqueues
From: Guillaume Knispel <gknispel@proformatique.com>

The triggered field of struct poll_wqueues introduced in commit
5f820f648c92a5ecc771a96b3c29aa6e90013bba "poll: allow f_op->poll to sleep"
was set to 1 in pollwake() (now __pollwake() ), tested and later set to 0
in poll_schedule_timeout(), but not initialized before.

As a result when the process needs to sleep, triggered was likely to be
non-zero even if pollwake() is not called before the first
poll_schedule_timeout(), meaning schedule_hrtimeout_range() would not be
called and an extra loop calling all ->poll() would be done.

This patch initializes `triggered' to 0 in poll_initwait() so the ->poll()
are not called twice before the process goes to sleep when it needs to.

Signed-off-by: Guillaume Knispel <gknispel@proformatique.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/select.c~poll-select-initialize-triggered-field-of-struct-poll_wqueues fs/select.c
--- a/fs/select.c~poll-select-initialize-triggered-field-of-struct-poll_wqueues
+++ a/fs/select.c
@@ -110,6 +110,7 @@ void poll_initwait(struct poll_wqueues *
 {
 	init_poll_funcptr(&pwq->pt, __pollwait);
 	pwq->polling_task = current;
+	pwq->triggered = 0;
 	pwq->error = 0;
 	pwq->table = NULL;
 	pwq->inline_index = 0;
_

Patches currently in -mm which might be from gknispel@proformatique.com are

origin.patch

