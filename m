From: akpm@linux-foundation.org
Subject: + exec-do-not-call-request_module-twice-from-search_binary_handler.patch added to -mm tree
Date: Wed, 06 Jul 2011 13:21:45 -0700
Message-ID: <201107062021.p66KLjKa028996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756127Ab1GFUWY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2011 16:22:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penguin-kernel@I-love.SAKURA.ne.jp, richard@nod.at, viro@zeniv.linux.org.uk


The patch titled
     exec: do not call request_module() twice from search_binary_handler()
has been added to the -mm tree.  Its filename is
     exec-do-not-call-request_module-twice-from-search_binary_handler.patch

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
@@ -1432,6 +1432,8 @@ int search_binary_handler(struct linux_b
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

linux-next.patch
exec-do-not-call-request_module-twice-from-search_binary_handler.patch

