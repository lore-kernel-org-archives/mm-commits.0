From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-fix-argument-order-in-cache_from_objs-error-message.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 11:03:47 -0700
Message-ID: <55ef2303.n3hmyoufy3WtwoS6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbbIHSDs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@iogearbox.net, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.h: fix argument order in cache_from_obj's error message
has been removed from the -mm tree.  Its filename was
     mm-slab-fix-argument-order-in-cache_from_objs-error-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Borkmann <daniel@iogearbox.net>
Subject: mm/slab.h: fix argument order in cache_from_obj's error message

While debugging a networking issue, I hit a condition that triggered an
object to be freed into the wrong kmem cache, and thus triggered the
warning in cache_from_obj().

The arguments in the error message are in wrong order: the location
of the object's kmem cache is in cachep, not s.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.h~mm-slab-fix-argument-order-in-cache_from_objs-error-message mm/slab.h
--- a/mm/slab.h~mm-slab-fix-argument-order-in-cache_from_objs-error-message
+++ a/mm/slab.h
@@ -330,7 +330,7 @@ static inline struct kmem_cache *cache_f
 		return cachep;
 
 	pr_err("%s: Wrong slab cache. %s but object is from %s\n",
-	       __func__, cachep->name, s->name);
+	       __func__, s->name, cachep->name);
 	WARN_ON_ONCE(1);
 	return s;
 }
_

Patches currently in -mm which might be from daniel@iogearbox.net are


