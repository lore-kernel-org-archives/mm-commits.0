From: akpm@linux-foundation.org
Subject: [merged]
 samples-vfs-avoid-warning-in-statx-override.patch removed from -mm tree
Date: Thu, 09 Jul 2020 13:42:14 -0700
Message-ID: <20200709204214.NElX0DnYn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgGIUmP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 16:42:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, keescook@chromium.org, mm-commits@vger.kernel.org, mszeredi@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: samples/vfs: avoid warning in statx override
has been removed from the -mm tree.  Its filename was
     samples-vfs-avoid-warning-in-statx-override.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-expand-config_slab_freelist_hardened-to-include-slab.patch
slab-add-naive-detection-of-double-free.patch
slab-add-naive-detection-of-double-free-fix.patch
exec-change-uselib2-is_sreg-failure-to-eacces.patch
exec-move-s_isreg-check-earlier.patch
exec-move-path_noexec-check-earlier.patch
