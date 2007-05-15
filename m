From: akpm@linux-foundation.org
Subject: - declare-another-couple-of-compat-syscalls.patch removed from -mm tree
Date: Tue, 15 May 2007 01:29:31 -0700
Message-ID: <200705150829.l4F8TVl1005131@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757155AbXEOIaN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 04:30:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Declare another couple of compat syscalls
has been removed from the -mm tree.  Its filename was
     declare-another-couple-of-compat-syscalls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
revert-maintainers-remove-invalid-list-address-for-tpm.patch
declare-another-couple-of-compat-syscalls.patch
powerpc64-symbols-start-with.patch
