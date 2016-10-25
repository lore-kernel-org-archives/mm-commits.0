From: akpm@linux-foundation.org
Subject: + slub-avoid-false-postive-warning.patch added to -mm tree
Date: Tue, 25 Oct 2016 12:38:46 -0700
Message-ID: <580fb4c6.WfLvlKi4g105H6kC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36500 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbcJYTir (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2016 15:38:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, brouer@redhat.com, cl@linux.com, glider@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, labbott@fedoraproject.org, penberg@kernel.org, rientjes@google.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: avoid false-postive warning
has been added to the -mm tree.  Its filename is
     slub-avoid-false-postive-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-avoid-false-postive-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-avoid-false-postive-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

slub-avoid-false-postive-warning.patch

