From: akpm@linux-foundation.org
Subject: +
 mm-slab-introduce-new-slab-management-type-objfreelist_slab-fix.patch added to -mm tree
Date: Tue, 26 Jan 2016 20:55:19 -0800
Message-ID: <56a84db7.uFr6BWcpJTmxRoT+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbcA0EzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 23:55:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fix SLAB_DESTROTY_BY_RCU
has been added to the -mm tree.  Its filename is
     mm-slab-introduce-new-slab-management-type-objfreelist_slab-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-introduce-new-slab-management-type-objfreelist_slab-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-introduce-new-slab-management-type-objfreelist_slab-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: fix SLAB_DESTROTY_BY_RCU

Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~mm-slab-introduce-new-slab-management-type-objfreelist_slab-fix mm/slab.c
--- a/mm/slab.c~mm-slab-introduce-new-slab-management-type-objfreelist_slab-fix
+++ a/mm/slab.c
@@ -2045,7 +2045,7 @@ static bool set_objfreelist_slab_cache(s
 
 	cachep->num = 0;
 
-	if (cachep->ctor)
+	if (cachep->ctor || flags & SLAB_DESTROY_BY_RCU)
 		return false;
 
 	left = calculate_slab_order(cachep, size,
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-introduce-new-slab-management-type-objfreelist_slab-fix.patch

