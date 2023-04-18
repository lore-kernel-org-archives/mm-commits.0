Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0406C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbjDRXeN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbjDRXd7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876DE9766
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 604CD615E3
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0D7C433D2;
        Tue, 18 Apr 2023 23:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860836;
        bh=RBwOsY6DKwhwjoWzN1m3U7UytQyCfyz9j4/J1bcJTYg=;
        h=Date:To:From:Subject:From;
        b=IdlKKYyiixLlGpH+72+AKhqzyAJxvxKaGHNpBRa0wV+73mIyK5pkn4FoVUtfkOQX0
         3QrPEMMZtCCu+R5+JyiwcQxSVoAngW9t34Asu7qvDRbxCIVWT/QiAD4DUuDt/vghhG
         q6sYihHq1ptBD9a/MGIQIzHU35pJh64aFXYlR4y8=
Date:   Tue, 18 Apr 2023 16:33:56 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, nathan@kernel.org, hch@lst.de,
        ddstreet@ieee.org, liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-remove-zswap_entry_cache_createdestroy-helper-function.patch removed from -mm tree
Message-Id: <20230418233356.BB0D7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/zswap: remove zswap_entry_cache_{create,destroy} helper function
has been removed from the -mm tree.  Its filename was
     mm-zswap-remove-zswap_entry_cache_createdestroy-helper-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/zswap: remove zswap_entry_cache_{create,destroy} helper function
Date: Mon, 3 Apr 2023 20:13:16 +0800

Patch series "Delay the initialization of zswap", v9.

In the initialization of zswap, about 18MB memory will be allocated for
zswap_pool.  Since some users may not use zswap, the zswap_pool is wasted.
Save memory by delaying the initialization of zswap until enabled.


This patch (of 3):

Remove zswap_entry_cache_create and zswap_entry_cache_destroy and use
kmem_cache_* function directly.

Link: https://lkml.kernel.org/r/20230411093632.822290-1-liushixin2@huawei.com
Link: https://lkml.kernel.org/r/20230403121318.1876082-1-liushixin2@huawei.com
Link: https://lkml.kernel.org/r/20230403121318.1876082-2-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-zswap_entry_cache_createdestroy-helper-function
+++ a/mm/zswap.c
@@ -272,17 +272,6 @@ static void zswap_update_total_size(void
 **********************************/
 static struct kmem_cache *zswap_entry_cache;
 
-static int __init zswap_entry_cache_create(void)
-{
-	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
-	return zswap_entry_cache == NULL;
-}
-
-static void __init zswap_entry_cache_destroy(void)
-{
-	kmem_cache_destroy(zswap_entry_cache);
-}
-
 static struct zswap_entry *zswap_entry_cache_alloc(gfp_t gfp)
 {
 	struct zswap_entry *entry;
@@ -1489,7 +1478,8 @@ static int __init init_zswap(void)
 
 	zswap_init_started = true;
 
-	if (zswap_entry_cache_create()) {
+	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
+	if (!zswap_entry_cache) {
 		pr_err("entry cache creation failed\n");
 		goto cache_fail;
 	}
@@ -1538,7 +1528,7 @@ fallback_fail:
 hp_fail:
 	cpuhp_remove_state(CPUHP_MM_ZSWP_MEM_PREPARE);
 dstmem_fail:
-	zswap_entry_cache_destroy();
+	kmem_cache_destroy(zswap_entry_cache);
 cache_fail:
 	/* if built-in, we aren't unloaded on failure; don't allow use */
 	zswap_init_failed = true;
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initialization-of-zswap.patch
mm-hwpoison-support-recovery-from-hugepage-copy-on-write-faults.patch

