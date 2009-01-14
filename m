From: akpm@linux-foundation.org
Subject: [nacked] sys_waitid-return-efault-for-null.patch removed from -mm tree
Date: Tue, 13 Jan 2009 16:50:06 -0800
Message-ID: <200901140050.n0E0o6WS023988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753638AbZANAux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 19:50:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, drepper@redhat.com, mtk.manpages@gmail.com, stable@kernel.org, vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sys_waitid: return -EFAULT for NULL
has been removed from the -mm tree.  Its filename was
     sys_waitid-return-efault-for-null.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_waitid: return -EFAULT for NULL
From: Roland McGrath <roland@redhat.com>

It's always been invalid to call waitid() with a NULL pointer.  It was an
oversight that it was allowed (and acts like a wait4() call instead).

Signed-off-by: Roland McGrath <roland@redhat.com>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: <stable@kernel.org>		[2.6.everything :(]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/exit.c~sys_waitid-return-efault-for-null kernel/exit.c
--- a/kernel/exit.c~sys_waitid-return-efault-for-null
+++ a/kernel/exit.c
@@ -1757,6 +1757,8 @@ asmlinkage long sys_waitid(int which, pi
 	enum pid_type type;
 	long ret;
 
+	if (unlikely(!infop))
+		return -EFAULT;
 	if (options & ~(WNOHANG|WNOWAIT|WEXITED|WSTOPPED|WCONTINUED))
 		return -EINVAL;
 	if (!(options & (WEXITED|WSTOPPED|WCONTINUED)))
_

Patches currently in -mm which might be from roland@redhat.com are

sys_waitid-return-efault-for-null.patch

