From: akpm@linux-foundation.org
Subject: + exec-do-not-retry-load_binary-method-if-config_modules=n.patch added to -mm tree
Date: Mon, 11 Jul 2011 13:14:09 -0700
Message-ID: <201107112014.p6BKE9BF000731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753165Ab1GKUOy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jul 2011 16:14:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penguin-kernel@i-love.sakura.ne.jppenguin-kernel@i-love.sakura.ne.jp, richard@nod.at, viro@zeniv.linux.org.uk


The patch titled
     exec: do not retry load_binary method if CONFIG_MODULES=n
has been added to the -mm tree.  Its filename is
     exec-do-not-retry-load_binary-method-if-config_modules=n.patch

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
Subject: exec: do not retry load_binary method if CONFIG_MODULES=n
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

If CONFIG_MODULES=n, it makes no sense to retry the list of binary formats
handler because the list will not be modified by request_module().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Richard Weinberger <richard@nod.at>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~exec-do-not-retry-load_binary-method-if-config_modules=n fs/exec.c
--- a/fs/exec.c~exec-do-not-retry-load_binary-method-if-config_modules=n
+++ a/fs/exec.c
@@ -1422,9 +1422,9 @@ int search_binary_handler(struct linux_b
 			}
 		}
 		read_unlock(&binfmt_lock);
+#ifdef CONFIG_MODULES
 		if (retval != -ENOEXEC || bprm->mm == NULL) {
 			break;
-#ifdef CONFIG_MODULES
 		} else {
 #define printable(c) (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))
 			if (printable(bprm->buf[0]) &&
@@ -1435,8 +1435,10 @@ int search_binary_handler(struct linux_b
 			if (try)
 				break; /* -ENOEXEC */
 			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
-#endif
 		}
+#else
+		break;
+#endif
 	}
 	return retval;
 }
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

exec-do-not-retry-load_binary-method-if-config_modules=n.patch

