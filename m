From: akpm@linux-foundation.org
Subject: + fs-compat-fix-lookup_dcookie-parameter-handling.patch added to
 -mm tree
Date: Mon, 27 Jan 2014 14:49:50 -0800
Message-ID: <52e6e28e.uYu++uv03K07Kc0J%akpm__15841.5839229294$1390863011$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbaA0Wtv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jan 2014 17:49:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, stable@vger.kernel.org, schwidefsky@de.ibm.com, mingo@kernel.org, hpa@zytor.com, brueckner@linux.vnet.ibm.com, heiko.carstens@de.ibm.com

Subject: + fs-compat-fix-lookup_dcookie-parameter-handling.patch added to -mm tree
To: heiko.carstens@de.ibm.com,brueckner@linux.vnet.ibm.com,hpa@zytor.com,mingo@kernel.org,schwidefsky@de.ibm.com,stable@vger.kernel.org,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 27 Jan 2014 14:49:50 -0800


The patch titled
     Subject: fs/compat: fix lookup_dcookie() parameter handling
has been added to the -mm tree.  Its filename is
     fs-compat-fix-lookup_dcookie-parameter-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-compat-fix-lookup_dcookie-parameter-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-compat-fix-lookup_dcookie-parameter-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
fs-compat-fix-parameter-handling-for-compat-readv-writev-syscalls.patch
fs-compat-fix-lookup_dcookie-parameter-handling.patch
s390-compat-change-parameter-types-from-unsigned-long-to-compat_ulong_t.patch
linux-next.patch
compat-fix-sys_fanotify_mark.patch

