From: akpm@linux-foundation.org
Subject: + uapi-fix-linux-sysctlh-userspace-compilation-errors.patch added to -mm tree
Date: Thu, 23 Feb 2017 14:44:31 -0800
Message-ID: <58af65cf.uNXK5zzvUJ4F6QpG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56360 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbdBWWuy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 17:50:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldv@altlinux.org, adobriyan@gmail.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: uapi: fix linux/sysctl.h userspace compilation errors
has been added to the -mm tree.  Its filename is
     uapi-fix-linux-sysctlh-userspace-compilation-errors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/uapi-fix-linux-sysctlh-userspace-compilation-errors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/uapi-fix-linux-sysctlh-userspace-compilation-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: uapi: fix linux/sysctl.h userspace compilation errors

Include <stddef.h> (guarded by #ifndef __KERNEL__) to fix the following
linux/sysctl.h userspace compilation errors:

/usr/include/linux/sysctl.h:38:2: error: unknown type name 'size_t'
  size_t *oldlenp;
/usr/include/linux/sysctl.h:40:2: error: unknown type name 'size_t'
  size_t newlen;

This also fixes userspace compilation of uapi headers that include
linux/sysctl.h, e.g. linux/netfilter.h.

Link: http://lkml.kernel.org/r/20170222230652.GA14373@altlinux.org
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/sysctl.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/uapi/linux/sysctl.h~uapi-fix-linux-sysctlh-userspace-compilation-errors include/uapi/linux/sysctl.h
--- a/include/uapi/linux/sysctl.h~uapi-fix-linux-sysctlh-userspace-compilation-errors
+++ a/include/uapi/linux/sysctl.h
@@ -26,6 +26,10 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 
+#ifndef __KERNEL__
+#include <stddef.h>		/* For size_t. */
+#endif
+
 #define CTL_MAXNAME 10		/* how many path components do we allow in a
 				   call to sysctl?   In other words, what is
 				   the largest acceptable value for the nlen
_

Patches currently in -mm which might be from ldv@altlinux.org are

uapi-fix-linux-sysctlh-userspace-compilation-errors.patch

