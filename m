From: akpm@linux-foundation.org
Subject: [merged] compat-fix-sys_fanotify_mark.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:59 -0800
Message-ID: <52e80087.lkTT/nC2hcDTc4WD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbaA1TKA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:10:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, stable@vger.kernel.org, ralf@linux-mips.org, mingo@redhat.com, krebbel@linux.vnet.ibm.com, jejb@parisc-linux.org, davem@davemloft.net, benh@kernel.crashing.org, heiko.carstens@de.ibm.com

Subject: [merged] compat-fix-sys_fanotify_mark.patch removed from -mm tree
To: heiko.carstens@de.ibm.com,benh@kernel.crashing.org,davem@davemloft.net,jejb@parisc-linux.org,krebbel@linux.vnet.ibm.com,mingo@redhat.com,ralf@linux-mips.org,stable@vger.kernel.org,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:59 -0800


The patch titled
     Subject: compat: fix sys_fanotify_mark
has been removed from the -mm tree.  Its filename was
     compat-fix-sys_fanotify_mark.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: compat: fix sys_fanotify_mark

91c2e0bcae72 ("unify compat fanotify_mark(2), switch to
COMPAT_SYSCALL_DEFINE") added a new unified compat fanotify_mark syscall
to be used by all architectures.  Unfortunately the unified version merges
the split mask parameter in a wrong way: the lower and higher word got
swapped.

This was discovered with glibc's tst-fanotify test case.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reported-by: Andreas Krebbel <krebbel@linux.vnet.ibm.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Acked-by: "David S. Miller" <davem@davemloft.net>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: <stable@vger.kernel.org>	[3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~compat-fix-sys_fanotify_mark fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~compat-fix-sys_fanotify_mark
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -886,9 +886,9 @@ COMPAT_SYSCALL_DEFINE6(fanotify_mark,
 {
 	return sys_fanotify_mark(fanotify_fd, flags,
 #ifdef __BIG_ENDIAN
-				((__u64)mask1 << 32) | mask0,
-#else
 				((__u64)mask0 << 32) | mask1,
+#else
+				((__u64)mask1 << 32) | mask0,
 #endif
 				 dfd, pathname);
 }
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
fs-compat-fix-parameter-handling-for-compat-readv-writev-syscalls.patch
fs-compat-fix-lookup_dcookie-parameter-handling.patch
s390-compat-change-parameter-types-from-unsigned-long-to-compat_ulong_t.patch
linux-next.patch

