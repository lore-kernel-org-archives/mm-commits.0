From: akpm@linux-foundation.org
Subject: + mm-get-rid-of-__gfp_kmemcg-fix.patch added to -mm tree
Date: Wed, 16 Apr 2014 12:16:22 -0700
Message-ID: <534ed706.1JNVLIjq9FM8rSzM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaDPTQW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 15:16:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, sfr@canb.auug.org.au

Subject: + mm-get-rid-of-__gfp_kmemcg-fix.patch added to -mm tree
To: sfr@canb.auug.org.au,vdavydov@parallels.com
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 12:16:22 -0700


The patch titled
     Subject: mm: get rid of __GFP_KMEMCG fix
has been added to the -mm tree.  Its filename is
     mm-get-rid-of-__gfp_kmemcg-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-get-rid-of-__gfp_kmemcg-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-get-rid-of-__gfp_kmemcg-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm: get rid of __GFP_KMEMCG fix

export kmalloc_order() to modules

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/slab_common.c~mm-get-rid-of-__gfp_kmemcg-fix mm/slab_common.c
--- a/mm/slab_common.c~mm-get-rid-of-__gfp_kmemcg-fix
+++ a/mm/slab_common.c
@@ -584,6 +584,7 @@ void *kmalloc_order(size_t size, gfp_t f
 	kmemleak_alloc(ret, size, 1, flags);
 	return ret;
 }
+EXPORT_SYMBOL(kmalloc_order);
 
 #ifdef CONFIG_TRACING
 void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-get-rid-of-__gfp_kmemcg-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3.patch
kernel-forkc-export-kernel_thread-to-modules.patch

