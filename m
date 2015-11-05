From: akpm@linux-foundation.org
Subject: + mm-oom-add-comment-for-why-oom_adj-exists.patch added to -mm
 tree
Date: Wed, 04 Nov 2015 17:32:44 -0800
Message-ID: <563ab1bc.JtV7t6E+yaBgxFbj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030822AbbKEBcp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Nov 2015 20:32:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: add comment for why oom_adj exists
has been added to the -mm tree.  Its filename is
     mm-oom-add-comment-for-why-oom_adj-exists.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-add-comment-for-why-oom_adj-exists.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-add-comment-for-why-oom_adj-exists.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: add comment for why oom_adj exists

/proc/pid/oom_adj exists solely to avoid breaking existing userspace
binaries that write to the tunable.

Add a comment in the only possible location within the kernel tree to
describe the situation and motivation for keeping it around.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/proc/base.c~mm-oom-add-comment-for-why-oom_adj-exists fs/proc/base.c
--- a/fs/proc/base.c~mm-oom-add-comment-for-why-oom_adj-exists
+++ a/fs/proc/base.c
@@ -1032,6 +1032,16 @@ static ssize_t oom_adj_read(struct file
 	return simple_read_from_buffer(buf, count, ppos, buffer, len);
 }
 
+/*
+ * /proc/pid/oom_adj exists solely for backwards compatibility with previous
+ * kernels.  The effective policy is defined by oom_score_adj, which has a
+ * different scale: oom_adj grew exponentially and oom_score_adj grows linearly.
+ * Values written to oom_adj are simply mapped linearly to oom_score_adj.
+ * Processes that become oom disabled via oom_adj will still be oom disabled
+ * with this implementation.
+ *
+ * oom_adj cannot be removed since existing userspace binaries use it.
+ */
 static ssize_t oom_adj_write(struct file *file, const char __user *buf,
 			     size_t count, loff_t *ppos)
 {
_

Patches currently in -mm which might be from rientjes@google.com are

mm-oom-remove-task_lock-protecting-comm-printing.patch
mm-oom-add-comment-for-why-oom_adj-exists.patch

