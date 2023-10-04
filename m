Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D1BE7C4F6
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243941AbjJDUST (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243994AbjJDUSS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A278C9
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF54C433C9;
        Wed,  4 Oct 2023 20:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450692;
        bh=65gs62pYIOJ7DvoiH4g/q58I4Jr6gyYBdao79QnBcQQ=;
        h=Date:To:From:Subject:From;
        b=hZBY0Jjv87kF8V0znm812How28+ESyP5ZWEGIVf1Yyb40N7MUq77mFnMSsIXi/zPz
         BrfDj0qkXzc+pukNm52BVUiQnmWhOu/wyzSQBAWFYTsmzfwZbEnrDOE02n2EtAhhxi
         2HE0dcbVD7HjQ5YYBiUcdk5QdVeV5kg3wCEfk6Co=
Date:   Wed, 04 Oct 2023 13:18:10 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, hannes@cmpxchg.org,
        ddstreet@ieee.org, cerasuolodomenico@gmail.com, nphamcs@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zswap-change-zswaps-default-allocator-to-zsmalloc.patch removed from -mm tree
Message-Id: <20231004201811.DEF54C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zswap: change zswap's default allocator to zsmalloc
has been removed from the -mm tree.  Its filename was
     zswap-change-zswaps-default-allocator-to-zsmalloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zswap: change zswap's default allocator to zsmalloc
Date: Fri, 8 Sep 2023 16:51:15 -0700

Out of zswap's 3 allocators, zsmalloc is the clear superior in terms of
memory utilization, both in theory and as observed in practice, with its
high storage density and low internal fragmentation.  zsmalloc is also
more actively developed and maintained, since it is the allocator of
choice for zswap for many users, as well as the only allocator for zram.

A historical objection to the selection of zsmalloc as the default
allocator for zswap is its lack of writeback capability.  However, this
has changed, with the zsmalloc writeback patchset, and the subsequent
zswap LRU refactor.  With this, there is not a lot of good reasons to keep
zbud, an otherwise inferior allocator, as the default instead of zswap.

This patch changes the default allocator to zsmalloc.  The only exception
is on settings without MMU, in which case zbud will remain as the default.

Link: https://lkml.kernel.org/r/20230908235115.2943486-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Kconfig~zswap-change-zswaps-default-allocator-to-zsmalloc
+++ a/mm/Kconfig
@@ -130,6 +130,7 @@ config ZSWAP_COMPRESSOR_DEFAULT
 choice
 	prompt "Default allocator"
 	depends on ZSWAP
+	default ZSWAP_ZPOOL_DEFAULT_ZSMALLOC if MMU
 	default ZSWAP_ZPOOL_DEFAULT_ZBUD
 	help
 	  Selects the default allocator for the compressed cache for
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zswap-shrinks-zswap-pool-based-on-memory-pressure.patch
memcontrol-add-helpers-for-hugetlb-memcg-accounting.patch
hugetlb-memcg-account-hugetlb-backed-memory-in-memory-controller.patch
hugetlb-memcg-account-hugetlb-backed-memory-in-memory-controller-fix.patch
selftests-add-a-selftest-to-verify-hugetlb-usage-in-memcg.patch

