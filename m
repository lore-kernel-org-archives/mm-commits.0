From: akpm@linux-foundation.org
Subject: + gcc4-disable-__compiletime_object_size-for-gcc-46.patch added to -mm tree
Date: Mon, 15 Apr 2013 15:33:37 -0700
Message-ID: <20130415223337.7380B31C145@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:43593 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab3DOWdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Apr 2013 18:33:38 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so333631qcr.2
        for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2013 15:33:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@roeck-us.net, dhowells@redhat.com


The patch titled
     Subject: gcc4: disable __compiletime_object_size for GCC 4.6+
has been added to the -mm tree.  Its filename is
     gcc4-disable-__compiletime_object_size-for-gcc-46.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
gcc4-disable-__compiletime_object_size-for-gcc-46.patch
kernel-compatc-make-do_sysinfo-static.patch
kernel-timerc-convert-compat_sys_sysinfo-to-compat_syscall_define.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch
checkpatch-add-check-for-reuse-of-krealloc-arg.patch
i2o-check-copy_from_user-size-parameter.patch

