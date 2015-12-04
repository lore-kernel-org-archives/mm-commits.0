From: akpm@linux-foundation.org
Subject: + proc-add-a-reschedule-point-in-proc_readfd_common.patch added
 to -mm tree
Date: Fri, 04 Dec 2015 15:57:08 -0800
Message-ID: <56622854.AS9jVK5x46b1mHIl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbbLDX5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 18:57:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edumazet@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: add a reschedule point in proc_readfd_common()
has been added to the -mm tree.  Its filename is
     proc-add-a-reschedule-point-in-proc_readfd_common.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-add-a-reschedule-point-in-proc_readfd_common.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-add-a-reschedule-point-in-proc_readfd_common.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: proc: add a reschedule point in proc_readfd_common()

User can pass an arbitrary large buffer to getdents().

It is typically a 32KB buffer used by libc scandir() implementation.

When scanning /proc/{pid}/fd, we can hold cpu way too long, so add a
cond_resched() to be kind with other tasks.

We've seen latencies of more than 50ms on real workloads.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/fd.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/fd.c~proc-add-a-reschedule-point-in-proc_readfd_common fs/proc/fd.c
--- a/fs/proc/fd.c~proc-add-a-reschedule-point-in-proc_readfd_common
+++ a/fs/proc/fd.c
@@ -258,6 +258,7 @@ static int proc_readfd_common(struct fil
 				     name, len, instantiate, p,
 				     (void *)(unsigned long)fd))
 			goto out_fd_loop;
+		cond_resched();
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
_

Patches currently in -mm which might be from edumazet@google.com are

proc-add-a-reschedule-point-in-proc_readfd_common.patch

