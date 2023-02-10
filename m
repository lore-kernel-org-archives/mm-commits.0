Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7647C05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjBJAwX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjBJAwW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2186779C
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03EC7B82395
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88105C433EF;
        Fri, 10 Feb 2023 00:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990338;
        bh=vl1st2x+g2c0ALxfrIUp0GF0QSGYypyZliPGW6j7Khc=;
        h=Date:To:From:Subject:From;
        b=pvUHd6OEHaQag2z8HHfgs3+OXZyaMxx+XhPTzt6kzMoUxlggDRYxOahivpKcpCLuZ
         wbpSaHgV9VIeUz/s8VNHk+n8RbC5pDx60SPxy8M5b8zELG/mtQixehgEHmEbcm0SBm
         AZrs429sJTlEB0wIwxAlPtQoCaGvePA6I6QBwves=
Date:   Thu, 09 Feb 2023 16:52:17 -0800
To:     mm-commits@vger.kernel.org, rmk+kernel@armlinux.org.uk,
        broonie@kernel.org, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm-mm-fix-swp-type-masking-in-__swp_entry.patch removed from -mm tree
Message-Id: <20230210005218.88105C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm/mm: fix swp type masking in __swp_entry()
has been removed from the -mm tree.  Its filename was
     arm-mm-fix-swp-type-masking-in-__swp_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: arm/mm: fix swp type masking in __swp_entry()
Date: Wed, 8 Feb 2023 15:08:01 +0100

We're masking with the number of type bits instead of the type mask, which
is obviously wrong.

Link: https://lkml.kernel.org/r/39fd91e3-c93b-23c6-afc6-cbe473bb0ca9@redhat.com
Fixes: 20aae9eff5ac ("arm/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/include/asm/pgtable.h~arm-mm-fix-swp-type-masking-in-__swp_entry
+++ a/arch/arm/include/asm/pgtable.h
@@ -292,7 +292,7 @@ static inline pte_t pte_modify(pte_t pte
 
 #define __swp_type(x)		(((x).val >> __SWP_TYPE_SHIFT) & __SWP_TYPE_MASK)
 #define __swp_offset(x)		((x).val >> __SWP_OFFSET_SHIFT)
-#define __swp_entry(type, offset) ((swp_entry_t) { (((type) & __SWP_TYPE_BITS) << __SWP_TYPE_SHIFT) | \
+#define __swp_entry(type, offset) ((swp_entry_t) { (((type) & __SWP_TYPE_MASK) << __SWP_TYPE_SHIFT) | \
 						   ((offset) << __SWP_OFFSET_SHIFT) })
 
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
_

Patches currently in -mm which might be from david@redhat.com are


