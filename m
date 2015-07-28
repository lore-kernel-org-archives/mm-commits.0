From: akpm@linux-foundation.org
Subject: + fix-list_poison12-offset.patch added to -mm tree
Date: Tue, 28 Jul 2015 14:49:29 -0700
Message-ID: <55b7f8e9.HHe1NrHJcfbeKHeD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbbG1Vta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jul 2015 17:49:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, kirill.shutemov@linux.intel.com, solar@openwall.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/poison.h: fix LIST_POISON{1,2} offset
has been added to the -mm tree.  Its filename is
     fix-list_poison12-offset.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-list_poison12-offset.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-list_poison12-offset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vasily Kulikov <segoon@openwall.com>
Subject: include/linux/poison.h: fix LIST_POISON{1,2} offset

Poison pointer values should be small enough to find a room in
non-mmap'able/hardly-mmap'able space.  E.g.  on x86 "poison pointer space"
is located starting from 0x0.  Given unprivileged users cannot mmap
anything below mmap_min_addr, it should be safe to use poison pointers
lower than mmap_min_addr.

The current poison pointer values of LIST_POISON{1,2} might be too big for
mmap_min_addr values equal or less than 1 MB (common case, e.g.  Ubuntu
uses only 0x10000).  There is little point to use such a big value given
the "poison pointer space" below 1 MB is not yet exhausted.  Changing it
to a smaller value solves the problem for small mmap_min_addr setups.

The values are suggested by Solar Designer:
http://www.openwall.com/lists/oss-security/2015/05/02/6

Signed-off-by: Vasily Kulikov <segoon@openwall.com>
Cc: Solar Designer <solar@openwall.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poison.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/poison.h~fix-list_poison12-offset include/linux/poison.h
--- a/include/linux/poison.h~fix-list_poison12-offset
+++ a/include/linux/poison.h
@@ -19,8 +19,8 @@
  * under normal circumstances, used to verify that nobody uses
  * non-initialized list entries.
  */
-#define LIST_POISON1  ((void *) 0x00100100 + POISON_POINTER_DELTA)
-#define LIST_POISON2  ((void *) 0x00200200 + POISON_POINTER_DELTA)
+#define LIST_POISON1  ((void *) 0x100 + POISON_POINTER_DELTA)
+#define LIST_POISON2  ((void *) 0x200 + POISON_POINTER_DELTA)
 
 /********** include/linux/timer.h **********/
 /*
_

Patches currently in -mm which might be from segoon@openwall.com are

fix-list_poison12-offset.patch
use-poison_pointer_delta-for-poison-pointers.patch
remove-not-used-poison-pointer-macros.patch

