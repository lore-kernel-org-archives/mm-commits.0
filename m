From: akpm@linux-foundation.org
Subject: - sys_time-use-barrier-instead-of-smp_rmb.patch removed from -mm tree
Date: Fri, 20 Jul 2007 14:54:20 -0700
Message-ID: <200707202154.l6KLsKAH018458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53703 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759016AbXGTVys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 17:54:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, csnook@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sys_time: use barrier() instead of smp_rmb()
has been removed from the -mm tree.  Its filename was
     sys_time-use-barrier-instead-of-smp_rmb.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: sys_time: use barrier() instead of smp_rmb()
From: Oleg Nesterov <oleg@tv-sign.ru>

There is no reason to use rmb(), we don't do any LOADs which could be
reordered.  What we need is a simple compiler barrier, to prevent the
reading of the "volatile" xtime.tv_sec twice.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Chris Snook <csnook@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time.c~sys_time-use-barrier-instead-of-smp_rmb kernel/time.c
--- a/kernel/time.c~sys_time-use-barrier-instead-of-smp_rmb
+++ a/kernel/time.c
@@ -64,7 +64,7 @@ asmlinkage long sys_time(time_t __user *
 	 */
 	time_t i = xtime.tv_sec;
 
-	smp_rmb(); /* sys_time() results are coherent */
+	barrier(); /* sys_time() results are coherent */
 
 	if (tloc) {
 		if (put_user(i, tloc))
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
i386-remove-unnecessary-code.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
sys_time-use-barrier-instead-of-smp_rmb.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_poll-return-eintr-when-signalled.patch
idr_remove_all-kill-unused-variable.patch
