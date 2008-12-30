From: akpm@linux-foundation.org
Subject: + do_coredump-check-return-from-argv_split.patch added to -mm tree
Date: Tue, 30 Dec 2008 13:15:54 -0800
Message-ID: <200812302115.mBULFsOn028008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541AbYL3VQA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 16:16:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penguin-kernel@i-love.sakura.ne.jppenguin-kernel@i-love.sakura.ne.jp


The patch titled
     do_coredump(): check return from argv_split()
has been added to the -mm tree.  Its filename is
     do_coredump-check-return-from-argv_split.patch

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
Subject: do_coredump(): check return from argv_split()
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

do_coredump() accesses helper_argv[0] without checking helper_argv !=
NULL.  This can happen if page allocation failed.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/exec.c~do_coredump-check-return-from-argv_split fs/exec.c
--- a/fs/exec.c~do_coredump-check-return-from-argv_split
+++ a/fs/exec.c
@@ -1808,6 +1808,11 @@ int do_coredump(long signr, int exit_cod
 
  	if (ispipe) {
 		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
+		if (!helper_argv) {
+			printk(KERN_WARNING "%s failed to allocate memory\n",
+			       __func__);
+			goto fail_unlock;
+		}
 		/* Terminate the string before the first option */
 		delimit = strchr(corename, ' ');
 		if (delimit)
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

do_coredump-check-return-from-argv_split.patch
dma_alloc_from_coherent-fix-fallback-to-generic-memory.patch
dma_alloc_coherent-clean-it-up.patch
dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent.patch

