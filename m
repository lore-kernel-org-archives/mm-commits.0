From: akpm@linux-foundation.org
Subject: - simplify-compat_sys_timerfd.patch removed from -mm tree
Date: Fri, 18 May 2007 00:06:11 -0700
Message-ID: <200705180706.l4I76A4T010154@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43143 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756232AbXERHIV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:08:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     simplify compat_sys_timerfd
has been removed from the -mm tree.  Its filename was
     simplify-compat_sys_timerfd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: simplify compat_sys_timerfd
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Just thought this is easier to read.

Acked-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN fs/compat.c~simplify-compat_sys_timerfd fs/compat.c
--- a/fs/compat.c~simplify-compat_sys_timerfd
+++ a/fs/compat.c
@@ -2230,21 +2230,16 @@ asmlinkage long compat_sys_signalfd(int 
 asmlinkage long compat_sys_timerfd(int ufd, int clockid, int flags,
 				   const struct compat_itimerspec __user *utmr)
 {
-	long res;
 	struct itimerspec t;
 	struct itimerspec __user *ut;
 
-	res = -EFAULT;
 	if (get_compat_itimerspec(&t, utmr))
-		goto err_exit;
+		return -EFAULT;
 	ut = compat_alloc_user_space(sizeof(*ut));
-	if (copy_to_user(ut, &t, sizeof(t)) )
-		goto err_exit;
+	if (copy_to_user(ut, &t, sizeof(t)))
+		return -EFAULT;
 
-	res = sys_timerfd(ufd, clockid, flags, ut);
-err_exit:
-	return res;
+	return sys_timerfd(ufd, clockid, flags, ut);
 }
 
 #endif /* CONFIG_TIMERFD */
-
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
git-s390.patch
s390-spinlock-initializer-cleanup.patch
x86_64-fix-smp_call_function_single-return-value.patch
