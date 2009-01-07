From: akpm@linux-foundation.org
Subject: - forkc-cleanup-for-copy_sighand.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:15:23 -0800
Message-ID: <200901072215.n07MFNK5015231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752598AbZAGWPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:15:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhaolei@cn.fujitsu.com, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fork.c: cleanup for copy_sighand()
has been removed from the -mm tree.  Its filename was
     forkc-cleanup-for-copy_sighand.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -758,7 +758,7 @@ static int copy_sighand(unsigned long cl
 {
 	struct sighand_struct *sig;
 
-	if (clone_flags & (CLONE_SIGHAND | CLONE_THREAD)) {
+	if (clone_flags & CLONE_SIGHAND) {
 		atomic_inc(&current->sighand->count);
 		return 0;
 	}
_

Patches currently in -mm which might be from zhaolei@cn.fujitsu.com are

origin.patch

