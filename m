From: akpm@linux-foundation.org
Subject: [patch 17/41] sh: get rid of superfluous __GFP_REPEAT
Date: Fri, 24 Jun 2016 14:49:20 -0700
Message-ID: <576daae0.TqZ6CwrgGIMuVXVv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbcFXVtV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:49:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, dalias@libc.org, ysato@users.sourceforge.jp

From: Michal Hocko <mhocko@suse.com>
Subject: sh: get rid of superfluous __GFP_REPEAT

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.

PGALLOC_GFP uses __GFP_REPEAT but {pgd,pmd}_alloc allocate from
{pgd,pmd}_cache but both caches are allocating up to PAGE_SIZE objects. 
This means that this flag has never been actually useful here because it
has always been used only for PAGE_ALLOC_COSTLY requests.

Link: http://lkml.kernel.org/r/1464599699-30131-15-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/pgtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/mm/pgtable.c~sh-get-rid-of-superfluous-__gfp_repeat arch/sh/mm/pgtable.c
--- a/arch/sh/mm/pgtable.c~sh-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/sh/mm/pgtable.c
@@ -1,7 +1,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 
-#define PGALLOC_GFP GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO
+#define PGALLOC_GFP GFP_KERNEL | __GFP_ZERO
 
 static struct kmem_cache *pgd_cachep;
 #if PAGETABLE_LEVELS > 2
_
