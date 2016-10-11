From: akpm@linux-foundation.org
Subject: [patch 009/102] lib: harden strncpy_from_user
Date: Tue, 11 Oct 2016 13:51:27 -0700
Message-ID: <57fd50cf.8eP7AlEbPhEEdkgG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37879 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752266AbcJKUwf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mark.rutland@arm.com, keescook@chromium.org

From: Mark Rutland <mark.rutland@arm.com>
Subject: lib: harden strncpy_from_user

The strncpy_from_user() accessor is effectively a copy_from_user()
specialised to copy strings, terminating early at a NUL byte if possible. 
In other respects it is identical, and can be used to copy an arbitrarily
large buffer from userspace into the kernel.  Conceptually, it exposes a
similar attack surface.

As with copy_from_user(), we check the destination range when the kernel
is built with KASAN, but unlike copy_from_user() we do not check the
destination buffer when using HARDENED_USERCOPY.  As strncpy_from_user()
calls get_user() in a loop, we must call check_object_size() explicitly.

This patch adds this instrumentation to strncpy_from_user(), per the same
rationale as with the regular copy_from_user().  In the absence of
hardened usercopy this will have no impact as the instrumentation expands
to an empty static inline function.

Link: http://lkml.kernel.org/r/1472221903-31181-1-git-send-email-mark.rutland@arm.com
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/strncpy_from_user.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/strncpy_from_user.c~lib-harden-strncpy_from_user lib/strncpy_from_user.c
--- a/lib/strncpy_from_user.c~lib-harden-strncpy_from_user
+++ a/lib/strncpy_from_user.c
@@ -1,6 +1,7 @@
 #include <linux/compiler.h>
 #include <linux/export.h>
 #include <linux/kasan-checks.h>
+#include <linux/thread_info.h>
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -111,6 +112,7 @@ long strncpy_from_user(char *dst, const
 		long retval;
 
 		kasan_check_write(dst, count);
+		check_object_size(dst, count, false);
 		user_access_begin();
 		retval = do_strncpy_from_user(dst, src, count, max);
 		user_access_end();
_
