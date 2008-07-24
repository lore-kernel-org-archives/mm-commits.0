From: akpm@linux-foundation.org
Subject: - kcalloc-remove-runtime-division.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:24:43 -0700
Message-ID: <200807242324.m6ONOhRj010806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755499AbYGXXZB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:25:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miltonm@bga.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     kcalloc: remove runtime division
has been removed from the -mm tree.  Its filename was
     kcalloc-remove-runtime-division.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -180,7 +180,7 @@ size_t ksize(const void *);
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

origin.patch
linux-next.patch

