From: akpm@linux-foundation.org
Subject: + mm-slab_common-use-kmem_cache_free.patch added to -mm tree
Date: Mon, 09 Feb 2015 13:01:27 -0800
Message-ID: <54d92027.LaVohDAusdwYRDvi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761150AbbBIVB2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2015 16:01:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vthakkar1994@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common.c: use kmem_cache_free()
has been added to the -mm tree.  Its filename is
     mm-slab_common-use-kmem_cache_free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab_common-use-kmem_cache_free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab_common-use-kmem_cache_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vaishali Thakkar <vthakkar1994@gmail.com>
Subject: mm/slab_common.c: use kmem_cache_free()

Here, free memory is allocated using kmem_cache_zalloc.  So, use
kmem_cache_free instead of kfree.

This is done using Coccinelle and semantic patch used
is as follows:

@@
expression x,E,c;
@@

 x = \(kmem_cache_alloc\|kmem_cache_zalloc\|kmem_cache_alloc_node\)(c,...)
 ... when != x = E
     when != &x
?-kfree(x)
+kmem_cache_free(c,x)

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab_common.c~mm-slab_common-use-kmem_cache_free mm/slab_common.c
--- a/mm/slab_common.c~mm-slab_common-use-kmem_cache_free
+++ a/mm/slab_common.c
@@ -331,7 +331,7 @@ out:
 
 out_free_cache:
 	memcg_free_cache_params(s);
-	kfree(s);
+	kmem_cache_free(kmem_cache, s);
 	goto out;
 }
 
_

Patches currently in -mm which might be from vthakkar1994@gmail.com are

mm-slab_common-use-kmem_cache_free.patch
linux-next.patch

