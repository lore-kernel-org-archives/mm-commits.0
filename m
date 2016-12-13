From: akpm@linux-foundation.org
Subject: [patch 020/123] slub: avoid false-postive warning
Date: Mon, 12 Dec 2016 16:41:35 -0800
Message-ID: <584f43bf.t74Hvij1qOw0UqGI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40690 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753137AbcLMAlh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:41:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de, brouer@redhat.com, cl@linux.com, glider@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, labbott@fedoraproject.org, penberg@kernel.org, rientjes@google.com, vdavydov.dev@gmail.com

From: Arnd Bergmann <arnd@arndb.de>
Subject: slub: avoid false-postive warning

The slub allocator gives us some incorrect warnings when
CONFIG_PROFILE_ANNOTATED_BRANCHES is set, as the unlikely() macro prevents
it from seeing that the return code matches what it was before:

mm/slub.c: In function `kmem_cache_free_bulk':
mm/slub.c:262:23: error: `df.s' may be used uninitialized in this function [-Werror=maybe-uninitialized]
mm/slub.c:2943:3: error: `df.cnt' may be used uninitialized in this function [-Werror=maybe-uninitialized]
mm/slub.c:2933:4470: error: `df.freelist' may be used uninitialized in this function [-Werror=maybe-uninitialized]
mm/slub.c:2943:3: error: `df.tail' may be used uninitialized in this function [-Werror=maybe-uninitialized]

I have not been able to come up with a perfect way for dealing with this,
the three options I see are:

- add a bogus initialization, which would increase the runtime overhead
- replace unlikely() with unlikely_notrace()
- remove the unlikely() annotation completely

I checked the object code for a typical x86 configuration and the last two
cases produce the same result, so I went for the last one, which is the
simplest.

Link: http://lkml.kernel.org/r/20161024155704.3114445-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Laura Abbott <labbott@fedoraproject.org>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-avoid-false-postive-warning mm/slub.c
--- a/mm/slub.c~slub-avoid-false-postive-warning
+++ a/mm/slub.c
@@ -3076,7 +3076,7 @@ void kmem_cache_free_bulk(struct kmem_ca
 		struct detached_freelist df;
 
 		size = build_detached_freelist(s, size, p, &df);
-		if (unlikely(!df.page))
+		if (!df.page)
 			continue;
 
 		slab_free(df.s, df.page, df.freelist, df.tail, df.cnt,_RET_IP_);
_
