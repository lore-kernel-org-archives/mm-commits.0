From: akpm@linux-foundation.org
Subject: +
 usercopy-mark-dma-kmalloc-caches-as-usercopy-caches.patch added to -mm tree
Date: Mon, 20 Apr 2020 14:56:57 -0700
Message-ID: <20200420215657.831uimTLb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgDTV5B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 17:57:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, christoffer.dall@linaro.org, cl@linux.com, dave.kleikamp@oracle.com, dave@nullcore.net, davem@davemloft.net, hch@infradead.org, iamjoonsoo.kim@lge.com, jack@suse.cz, jannh@google.com, jslaby@suse.cz, jwi@linux.ibm.com, labbott@redhat.com, luisbg@kernel.org, luto@kernel.org, marc.zyngier@arm.com, mark.rutland@arm.com, martin.petersen@oracle.com, mjg59@google.com, mkubecek@suse.cz, mm-commits@vger.kernel.org, pbonzini@redhat.com, penberg@kernel.org, riel@redhat.com, rientjes@google.com, torvalds@linux-foundation.org, ubraun@linux.ibm.com, vbabka@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     Subject: usercopy: mark dma-kmalloc caches as usercopy caches
has been added to the -mm tree.  Its filename is
     usercopy-mark-dma-kmalloc-caches-as-usercopy-caches.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/usercopy-mark-dma-kmalloc-caches-as-usercopy-caches.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/usercopy-mark-dma-kmalloc-caches-as-usercopy-caches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: usercopy: mark dma-kmalloc caches as usercopy caches

We have seen a "usercopy: Kernel memory overwrite attempt detected to SLUB
object 'dma-kmalloc-1 k' (offset 0, size 11)!" error on s390x, as IUCV
uses kmalloc() with __GFP_DMA because of memory address restrictions.  The
issue has been discussed [2] and it has been noted that if all the kmalloc
caches are marked as usercopy, there's little reason not to mark
dma-kmalloc caches too.  The 'dma' part merely means that __GFP_DMA is
used to restrict memory address range.

As Jann Horn put it [3]:

"I think dma-kmalloc slabs should be handled the same way as normal
kmalloc slabs.  When a dma-kmalloc allocation is freshly created, it is
just normal kernel memory - even if it might later be used for DMA -, and
it should be perfectly fine to copy_from_user() into such allocations at
that point, and to copy_to_user() out of them at the end.  If you look at
the places where such allocations are created, you can see things like
kmemdup(), memcpy() and so on - all normal operations that shouldn't
conceptually be different from usercopy in any relevant way."

Thus this patch marks the dma-kmalloc-* caches as usercopy.

[1] https://bugzilla.suse.com/show_bug.cgi?id=1156053
[2] https://lore.kernel.org/kernel-hardening/bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz/
[3] https://lore.kernel.org/kernel-hardening/CAG48ez1a4waGk9kB0WLaSbs4muSoK0AYAVk8=XYaKj4_+6e6Hg@mail.gmail.com/

Link: http://lkml.kernel.org/r/7d810f6d-8085-ea2f-7805-47ba3842dc50@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christopher Lameter <cl@linux.com>
Cc: Julian Wiedmann <jwi@linux.ibm.com>
Cc: Ursula Braun <ubraun@linux.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Windsor <dave@nullcore.net>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Luis de Bethencourt <luisbg@kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Matthew Garrett <mjg59@google.com>
Cc: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/slab_common.c~usercopy-mark-dma-kmalloc-caches-as-usercopy-caches
+++ a/mm/slab_common.c
@@ -1303,7 +1303,8 @@ void __init create_kmalloc_caches(slab_f
 			kmalloc_caches[KMALLOC_DMA][i] = create_kmalloc_cache(
 				kmalloc_info[i].name[KMALLOC_DMA],
 				kmalloc_info[i].size,
-				SLAB_CACHE_DMA | flags, 0, 0);
+				SLAB_CACHE_DMA | flags, 0,
+				kmalloc_info[i].size);
 		}
 	}
 #endif
_

Patches currently in -mm which might be from vbabka@suse.cz are

usercopy-mark-dma-kmalloc-caches-as-usercopy-caches.patch
mm-dump_page-do-not-crash-with-invalid-mapping-pointer.patch
