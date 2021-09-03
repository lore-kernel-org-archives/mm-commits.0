Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9E3C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B67F610F9
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350270AbhICU5w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231599AbhICU5o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80D8960E9B;
        Fri,  3 Sep 2021 20:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702604;
        bh=Ayr2ktMM3inS7ZwFH8h8hfOjFlt0wSTe7dvh7JDwcPA=;
        h=Date:From:To:Subject:From;
        b=y8BOYOxjdiwItoAqdM0S63uKmfn6HzdVPquRreM3sjxFyQlxe9dNrBlM2/7RGnDv/
         vLhA5l/tBIETKPdfCzQD8GxRy/f2W03xEuWGl1hTAllZbf/iw9bXSw+KBsnebZqTeC
         uJVv1PUQsTWfznuOFOk61GIBSS6LraGpKcNojSAw=
Date:   Fri, 03 Sep 2021 13:56:44 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged] shmem-remove-unneeded-variable-ret.patch removed
 from -mm tree
Message-ID: <20210903205644.zmYipUkpF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: remove unneeded variable ret
has been removed from the -mm tree.  Its filename was
     shmem-remove-unneeded-variable-ret.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: shmem: remove unneeded variable ret

Patch series "Cleanups for shmem".

This series contains cleanups to remove unneeded variable, header file,
function forward declaration and so on.  More details can be found in the
respective changelogs.


This patch (of 4):

The local variable ret is always equal to -ENOMEM and never touched.  So
remove it and return -ENOMEM directly to simplify the code.

Link: https://lkml.kernel.org/r/20210812120350.49801-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210812120350.49801-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/shmem.c~shmem-remove-unneeded-variable-ret
+++ a/mm/shmem.c
@@ -3616,7 +3616,6 @@ static int shmem_fill_super(struct super
 	struct shmem_options *ctx = fc->fs_private;
 	struct inode *inode;
 	struct shmem_sb_info *sbinfo;
-	int err = -ENOMEM;
 
 	/* Round up to L1_CACHE_BYTES to resist false sharing */
 	sbinfo = kzalloc(max((int)sizeof(struct shmem_sb_info),
@@ -3694,7 +3693,7 @@ static int shmem_fill_super(struct super
 
 failed:
 	shmem_put_super(sb);
-	return err;
+	return -ENOMEM;
 }
 
 static int shmem_get_tree(struct fs_context *fc)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

