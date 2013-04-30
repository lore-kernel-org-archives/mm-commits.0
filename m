From: akpm@linux-foundation.org
Subject: [merged] gcc4-disable-__compiletime_object_size-for-gcc-46.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:48 -0700
Message-ID: <20130430185048.78C675A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:41266 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3Sut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:50:49 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so86189vbe.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: gcc4: disable __compiletime_object_size for GCC 4.6+
has been removed from the -mm tree.  Its filename was
     gcc4-disable-__compiletime_object_size-for-gcc-46.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: gcc4: disable __compiletime_object_size for GCC 4.6+

__builtin_object_size is known to be broken on gcc 4.6+.
See http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48880 for details.

This causes unnecssary build warnings and errors such as

In function 'copy_from_user', inlined from 'sb16_copy_from_user'
	at sound/oss/sb_audio.c:878:22:
arch/x86/include/asm/uaccess_32.h:211:26: error: call to 'copy_from_user_overflow'
	declared with attribute error: copy_from_user() buffer size is not provably correct
make[3]: [sound/oss/sb_audio.o] Error 1 (ignored)

Disable it where broken.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc4.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/compiler-gcc4.h~gcc4-disable-__compiletime_object_size-for-gcc-46 include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h~gcc4-disable-__compiletime_object_size-for-gcc-46
+++ a/include/linux/compiler-gcc4.h
@@ -13,7 +13,7 @@
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
 
-#if GCC_VERSION >= 40100
+#if GCC_VERSION >= 40100 && GCC_VERSION < 40600
 # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
 #endif
 
_

Patches currently in -mm which might be from linux@roeck-us.net are

origin.patch
linux-next.patch
kernel-compatc-make-do_sysinfo-static.patch
kernel-timerc-convert-compat_sys_sysinfo-to-compat_syscall_define.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch
i2o-check-copy_from_user-size-parameter.patch

