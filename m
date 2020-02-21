From: akpm@linux-foundation.org
Subject: +
 shmem-distribute-switch-variables-for-initialization.patch added to -mm tree
Date: Thu, 20 Feb 2020 17:33:33 -0800
Message-ID: <20200221013333.tCPRz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729535AbgBUBdf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Feb 2020 20:33:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, glider@google.com, akpm@linux-foundation.org, keescook@chromium.org


The patch titled
     Subject: mm/shmem.c: distribute switch variables for initialization
has been added to the -mm tree.  Its filename is
     shmem-distribute-switch-variables-for-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shmem-distribute-switch-variables-for-initialization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shmem-distribute-switch-variables-for-initialization.patch

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
Subject: mm/shmem.c: distribute switch variables for initialization

Variables declared in a switch statement before any case statements cannot
be automatically initialized with compiler instrumentation (as they are
not part of any execution flow).  With GCC's proposed automatic stack
variable initialization feature, this triggers a warning (and they don't
get initialized).  Clang's automatic stack variable initialization (via
CONFIG_INIT_STACK_ALL=y) doesn't throw a warning, but it also doesn't
initialize such variables[1].  Note that these warnings (or silent
skipping) happen before the dead-store elimination optimization phase, so
even when the automatic initializations are later elided in favor of
direct initializations, the warnings remain.

To avoid these problems, move such variables into the "case" where they're
used or lift them up into the main function body.

mm/shmem.c: In function `shmem_getpage_gfp':
mm/shmem.c:1816:10: warning: statement will never be executed [-Wswitch-unreachable]
 1816 |   loff_t i_size;
      |          ^~~~~~

[1] https://bugs.llvm.org/show_bug.cgi?id=44916

Link: http://lkml.kernel.org/r/20200220062312.69165-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~shmem-distribute-switch-variables-for-initialization
+++ a/mm/shmem.c
@@ -1813,17 +1813,20 @@ repeat:
 	if (shmem_huge == SHMEM_HUGE_FORCE)
 		goto alloc_huge;
 	switch (sbinfo->huge) {
-		loff_t i_size;
-		pgoff_t off;
 	case SHMEM_HUGE_NEVER:
 		goto alloc_nohuge;
-	case SHMEM_HUGE_WITHIN_SIZE:
+	case SHMEM_HUGE_WITHIN_SIZE: {
+		loff_t i_size;
+		pgoff_t off;
+
 		off = round_up(index, HPAGE_PMD_NR);
 		i_size = round_up(i_size_read(inode), PAGE_SIZE);
 		if (i_size >= HPAGE_PMD_SIZE &&
 		    i_size >> PAGE_SHIFT >= off)
 			goto alloc_huge;
-		/* fallthrough */
+
+		fallthrough;
+	}
 	case SHMEM_HUGE_ADVISE:
 		if (sgp_huge == SGP_HUGE)
 			goto alloc_huge;
_

Patches currently in -mm which might be from keescook@chromium.org are

shmem-distribute-switch-variables-for-initialization.patch
lib-test_stackinitc-xfail-switch-variable-init-tests.patch
