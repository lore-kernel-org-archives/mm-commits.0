From: akpm@linux-foundation.org
Subject: [folded-merged]
 genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch removed
 from -mm tree
Date: Fri, 04 Sep 2015 15:32:05 -0700
Message-ID: <55ea1be5.3JVjUejW4SulcAEQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbbIDWcG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:32:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sfr@canb.auug.org.au, vladimir_zapolskiy@mentor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: genalloc-add-support-of-multiple-gen_pools-per-device-fix
has been removed from the -mm tree.  Its filename was
     genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch

This patch was dropped because it was folded into genalloc-add-support-of-multiple-gen_pools-per-device.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: genalloc-add-support-of-multiple-gen_pools-per-device-fix

fix constness in devres_find()

Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/genalloc.c~genalloc-add-support-of-multiple-gen_pools-per-device-fix lib/genalloc.c
--- a/lib/genalloc.c~genalloc-add-support-of-multiple-gen_pools-per-device-fix
+++ a/lib/genalloc.c
@@ -596,7 +596,8 @@ struct gen_pool *gen_pool_get(struct dev
 {
 	struct gen_pool **p;
 
-	p = devres_find(dev, devm_gen_pool_release, devm_gen_pool_match, name);
+	p = devres_find(dev, devm_gen_pool_release, devm_gen_pool_match,
+			(void *)name);
 	if (!p)
 		return NULL;
 	return *p;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
genalloc-add-support-of-multiple-gen_pools-per-device.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch

