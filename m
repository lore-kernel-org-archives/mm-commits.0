From: akpm@linux-foundation.org
Subject: + kcalloc-remove-runtime-division.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:40:26 -0700
Message-ID: <200807111846.m6BIk7Gx030998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050AbYGKSqP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:46:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miltonm@bga.com, tiwai@suse.de


The patch titled
     kcalloc: remove runtime division
has been added to the -mm tree.  Its filename is
     kcalloc-remove-runtime-division.patch

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
Subject: kcalloc: remove runtime division
From: Milton Miller <miltonm@bga.com>

While in all cases in the kernel we know the size of the elements to be
created, we don't always know the count of elements.  By commuting the size
and count in the overflow check, the compiler can reduce the runtime division
of size_t with a compare to a (unique) constant in these cases.

Signed-off-by: Milton Miller <miltonm@bga.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/slab.h~kcalloc-remove-runtime-division include/linux/slab.h
--- a/include/linux/slab.h~kcalloc-remove-runtime-division
+++ a/include/linux/slab.h
@@ -187,7 +187,7 @@ size_t ksize(const void *);
  */
 static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
 {
-	if (n != 0 && size > ULONG_MAX / n)
+	if (size != 0 && n > ULONG_MAX / size)
 		return NULL;
 	return __kmalloc(n * size, flags | __GFP_ZERO);
 }
_

Patches currently in -mm which might be from miltonm@bga.com are

alsa-correct-kcalloc-usage.patch
pci-dynidsuse_driver_data-considered-harmful.patch
kcalloc-remove-runtime-division.patch

