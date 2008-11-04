From: akpm@linux-foundation.org
Subject: + forkc-cleanup-for-copy_sighand.patch added to -mm tree
Date: Tue, 04 Nov 2008 15:54:59 -0800
Message-ID: <200811042354.mA4NsxFc006783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758769AbYKDXzx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2008 18:55:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhaolei@cn.fujitsu.com, oleg@redhat.com, roland@redhat.com


The patch titled
     fork.c: cleanup for copy_sighand()
has been added to the -mm tree.  Its filename is
     forkc-cleanup-for-copy_sighand.patch

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
Subject: fork.c: cleanup for copy_sighand()
From: Zhaolei <zhaolei@cn.fujitsu.com>

Check CLONE_SIGHAND only is enough, because combination of CLONE_THREAD and
CLONE_SIGHAND is already done in copy_process().

Impact: cleanup, no functionality changed

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/fork.c~forkc-cleanup-for-copy_sighand kernel/fork.c
--- a/kernel/fork.c~forkc-cleanup-for-copy_sighand
+++ a/kernel/fork.c
@@ -745,7 +745,7 @@ static int copy_sighand(unsigned long cl
 {
 	struct sighand_struct *sig;
 
-	if (clone_flags & (CLONE_SIGHAND | CLONE_THREAD)) {
+	if (clone_flags & CLONE_SIGHAND) {
 		atomic_inc(&current->sighand->count);
 		return 0;
 	}
_

Patches currently in -mm which might be from zhaolei@cn.fujitsu.com are

linux-next.patch
forkc-cleanup-for-copy_sighand.patch

