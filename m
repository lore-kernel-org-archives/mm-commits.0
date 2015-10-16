From: akpm@linux-foundation.org
Subject: [obsolete]
 compiler-read_once-fix-build-failure-with-some-older-gcc.patch removed from -mm tree
Date: Fri, 16 Oct 2015 13:12:13 -0700
Message-ID: <56215a1d.dReyYqRl6JezNcM7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbbJPUMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Oct 2015 16:12:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, mingo@kernel.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler, READ_ONCE: Fix build failure with some older GCC
has been removed from the -mm tree.  Its filename was
     compiler-read_once-fix-build-failure-with-some-older-gcc.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: compiler, READ_ONCE: Fix build failure with some older GCC

Some old versions of GCC doesn't handle __alias (or maybe a combination
of 'static __always_inline __alias') right.

GCC creates outline and unused copy of __read_once_size_check()
function in the object file which references memcpy and causes
the build failure:
	arch/x86/entry/vdso/vclock_gettime.o: In function `__read_once_size_check':
	vclock_gettime.c:(.text+0x5f): undefined reference to `memcpy'
	arch/x86/entry/vdso/vgetcpu.o: In function `__read_once_size_check':
	vgetcpu.c:(.text+0x2f): undefined reference to `memcpy'

We could avoid using alias to work around this problem.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/compiler.h~compiler-read_once-fix-build-failure-with-some-older-gcc include/linux/compiler.h
--- a/include/linux/compiler.h~compiler-read_once-fix-build-failure-with-some-older-gcc
+++ a/include/linux/compiler.h
@@ -231,8 +231,11 @@ void __read_once_size_nocheck(const vola
 	__READ_ONCE_SIZE;
 }
 #else
-static __always_inline __alias(__read_once_size_check)
-void __read_once_size_nocheck(const volatile void *p, void *res, int size);
+static __always_inline
+void __read_once_size_nocheck(const volatile void *p, void *res, int size)
+{
+	__READ_ONCE_SIZE;
+}
 #endif
 
 static __always_inline void __write_once_size(volatile void *p, void *res, int size)
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are


