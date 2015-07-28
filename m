From: akpm@linux-foundation.org
Subject: + use-poison_pointer_delta-for-poison-pointers.patch added to -mm tree
Date: Tue, 28 Jul 2015 14:49:31 -0700
Message-ID: <55b7f8eb.uxGTApCxVdAfEBpq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbbG1Vtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jul 2015 17:49:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, kirill.shutemov@linux.intel.com, solar@openwall.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/poison.h: use POISON_POINTER_DELTA for poison pointers
has been added to the -mm tree.  Its filename is
     use-poison_pointer_delta-for-poison-pointers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/use-poison_pointer_delta-for-poison-pointers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/use-poison_pointer_delta-for-poison-pointers.patch

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
Subject: include/linux/poison.h: use POISON_POINTER_DELTA for poison pointers

TIMER_ENTRY_STATIC and TAIL_MAPPING are defined as poison pointers which
should point to nowhere.  Redefine them using POISON_POINTER_DELTA
arithmetics to make sure they really point to non-mappable area declared
by the target architecture.

Signed-off-by: Vasily Kulikov <segoon@openwall.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Solar Designer <solar@openwall.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poison.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/poison.h~use-poison_pointer_delta-for-poison-pointers include/linux/poison.h
--- a/include/linux/poison.h~use-poison_pointer_delta-for-poison-pointers
+++ a/include/linux/poison.h
@@ -27,14 +27,14 @@
  * Magic number "tsta" to indicate a static timer initializer
  * for the object debugging code.
  */
-#define TIMER_ENTRY_STATIC	((void *) 0x74737461)
+#define TIMER_ENTRY_STATIC	((void *) 0x300 + POISON_POINTER_DELTA)
 
 /********** mm/debug-pagealloc.c **********/
 #define PAGE_POISON 0xaa
 
 /********** mm/page_alloc.c ************/
 
-#define TAIL_MAPPING	((void *) 0x01014A11 + POISON_POINTER_DELTA)
+#define TAIL_MAPPING	((void *) 0x400 + POISON_POINTER_DELTA)
 
 /********** mm/slab.c **********/
 /*
_

Patches currently in -mm which might be from segoon@openwall.com are

fix-list_poison12-offset.patch
use-poison_pointer_delta-for-poison-pointers.patch
remove-not-used-poison-pointer-macros.patch

