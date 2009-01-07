From: akpm@linux-foundation.org
Subject: - do_coredump-check-return-from-argv_split.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:14 -0800
Message-ID: <200901072216.n07MGEtL015955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757484AbZAGWQT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@i-love.sakura.ne.jppenguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     do_coredump(): check return from argv_split()
has been removed from the -mm tree.  Its filename was
     do_coredump-check-return-from-argv_split.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1770,6 +1770,11 @@ int do_coredump(long signr, int exit_cod
 
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

origin.patch

