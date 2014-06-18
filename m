From: akpm@linux-foundation.org
Subject: + mm-slabh-wrap-the-whole-file-with-guarding-macro.patch added to -mm tree
Date: Wed, 18 Jun 2014 13:27:54 -0700
Message-ID: <53a1f64a.xSt5LtSDU2V8loHk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbaFRU17 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 16:27:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com, cl@linux.com, a.ryabinin@samsung.com


The patch titled
     Subject: mm: slab.h: wrap the whole file with guarding macro
has been added to the -mm tree.  Its filename is
     mm-slabh-wrap-the-whole-file-with-guarding-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slabh-wrap-the-whole-file-with-guarding-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: mm: slab.h: wrap the whole file with guarding macro

Guarding section:
	#ifndef MM_SLAB_H
	#define MM_SLAB_H
	...
	#endif
currently doesn't cover the whole mm/slab.h. It seems like it was
done unintentionally.

Wrap the whole file by moving closing #endif to the end of it.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.h~mm-slabh-wrap-the-whole-file-with-guarding-macro mm/slab.h
--- a/mm/slab.h~mm-slabh-wrap-the-whole-file-with-guarding-macro
+++ a/mm/slab.h
@@ -260,8 +260,6 @@ static inline struct kmem_cache *cache_f
 	WARN_ON_ONCE(1);
 	return s;
 }
-#endif
