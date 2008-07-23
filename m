From: akpm@linux-foundation.org
Subject: - make-u64-long-long-on-all-architectures.patch removed from -mm tree
Date: Tue, 22 Jul 2008 21:55:49 -0700
Message-ID: <200807230455.m6N4tn3w003645__39992.8318373442$1216789036$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571AbYGWEzv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 00:55:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, linux-arch@vger.kernel.org, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Make u64 long long on all architectures
has been removed from the -mm tree.  Its filename was
     make-u64-long-long-on-all-architectures.patch

This patch was dropped because im a wimp

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Make u64 long long on all architectures
From: Matthew Wilcox <matthew@wil.cx>

It is currently awkward to print a u64 type.  Some architectures use
unsigned long while others use unsigned long long.  Since unsigned long
long is 64-bit for all existing Linux architectures, change those that
use long to use long long.  Note that this applies only within the
kernel.  If u64 is being used in a C++ method definition, the symbol
mangling would change.

[akpm@linux-foundation.org: Do u64 and s64 too]
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/int-l64.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/int-l64.h~make-u64-long-long-on-all-architectures include/asm-generic/int-l64.h
--- a/include/asm-generic/int-l64.h~make-u64-long-long-on-all-architectures
+++ a/include/asm-generic/int-l64.h
@@ -23,8 +23,13 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
+#ifdef __KERNEL__
+typedef __signed__ long long __s64;
+typedef unsigned long long __u64;
+#else
 typedef __signed__ long __s64;
 typedef unsigned long __u64;
+#endif
 
 #endif /* __ASSEMBLY__ */
 
@@ -41,8 +46,8 @@ typedef unsigned short u16;
 typedef signed int s32;
 typedef unsigned int u32;
 
-typedef signed long s64;
-typedef unsigned long u64;
+typedef signed long long s64;
+typedef unsigned long long u64;
 
 #define S8_C(x)  x
 #define U8_C(x)  x ## U
_

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
linux-next.patch
parisc-fix-incomplete-header-guard.patch
list-debugging-use-warn_on-instead-of-bug.patch
reiserfs-convert-j_lock-to-mutex.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
ptrace-give-more-respect-to-sigkill.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch
make-u64-long-long-on-all-architectures.patch
make-sure-nobodys-leaking-resources.patch

