Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07127CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjJRVXs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjJRVXr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:23:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57989B0
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:23:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B0DC433C8;
        Wed, 18 Oct 2023 21:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664226;
        bh=C3ys9Szjh4oZhstOgjuaDIrlgBS+N5FxRQGaCBWh8lo=;
        h=Date:To:From:Subject:From;
        b=ZVj0vF5uWt/diOLPlLJwSNeFXYF5JSh0ajs1jEDFok8fpWdWhKHjSvoaNBbpe3C0C
         I4uNM/OzoZagZRPMy2Yxs0tJZcYjFm9pm42+9MdOfrF/9wLFmgjVWNDgL0DD/smmQ4
         fbOrSOzAmKG4ChECwCE4BEyI7FkKjHpSyDneWUjs=
Date:   Wed, 18 Oct 2023 14:23:45 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        lucymielke@icloud.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix.patch removed from -mm tree
Message-Id: <20231018212345.E6B0DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix
has been removed from the -mm tree.  Its filename was
     mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix.patch

This patch was dropped because it was folded into mm-add-printf-attribute-to-shrinker_debugfs_name_alloc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix
Date: Tue Oct 10 11:03:09 AM PDT 2023

fix shrinker_alloc() as welll per Qi Zheng

Link: https://lkml.kernel.org/r/822387b7-4895-4e64-5806-0f56b5d6c447@bytedance.com
Cc: Lucy Mielke <lucymielke@icloud.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shrinker.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/shrinker.h~mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix
+++ a/include/linux/shrinker.h
@@ -131,6 +131,7 @@ struct shrinker {
  */
 #define SHRINKER_NONSLAB	BIT(4)
 
+__printf(2, 3)
 struct shrinker *shrinker_alloc(unsigned int flags, const char *fmt, ...);
 void shrinker_register(struct shrinker *shrinker);
 void shrinker_free(struct shrinker *shrinker);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-add-printf-attribute-to-shrinker_debugfs_name_alloc.patch
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg-fix.patch
mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes.patch
mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix.patch
mark-stuff-as-__ro_after_init-checkpatch-fixes.patch
mark-stuff-as-__ro_after_init-fix.patch

