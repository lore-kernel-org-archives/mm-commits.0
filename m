From: akpm@linux-foundation.org
Subject: + mm-vmacache-inline-vmacache_valid_mm.patch added to -mm tree
Date: Thu, 08 Oct 2015 15:16:52 -0700
Message-ID: <5616eb54.7wODu5WMxK2G763f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758900AbbJHWQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2015 18:16:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmacache: inline vmacache_valid_mm()
has been added to the -mm tree.  Its filename is
     mm-vmacache-inline-vmacache_valid_mm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmacache-inline-vmacache_valid_mm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmacache-inline-vmacache_valid_mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/vmacache: inline vmacache_valid_mm()

This function incurs in very hot paths and merely does a few loads for
validity check.  Lets inline it, such that we can save the function call
overhead.

(akpm: this is cosmetic - the compiler already inlines vmacache_valid_mm())

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmacache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmacache.c~mm-vmacache-inline-vmacache_valid_mm mm/vmacache.c
--- a/mm/vmacache.c~mm-vmacache-inline-vmacache_valid_mm
+++ a/mm/vmacache.c
@@ -52,7 +52,7 @@ void vmacache_flush_all(struct mm_struct
  * Also handle the case where a kernel thread has adopted this mm via use_mm().
  * That kernel thread's vmacache is not applicable to this mm.
  */
-static bool vmacache_valid_mm(struct mm_struct *mm)
+static inline bool vmacache_valid_mm(struct mm_struct *mm)
 {
 	return current->mm == mm && !(current->flags & PF_KTHREAD);
 }
_

Patches currently in -mm which might be from dave@stgolabs.net are

mm-vmacache-inline-vmacache_valid_mm.patch

