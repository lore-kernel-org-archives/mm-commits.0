From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-add-a-dump_stack-to-the-unexpected-gfp-check.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:12:13 -0800
Message-ID: <58af502d.VqduJ3+lhMa8tHQg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39292 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751271AbdBWVMS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:12:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@suse.de, cl@linux.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, penberg@kernel.org, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: add a dump_stack() to the unexpected GFP check
has been removed from the -mm tree.  Its filename was
     mm-slub-add-a-dump_stack-to-the-unexpected-gfp-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Borislav Petkov <bp@suse.de>
Subject: mm/slub: add a dump_stack() to the unexpected GFP check

We wish to know who is doing such a thing. slab.c does this.

Link: http://lkml.kernel.org/r/20170116091643.15260-1-bp@alien8.de
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/slub.c~mm-slub-add-a-dump_stack-to-the-unexpected-gfp-check mm/slub.c
--- a/mm/slub.c~mm-slub-add-a-dump_stack-to-the-unexpected-gfp-check
+++ a/mm/slub.c
@@ -1630,6 +1630,7 @@ static struct page *new_slab(struct kmem
 		flags &= ~GFP_SLAB_BUG_MASK;
 		pr_warn("Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
 				invalid_mask, &invalid_mask, flags, &flags);
+		dump_stack();
 	}
 
 	return allocate_slab(s,
_

Patches currently in -mm which might be from bp@suse.de are


