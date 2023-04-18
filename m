Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E46C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjDRXOX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjDRXOW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:14:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B14C8A5C
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:14:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCC5E6332E
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30221C433D2;
        Tue, 18 Apr 2023 23:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681859659;
        bh=RnwkaRQXDrkMOcW+axfcIIOeAgLOnAc2ebvphA6e8yw=;
        h=Date:To:From:Subject:From;
        b=B1i15kcHXznNgmwdt1+VDWsQTjpTsW7dntRei7yIOXZIfnRkr3qlBktbTG7nuC8u9
         aL5x5x6H46W5RSO9S8R9eOKwzFokUFs8Uifrp/mUpkz/Dx27Sb2wh512hkjJ7PO9oW
         rR0B3TXjrJMfIzKEazksO2irKAhKQG9rcZaJQzDQ=
Date:   Tue, 18 Apr 2023 16:14:18 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, sj@kernel.org,
        rppt@kernel.org, oliver.sang@intel.com, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-make-arch_has_descending_max_zone_pfns-static-v2.patch removed from -mm tree
Message-Id: <20230418231419.30221C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: [v2] mm: make arch_has_descending_max_zone_pfns() static
has been removed from the -mm tree.  Its filename was
     mm-make-arch_has_descending_max_zone_pfns-static-v2.patch

This patch was dropped because it was folded into mm-make-arch_has_descending_max_zone_pfns-static.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: [v2] mm: make arch_has_descending_max_zone_pfns() static
Date: Sat, 15 Apr 2023 10:18:20 +0200

fix logic bug

Link: https://lkml.kernel.org/r/20230415081904.969049-1-arnd@kernel.org
Fixes: 9420f89db2dd ("mm: move most of core MM initialization to mm/mm_init.c")
Reported-by: kernel test robot <oliver.sang@intel.com>
  https://lore.kernel.org/oe-lkp/202304151422.5e4d380b-oliver.sang@intel.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-make-arch_has_descending_max_zone_pfns-static-v2
+++ a/mm/mm_init.c
@@ -1754,7 +1754,7 @@ static void __init free_area_init_memory
  */
 static bool arch_has_descending_max_zone_pfns(void)
 {
-	return !IS_ENABLED(CONFIG_ARC_HAS_PAE40);
+	return IS_ENABLED(CONFIG_ARC) && !IS_ENABLED(CONFIG_ARC_HAS_PAE40);
 }
 
 /**
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-make-arch_has_descending_max_zone_pfns-static.patch
kasan-remove-hwasan-kernel-mem-intrinsic-prefix=1-for-clang-14.patch
ocfs2-reduce-ioctl-stack-usage.patch

