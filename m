From: akpm@linux-foundation.org
Subject: [merged] exec-do-not-retry-load_binary-method-if-config_modules=n.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:48 -0700
Message-ID: <201107271927.p6RJRYLD003222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754359Ab1G0T2H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@i-love.sakura.ne.jppenguin-kernel@i-love.sakura.ne.jp, richard@nod.at, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     exec: do not retry load_binary method if CONFIG_MODULES=n
has been removed from the -mm tree.  Its filename was
     exec-do-not-retry-load_binary-method-if-config_modules=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1430,9 +1430,9 @@ int search_binary_handler(struct linux_b
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
@@ -1443,8 +1443,10 @@ int search_binary_handler(struct linux_b
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

origin.patch

