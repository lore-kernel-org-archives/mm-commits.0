From: akpm@linux-foundation.org
Subject: + declare-another-couple-of-compat-syscalls.patch added to -mm tree
Date: Mon, 14 May 2007 19:58:01 -0700
Message-ID: <200705150258.l4F2w1UT032597@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943AbXEOC6K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 22:58:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au


The patch titled
     Declare another couple of compat syscalls
has been added to the -mm tree.  Its filename is
     declare-another-couple-of-compat-syscalls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Declare another couple of compat syscalls
From: Stephen Rothwell <sfr@canb.auug.org.au>

compat_sys_signalfd and compat_sys_timerfd need declarations before
PowerPC can wire them up.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/compat.h~declare-another-couple-of-compat-syscalls include/linux/compat.h
--- a/include/linux/compat.h~declare-another-couple-of-compat-syscalls
+++ a/include/linux/compat.h
@@ -261,5 +261,11 @@ asmlinkage long compat_sys_epoll_pwait(i
 asmlinkage long compat_sys_utimensat(unsigned int dfd, char __user *filename,
 				struct compat_timespec __user *t, int flags);
 
+asmlinkage long compat_sys_signalfd(int ufd,
+				const compat_sigset_t __user *sigmask,
+                                compat_size_t sigsetsize);
+asmlinkage long compat_sys_timerfd(int ufd, int clockid, int flags,
+				const struct compat_itimerspec __user *utmr);
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

revert-maintainers-remove-invalid-list-address-for-tpm.patch
declare-another-couple-of-compat-syscalls.patch
powerpc64-symbols-start-with.patch
