Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EAE5C727A1
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242049AbjHXXWv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244085AbjHXXWM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082A4A8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 812406393B
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86C1C433C7;
        Thu, 24 Aug 2023 23:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919329;
        bh=gNDvCTFy86aL194gZCj/WpjlLe3xE4yWPdcxg4AZdqE=;
        h=Date:To:From:Subject:From;
        b=y2LAT56nSH6y5Lz63GvZSb0iYUDs6dCZZyu82nzi+hjp+5mrj7Ww+ppzW93MxZDEL
         mrxEcmXexHn6vBljQTj3jT4I+fH+0d9LGGoN9WBqxBOpRA0ClLJs9gSYLIQ6k+YTvV
         d/irozfHulmAfJbcI3tJAJEOdKayziPIRk41has4=
Date:   Thu, 24 Aug 2023 16:22:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-pmd_order-to-pgtableh.patch removed from -mm tree
Message-Id: <20230824232209.D86C1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move PMD_ORDER to pgtable.h
has been removed from the -mm tree.  Its filename was
     mm-move-pmd_order-to-pgtableh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: move PMD_ORDER to pgtable.h
Date: Fri, 18 Aug 2023 21:23:33 +0100

Patch series "Change calling convention for ->huge_fault", v2.

There are two unrelated changes to the calling convention for
->huge_fault.  I've bundled them together to help people notice the
change.  The first is to improve scalability of DAX page faults by
allowing them to be handled under the VMA lock.  The second is to remove
enum page_entry_size since it's really unnecessary.  The changelogs and
documentation updates hopefully work to that end.


This patch (of 3):

Allow this to be used in generic code.  Also add PUD_ORDER.

Link: https://lkml.kernel.org/r/20230818202335.2739663-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230818202335.2739663-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                |    3 ---
 include/linux/pgtable.h |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/dax.c~mm-move-pmd_order-to-pgtableh
+++ a/fs/dax.c
@@ -49,9 +49,6 @@ static inline unsigned int pe_order(enum
 #define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
 #define PG_PMD_NR	(PMD_SIZE >> PAGE_SHIFT)
 
-/* The order of a PMD entry */
-#define PMD_ORDER	(PMD_SHIFT - PAGE_SHIFT)
-
 static wait_queue_head_t wait_table[DAX_WAIT_TABLE_ENTRIES];
 
 static int __init init_dax_wait_table(void)
--- a/include/linux/pgtable.h~mm-move-pmd_order-to-pgtableh
+++ a/include/linux/pgtable.h
@@ -5,6 +5,9 @@
 #include <linux/pfn.h>
 #include <asm/pgtable.h>
 
+#define PMD_ORDER	(PMD_SHIFT - PAGE_SHIFT)
+#define PUD_ORDER	(PUD_SHIFT - PAGE_SHIFT)
+
 #ifndef __ASSEMBLY__
 #ifdef CONFIG_MMU
 
_

Patches currently in -mm which might be from willy@infradead.org are


