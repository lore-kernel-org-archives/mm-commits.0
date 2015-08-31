From: akpm@linux-foundation.org
Subject: +
 mm-slab-fix-argument-order-in-cache_from_objs-error-message.patch added to
 -mm tree
Date: Mon, 31 Aug 2015 13:31:38 -0700
Message-ID: <55e4b9aa.MZeszm8681OImO2H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbbHaUbj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Aug 2015 16:31:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@iogearbox.net, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.h: fix argument order in cache_from_obj's error message
has been added to the -mm tree.  Its filename is
     mm-slab-fix-argument-order-in-cache_from_objs-error-message.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-fix-argument-order-in-cache_from_objs-error-message.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-fix-argument-order-in-cache_from_objs-error-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -321,7 +321,7 @@ static inline struct kmem_cache *cache_f
 		return cachep;
 
 	pr_err("%s: Wrong slab cache. %s but object is from %s\n",
-	       __func__, cachep->name, s->name);
+	       __func__, s->name, cachep->name);
 	WARN_ON_ONCE(1);
 	return s;
 }
_

Patches currently in -mm which might be from daniel@iogearbox.net are

mm-slab-fix-argument-order-in-cache_from_objs-error-message.patch

