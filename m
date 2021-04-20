Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD05C43461
	for <mm-commits@archiver.kernel.org>; Tue, 20 Apr 2021 22:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A4B361410
	for <mm-commits@archiver.kernel.org>; Tue, 20 Apr 2021 22:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbhDTW4Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Apr 2021 18:56:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234249AbhDTW4Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Apr 2021 18:56:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E53361406;
        Tue, 20 Apr 2021 22:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618959352;
        bh=A8MGY2ptUCks4k6nWvI3ZW6JUc3C2WgHHl0sgFSl8jk=;
        h=Date:From:To:Subject:From;
        b=wzqg0f1v1FuiXwvphpe4AIk04TG5AkkTDdtHu1alCNSfnLBw9FP8Ng9gYc+Q0rqtg
         ftGSpPEmFD9ct46gd69VMwDRQxeSzzypyli+Ap5FnEIgY447KNxDu6HoMc7L488tZA
         18HKXyP8q4TbcCkClm/Mik7oF0JZFNTTebXpSjqQ=
Date:   Tue, 20 Apr 2021 15:55:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, thomas_os@shipmail.org,
        zackr@vmware.com
Subject:  [merged]
 mm-mapping_dirty_helpers-guard-hugepage-puds-usage.patch removed from -mm
 tree
Message-ID: <20210420225552.htm7y5yVM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mapping_dirty_helpers: guard hugepage pud's usage
has been removed from the -mm tree.  Its filename was
     mm-mapping_dirty_helpers-guard-hugepage-puds-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zack Rusin <zackr@vmware.com>
Subject: mm/mapping_dirty_helpers: guard hugepage pud's usage

Mapping dirty helpers have, so far, been only used on X86, but a port of
vmwgfx to ARM64 exposed a problem which results in a compilation error on
ARM64 systems:

mm/mapping_dirty_helpers.c: In function `wp_clean_pud_entry':
mm/mapping_dirty_helpers.c:172:32: error: implicit declaration of function `pud_dirty'; did you mean `pmd_dirty'? [-Werror=implicit-function-declaration]

This is due to the fact that mapping_dirty_helpers code assumes that
pud_dirty is always defined, which is not the case for architectures that
don't define CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD.

ARM64 arch is a little inconsistent when it comes to PUD hugepage helpers,
e.g.  it defines pud_young but not pud_dirty but regardless of that the
core kernel code shouldn't assume that any of the PUD hugepage helpers are
available unless CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD is defined. 
This prevents compilation errors whenever one of the drivers is ported to
new architectures.

Link: https://lkml.kernel.org/r/20210409165151.694574-1-zackr@vmware.com
Signed-off-by: Zack Rusin <zackr@vmware.com>
Reviewed-by: Thomas Hellstrm (Intel) <thomas_os@shipmail.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mapping_dirty_helpers.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mapping_dirty_helpers.c~mm-mapping_dirty_helpers-guard-hugepage-puds-usage
+++ a/mm/mapping_dirty_helpers.c
@@ -165,10 +165,12 @@ static int wp_clean_pud_entry(pud_t *pud
 		return 0;
 	}
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 	/* Huge pud */
 	walk->action = ACTION_CONTINUE;
 	if (pud_trans_huge(pudval) || pud_devmap(pudval))
 		WARN_ON(pud_write(pudval) || pud_dirty(pudval));
+#endif
 
 	return 0;
 }
_

Patches currently in -mm which might be from zackr@vmware.com are


