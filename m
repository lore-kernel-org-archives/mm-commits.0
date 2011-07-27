From: akpm@linux-foundation.org
Subject: [merged] exec-do-not-call-request_module-twice-from-search_binary_handler.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:46 -0700
Message-ID: <201107271927.p6RJRWMS003219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754359Ab1G0T2N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, richard@nod.at, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     exec: do not call request_module() twice from search_binary_handler()
has been removed from the -mm tree.  Its filename was
     exec-do-not-call-request_module-twice-from-search_binary_handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exec: do not call request_module() twice from search_binary_handler()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Currently, search_binary_handler() tries to load binary loader module
using request_module() if a loader for the requested program is not yet
loaded.  But second attempt of request_module() does not affect the result
of search_binary_handler().

If request_module() triggered recursion, calling request_module() twice
causes 2 to the power of MAX_KMOD_CONCURRENT (= 50) repetitions.  It is
not an infinite loop but is sufficient for users to consider as a hang up.

Therefore, this patch changes not to call request_module() twice, making 1
to the power of MAX_KMOD_CONCURRENT repetitions in case of recursion.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: Richard Weinberger <richard@nod.at>
Tested-by: Richard Weinberger <richard@nod.at>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/exec.c~exec-do-not-call-request_module-twice-from-search_binary_handler fs/exec.c
--- a/fs/exec.c~exec-do-not-call-request_module-twice-from-search_binary_handler
+++ a/fs/exec.c
@@ -1440,6 +1440,8 @@ int search_binary_handler(struct linux_b
 			    printable(bprm->buf[2]) &&
 			    printable(bprm->buf[3]))
 				break; /* -ENOEXEC */
+			if (try)
+				break; /* -ENOEXEC */
 			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
 #endif
 		}
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

origin.patch
linux-next.patch

