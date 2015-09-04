From: akpm@linux-foundation.org
Subject: [folded-merged]
 genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
 removed from -mm tree
Date: Fri, 04 Sep 2015 15:31:40 -0700
Message-ID: <55ea1bcc.86bfP8Pqzr6+jzoU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbbIDWbl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:31:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vladimir_zapolskiy@mentor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix
has been removed from the -mm tree.  Its filename was
     genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch

This patch was dropped because it was folded into genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix

gen_pool_get() cleanup

Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/genalloc.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix lib/genalloc.c
--- a/lib/genalloc.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix
+++ a/lib/genalloc.c
@@ -579,9 +579,9 @@ static void devm_gen_pool_release(struct
  */
 struct gen_pool *gen_pool_get(struct device *dev, const char *name)
 {
-	struct gen_pool **p = devres_find(dev, devm_gen_pool_release,
-					  NULL, NULL);
+	struct gen_pool **p;
 
+	p = devres_find(dev, devm_gen_pool_release, NULL, NULL);
 	if (!p)
 		return NULL;
 	return *p;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch

