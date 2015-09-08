From: akpm@linux-foundation.org
Subject: [folded-merged] zswap-dynamic-pool-creation-fix-2.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 14:46:52 -0700
Message-ID: <55ef574c.rm8eo1udHSGfJFNu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbbIHVqx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:46:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, sergey.senozhatsky.work@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: move zswap_pool frequently-used fields together
has been removed from the -mm tree.  Its filename was
     zswap-dynamic-pool-creation-fix-2.patch

This patch was dropped because it was folded into zswap-dynamic-pool-creation.patch

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: zswap: move zswap_pool frequently-used fields together

Move the "tfm" field in struct zswap_pool to the top, after the "zpool"
field.

As suggested by Sergey Senozhatsky:

>> > ->tfm will be access pretty often, right? did you intentionally put it
>> > at the bottom offset of `struct zswap_pool'?
>>
>> no it wasn't intentional; does moving it up provide a benefit?
>
> well, I just prefer to keep 'read mostly' pointers together. all
> those cache lines, etc.
>
> gcc 5.1, x86_64
>
>  struct zswap_pool {
>         struct zpool *zpool;
> +       struct crypto_comp * __percpu *tfm;
>         struct kref kref;
>         struct list_head list;
>         struct rcu_head rcu_head;
>         struct notifier_block notifier;
>         char tfm_name[CRYPTO_MAX_ALG_NAME];
> -       struct crypto_comp * __percpu *tfm;
>  };
>
> ../scripts/bloat-o-meter zswap.o.old zswap.o
> add/remove: 0/0 grow/shrink: 0/6 up/down: 0/-27 (-27)
> function                                     old     new   delta
> zswap_writeback_entry                        659     656      -3
> zswap_frontswap_store                       1445    1442      -3
> zswap_frontswap_load                         417     414      -3
> zswap_pool_create                            438     432      -6
> __zswap_cpu_comp_notifier.part               152     146      -6
> __zswap_cpu_comp_notifier                    122     116      -6

Suggested-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zswap.c~zswap-dynamic-pool-creation-fix-2 mm/zswap.c
--- a/mm/zswap.c~zswap-dynamic-pool-creation-fix-2
+++ a/mm/zswap.c
@@ -104,12 +104,12 @@ static struct zpool *zswap_pool;
 
 struct zswap_pool {
 	struct zpool *zpool;
+	struct crypto_comp * __percpu *tfm;
 	struct kref kref;
 	struct list_head list;
 	struct rcu_head rcu_head;
 	struct notifier_block notifier;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
-	struct crypto_comp * __percpu *tfm;
 };
 
 /*
_

Patches currently in -mm which might be from ddstreet@ieee.org are

zpool-add-zpool_has_pool.patch
zswap-dynamic-pool-creation.patch
zswap-change-zpool-compressor-at-runtime.patch
zswap-change-zpool-compressor-at-runtime-fix.patch
zswap-update-docs-for-runtime-changeable-attributes.patch
zswap-update-docs-for-runtime-changeable-attributes-v2.patch
zpool-remove-no-op-module-init-exit.patch

