From: akpm@linux-foundation.org
Subject: + linux-typesh-remove-prehistoric-ifndefs.patch added to -mm tree
Date: Thu, 11 Jun 2015 14:44:14 -0700
Message-ID: <557a012e.BTLqRNDxXaLdJ8io%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbFKVoO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jun 2015 17:44:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/types.h: remove prehistoric ifndefs
has been added to the -mm tree.  Its filename is
     linux-typesh-remove-prehistoric-ifndefs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-typesh-remove-prehistoric-ifndefs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-typesh-remove-prehistoric-ifndefs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: linux/types.h: remove prehistoric ifndefs

Whatever the "historical reasons" were back around 1996 when this comment
was added,

  git grep -E '\b_(S?SIZE|TIME|CLOCK|PTRDIFF|CADDR)_T\b'

seems to say that they are no longer relevant. Relieve the
preprocessor from a little work.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/types.h |   27 ---------------------------
 1 file changed, 27 deletions(-)

diff -puN include/linux/types.h~linux-typesh-remove-prehistoric-ifndefs include/linux/types.h
--- a/include/linux/types.h~linux-typesh-remove-prehistoric-ifndefs
+++ a/include/linux/types.h
@@ -45,39 +45,12 @@ typedef __kernel_old_gid_t	old_gid_t;
 typedef __kernel_loff_t		loff_t;
 #endif
 
-/*
- * The following typedefs are also protected by individual ifdefs for
- * historical reasons:
- */
-#ifndef _SIZE_T
-#define _SIZE_T
 typedef __kernel_size_t		size_t;
-#endif
-
-#ifndef _SSIZE_T
-#define _SSIZE_T
 typedef __kernel_ssize_t	ssize_t;
-#endif
-
-#ifndef _PTRDIFF_T
-#define _PTRDIFF_T
 typedef __kernel_ptrdiff_t	ptrdiff_t;
-#endif
-
-#ifndef _TIME_T
-#define _TIME_T
 typedef __kernel_time_t		time_t;
-#endif
-
-#ifndef _CLOCK_T
-#define _CLOCK_T
 typedef __kernel_clock_t	clock_t;
-#endif
-
-#ifndef _CADDR_T
-#define _CADDR_T
 typedef __kernel_caddr_t	caddr_t;
-#endif
 
 /* bsd */
 typedef unsigned char		u_char;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

linux-slabh-fix-three-off-by-one-typos-in-comment.patch
mm-only-define-hashdist-variable-when-needed.patch
linux-typesh-remove-prehistoric-ifndefs.patch
__bitmap_parselist-fix-bug-in-empty-string-handling.patch
lib-sort-add-64-bit-swap-function.patch
lib-sort-add-64-bit-swap-function-v2.patch
lib-sort-add-64-bit-swap-function-v2-fix.patch
lib-string-introduce-strreplace.patch
kernel-trace-trace_events_filterc-use-strreplace.patch
blktrace-use-strreplace-in-do_blk_trace_setup.patch
lib-kobjectc-use-strreplace.patch
drivers-base-corec-use-strreplace.patch
drivers-md-mdc-use-strreplace.patch
fs-jbd2-journalc-use-strreplace.patch
fs-ext4-superc-use-strreplace-in-ext4_fill_super.patch
checkpatch-avoid-not_unified_diff-errors-on-cover-letterpatch-files.patch
linux-next.patch

