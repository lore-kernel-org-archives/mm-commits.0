From: akpm@linux-foundation.org
Subject: + mm-slab-convert-slab_is_available-to-boolean.patch added to -mm tree
Date: Tue, 15 Sep 2015 15:27:14 -0700
Message-ID: <55f89b42.guJC+6o28/CmeMcF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbbIOW1Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 18:27:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kda@linux-powerpc.org, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: convert slab_is_available() to boolean
has been added to the -mm tree.  Its filename is
     mm-slab-convert-slab_is_available-to-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-convert-slab_is_available-to-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-convert-slab_is_available-to-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Denis Kirjanov <kda@linux-powerpc.org>
Subject: slab: convert slab_is_available() to boolean

A good candidate to return a boolean result.

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 +-
 mm/slab_common.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/slab.h~mm-slab-convert-slab_is_available-to-boolean include/linux/slab.h
--- a/include/linux/slab.h~mm-slab-convert-slab_is_available-to-boolean
+++ a/include/linux/slab.h
@@ -111,7 +111,7 @@ struct mem_cgroup;
  * struct kmem_cache related prototypes
  */
 void __init kmem_cache_init(void);
-int slab_is_available(void);
+bool slab_is_available(void);
 
 struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
 			unsigned long,
diff -puN mm/slab_common.c~mm-slab-convert-slab_is_available-to-boolean mm/slab_common.c
--- a/mm/slab_common.c~mm-slab-convert-slab_is_available-to-boolean
+++ a/mm/slab_common.c
@@ -692,7 +692,7 @@ int kmem_cache_shrink(struct kmem_cache
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
 
-int slab_is_available(void)
+bool slab_is_available(void)
 {
 	return slab_state >= UP;
 }
_

Patches currently in -mm which might be from kda@linux-powerpc.org are

mm-slab-convert-slab_is_available-to-boolean.patch

