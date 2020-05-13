From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?kernel-sysctl-ignore-out-of-range-taint-bits-introduced-via?=
 =?US-ASCII?Q?-kerneltainted.patch?= added to -mm tree
Date: Wed, 13 May 2020 13:56:12 -0700
Message-ID: <20200513205612.Yo0fgCLIb%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgEMU4P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 May 2020 16:56:15 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, tytso@mit.edu, yzaikin@google.com


The patch titled
     Subject: kernel/sysctl.c: ignore out-of-range taint bits introduced via kernel.tainted
has been added to the -mm tree.  Its filename is
     kernel-sysctl-ignore-out-of-range-taint-bits-introduced-via-kerneltainted.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-sysctl-ignore-out-of-range-taint-bits-introduced-via-kerneltainted.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-sysctl-ignore-out-of-range-taint-bits-introduced-via-kerneltainted.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: kernel/sysctl.c: ignore out-of-range taint bits introduced via kernel.tainted

Users with SYS_ADMIN capability can add arbitrary taint flags to the
running kernel by writing to /proc/sys/kernel/tainted or issuing the
command 'sysctl -w kernel.tainted=...'.  This interface, however, is open
for any integer value and this might cause an invalid set of flags being
committed to the tainted_mask bitset.

This patch introduces a simple way for proc_taint() to ignore any eventual
invalid bit coming from the user input before committing those bits to the
kernel tainted_mask.

Link: http://lkml.kernel.org/r/20200512223946.888020-1-aquini@redhat.com
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/sysctl.c~kernel-sysctl-ignore-out-of-range-taint-bits-introduced-via-kerneltainted
+++ a/kernel/sysctl.c
@@ -870,10 +870,9 @@ static int proc_taint(struct ctl_table *
 		 * to everyone's atomic.h for this
 		 */
 		int i;
-		for (i = 0; i < BITS_PER_LONG && tmptaint >> i; i++) {
-			if ((tmptaint >> i) & 1)
+		for (i = 0; i < TAINT_FLAGS_COUNT; i++)
+			if ((1UL << i) & tmptaint)
 				add_taint(i, LOCKDEP_STILL_OK);
-		}
 	}
 
 	return err;
_

Patches currently in -mm which might be from aquini@redhat.com are

mm-slub-add-panic_on_error-to-the-debug-facilities.patch
kernel-sysctl-ignore-out-of-range-taint-bits-introduced-via-kerneltainted.patch
