From: akpm@linux-foundation.org
Subject: [merged] fs-compat-fix-lookup_dcookie-parameter-handling.patch
 removed from -mm tree
Date: Thu, 30 Jan 2014 12:05:12 -0800
Message-ID: <52eab078.54YUBuzTKeJOm9Zm%akpm__8180.41018578715$1391112331$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaA3UFN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 15:05:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, stable@vger.kernel.org, schwidefsky@de.ibm.com, mingo@kernel.org, hpa@zytor.com, brueckner@linux.vnet.ibm.com, heiko.carstens@de.ibm.com

Subject: [merged] fs-compat-fix-lookup_dcookie-parameter-handling.patch removed from -mm tree
To: heiko.carstens@de.ibm.com,brueckner@linux.vnet.ibm.com,hpa@zytor.com,mingo@kernel.org,schwidefsky@de.ibm.com,stable@vger.kernel.org,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 12:05:12 -0800


The patch titled
     Subject: fs/compat: fix lookup_dcookie() parameter handling
has been removed from the -mm tree.  Its filename was
     fs-compat-fix-lookup_dcookie-parameter-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: fs/compat: fix lookup_dcookie() parameter handling

d5dc77bfeeab0 "consolidate compat lookup_dcookie()" coverted all
architectures to the new compat_sys_lookup_dcookie() syscall.

The "len" paramater of the new compat syscall must have the type
compat_size_t in order to enforce zero extension for architectures where
the ABI requires that the caller of a function performed zero and/or sign
extension to 64 bit of all parameters.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: <stable@vger.kernel.org>	[v3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcookies.c          |    2 +-
 include/linux/compat.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/dcookies.c~fs-compat-fix-lookup_dcookie-parameter-handling fs/dcookies.c
--- a/fs/dcookies.c~fs-compat-fix-lookup_dcookie-parameter-handling
+++ a/fs/dcookies.c
@@ -204,7 +204,7 @@ out:
 }
 
 #ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE4(lookup_dcookie, u32, w0, u32, w1, char __user *, buf, size_t, len)
+COMPAT_SYSCALL_DEFINE4(lookup_dcookie, u32, w0, u32, w1, char __user *, buf, compat_size_t, len)
 {
 #ifdef __BIG_ENDIAN
 	return sys_lookup_dcookie(((u64)w0 << 32) | w1, buf, len);
diff -puN include/linux/compat.h~fs-compat-fix-lookup_dcookie-parameter-handling include/linux/compat.h
--- a/include/linux/compat.h~fs-compat-fix-lookup_dcookie-parameter-handling
+++ a/include/linux/compat.h
@@ -422,7 +422,7 @@ extern long compat_arch_ptrace(struct ta
 asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 				  compat_long_t addr, compat_long_t data);
 
-asmlinkage long compat_sys_lookup_dcookie(u32, u32, char __user *, size_t);
+asmlinkage long compat_sys_lookup_dcookie(u32, u32, char __user *, compat_size_t);
 /*
  * epoll (fs/eventpoll.c) compat bits follow ...
  */
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
linux-next.patch

