From: akpm@linux-foundation.org
Subject: + lib-harden-strncpy_from_user.patch added to -mm tree
Date: Mon, 29 Aug 2016 14:56:19 -0700
Message-ID: <57c4af83.wMHqzZYkqFqiINU0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38504 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753429AbcH2WHJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 18:07:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.rutland@arm.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: harden strncpy_from_user
has been added to the -mm tree.  Its filename is
     lib-harden-strncpy_from_user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-harden-strncpy_from_user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-harden-strncpy_from_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from mark.rutland@arm.com are

lib-harden-strncpy_from_user.patch

