From: akpm@linux-foundation.org
Subject: [merged] slub-avoid-false-postive-warning.patch removed from -mm
 tree
Date: Wed, 14 Dec 2016 11:23:31 -0800
Message-ID: <58519c33.KEiOvgUMjOckeSXi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43986 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754107AbcLNTXc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:23:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, brouer@redhat.com, cl@linux.com, glider@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, labbott@fedoraproject.org, penberg@kernel.org, rientjes@google.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: avoid false-postive warning
has been removed from the -mm tree.  Its filename was
     slub-avoid-false-postive-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from arnd@arndb.de are


