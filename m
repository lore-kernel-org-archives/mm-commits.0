From: akpm@linux-foundation.org
Subject: + poll-select-initialize-triggered-field-of-struct-poll_wqueues.patch added to -mm tree
Date: Sat, 15 Aug 2009 12:04:17 -0700
Message-ID: <200908151904.n7FJ4HVm000852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbZHOTGJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Aug 2009 15:06:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gknispel@proformatique.com, davidel@xmailserver.org, hch@infradead.org, mszeredi@suse.cz, tj@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     poll/select: initialize triggered field of struct poll_wqueues
has been added to the -mm tree.  Its filename is
     poll-select-initialize-triggered-field-of-struct-poll_wqueues.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

poll-select-initialize-triggered-field-of-struct-poll_wqueues.patch

