From: akpm@linux-foundation.org
Subject: + simplify-compat_sys_timerfd.patch added to -mm tree
Date: Mon, 14 May 2007 12:00:28 -0700
Message-ID: <200705141900.l4EJ0Shl023637@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753645AbXENTBI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 15:01:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, davidel@xmailserver.org


The patch titled
     simplify compat_sys_timerfd
has been added to the -mm tree.  Its filename is
     simplify-compat_sys_timerfd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: simplify compat_sys_timerfd
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Just thought this is easier to read.

Acked-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

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

s390-spinlock-initializer-cleanup.patch
simplify-compat_sys_timerfd.patch
