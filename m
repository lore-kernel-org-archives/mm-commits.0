From: akpm@linux-foundation.org
Subject: + samples-vfs-avoid-warning-in-statx-override.patch added
 to -mm tree
Date: Tue, 30 Jun 2020 18:59:29 -0700
Message-ID: <20200701015929.GlM5H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgGAB7a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 21:59:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, mszeredi@redhat.com, dhowells@redhat.com, keescook@chromium.org


The patch titled
     Subject: samples/vfs: avoid warning in statx override
has been added to the -mm tree.  Its filename is
     samples-vfs-avoid-warning-in-statx-override.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/samples-vfs-avoid-warning-in-statx-override.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/samples-vfs-avoid-warning-in-statx-override.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: samples/vfs: avoid warning in statx override

Something changed recently to uncover this warning:

samples/vfs/test-statx.c:24:15: warning: `struct foo' declared inside parameter list will not be visible outside of this definition or declaration
   24 | #define statx foo
      |               ^~~

Which is due the use of "struct statx" (here, "struct foo") in a function
prototype argument list before it has been defined:

 int
 # 56 "/usr/include/x86_64-linux-gnu/bits/statx-generic.h"
    foo
 # 56 "/usr/include/x86_64-linux-gnu/bits/statx-generic.h" 3 4
          (int __dirfd, const char *__restrict __path, int __flags,
            unsigned int __mask, struct
 # 57 "/usr/include/x86_64-linux-gnu/bits/statx-generic.h"
                                       foo
 # 57 "/usr/include/x86_64-linux-gnu/bits/statx-generic.h" 3 4
                                             *__restrict __buf)
   __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2, 5)));

Add explicit struct before #include to avoid warning.

Link: http://lkml.kernel.org/r/202006282213.C516EA6@keescook
Fixes: f1b5618e013a ("vfs: Add a sample program for the new mount API")
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/vfs/test-statx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/samples/vfs/test-statx.c~samples-vfs-avoid-warning-in-statx-override
+++ a/samples/vfs/test-statx.c
@@ -23,6 +23,8 @@
 #include <linux/fcntl.h>
 #define statx foo
 #define statx_timestamp foo_timestamp
+struct statx;
+struct statx_timestamp;
 #include <sys/stat.h>
 #undef statx
 #undef statx_timestamp
_

Patches currently in -mm which might be from keescook@chromium.org are

samples-vfs-avoid-warning-in-statx-override.patch
mm-expand-config_slab_freelist_hardened-to-include-slab.patch
slab-add-naive-detection-of-double-free.patch
slab-add-naive-detection-of-double-free-fix.patch
exec-change-uselib2-is_sreg-failure-to-eacces.patch
exec-move-s_isreg-check-earlier.patch
exec-move-path_noexec-check-earlier.patch
