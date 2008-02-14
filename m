From: akpm@linux-foundation.org
Subject: + proc-pid-pagemap-fix-pm_special-macro.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:27:59 -0800
Message-ID: <200802142128.m1ELS1P2003822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009AbYBNV2u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:28:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hans.rosenfeld@amd.com, Hans.Rosenfeld@amd.com, mpm@selenic.com


The patch titled
     /proc/pid/pagemap: fix PM_SPECIAL macro
has been added to the -mm tree.  Its filename is
     proc-pid-pagemap-fix-pm_special-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /proc/pid/pagemap: fix PM_SPECIAL macro
From: "Hans Rosenfeld" <hans.rosenfeld@amd.com>

There seems to be a bug in the PM_SPECIAL macro for /proc/pid/pagemap.  I
think masking out those other bits makes more sense then setting all those
mask bits.

Signed-off-by: Hans Rosenfeld <Hans.Rosenfeld@amd.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~proc-pid-pagemap-fix-pm_special-macro fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-pid-pagemap-fix-pm_special-macro
+++ a/fs/proc/task_mmu.c
@@ -531,7 +531,7 @@ struct pagemapread {
 #define PM_RESERVED_BITS    3
 #define PM_RESERVED_OFFSET  (64 - PM_RESERVED_BITS)
 #define PM_RESERVED_MASK    (((1LL<<PM_RESERVED_BITS)-1) << PM_RESERVED_OFFSET)
-#define PM_SPECIAL(nr)      (((nr) << PM_RESERVED_OFFSET) | PM_RESERVED_MASK)
+#define PM_SPECIAL(nr)      (((nr) << PM_RESERVED_OFFSET) & PM_RESERVED_MASK)
 #define PM_NOT_PRESENT      PM_SPECIAL(1LL)
 #define PM_SWAP             PM_SPECIAL(2LL)
 #define PM_END_OF_BUFFER    1
_

Patches currently in -mm which might be from hans.rosenfeld@amd.com are

proc-pid-pagemap-fix-pm_special-macro.patch
