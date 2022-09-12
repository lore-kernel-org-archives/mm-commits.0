Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02341C54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiILDci (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiILDah (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:30:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE0BFD11
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47B92B8085E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5597C433D7;
        Mon, 12 Sep 2022 03:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953376;
        bh=4aNhilGDRZ+ty5plDg+tx+siBZ1CDvNWljqUdv9Bjus=;
        h=Date:To:From:Subject:From;
        b=rnvpqvg3AiP4lHEbIOdEorCRk4pWJ1fwszTDEDNq+8UpGV/qEFEUcZ0VPrfJods2T
         ZSrNK9nZD2PC86HpFXBRIM3xsGvYgSIQeDmNvVdP5viUm9UvW1Iav/93pLX9//t5hC
         B4fJmY29dis28yS9oI1z2PGDQiDbdKVH8/UHGFAs=
Date:   Sun, 11 Sep 2022 20:29:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, qiuxu.zhuo@intel.com, linmiaohe@huawei.com,
        aaron.lu@intel.com, fengwei.yin@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-release-private-data-before-split-thp.patch removed from -mm tree
Message-Id: <20220912032935.E5597C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: release private data before split THP
has been removed from the -mm tree.  Its filename was
     mm-release-private-data-before-split-thp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: mm: release private data before split THP
Date: Wed, 10 Aug 2022 14:49:07 +0800

If there is private data attached to a THP, the refcount of THP will be
increased and will prevent the THP from being split.  Attempt to release
any private data attached to the THP before attempting the split to
increase the chance of splitting successfully.

There was a memory failure issue hit during HW error injection testing
with 5.18 kernel + xfs as rootfs.  The test was killed and a system reboot
was required to re-run the test.

The issue was tracked down to a THP split failure caused by the memory
failure not being handled.  The page dump showed:

[ 1785.433075] page:0000000025f9530b refcount:18 mapcount:0 mapping:000000008162eea7 index:0xa10 pfn:0x2f0200
[ 1785.443954] head:0000000025f9530b order:4 compound_mapcount:0 compound_pincount:0
[ 1785.452408] memcg:ff4247f2d28e9000
[ 1785.456304] aops:xfs_address_space_operations ino:8555182 dentry name:"baseos-filenames.solvx"
[ 1785.466612] flags: 0x1000000000012036(referenced|uptodate|lru|active|private|head|node=0|zone=2)
[ 1785.476514] raw: 1000000000012036 ffb9460f8bc07c08 ffb9460f8bc08408 ff4247f22e6299f8
[ 1785.485268] raw: 0000000000000a10 ff4247f194ade900 00000012ffffffff ff4247f2d28e9000

It was like the error was injected to a large folio for xfs with private
data attached.

With private data released before splitting the THP, the test case could
be run successfully many times without rebooting the system.

Link: https://lkml.kernel.org/r/20220810064907.582899-1-fengwei.yin@intel.com
Co-developed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-release-private-data-before-split-thp
+++ a/mm/huge_memory.c
@@ -2643,6 +2643,8 @@ int split_huge_page_to_list(struct page
 		mapping = NULL;
 		anon_vma_lock_write(anon_vma);
 	} else {
+		gfp_t gfp;
+
 		mapping = head->mapping;
 
 		/* Truncated ? */
@@ -2651,8 +2653,16 @@ int split_huge_page_to_list(struct page
 			goto out;
 		}
 
-		xas_split_alloc(&xas, head, compound_order(head),
-				mapping_gfp_mask(mapping) & GFP_RECLAIM_MASK);
+		gfp = current_gfp_context(mapping_gfp_mask(mapping) &
+							GFP_RECLAIM_MASK);
+
+		if (folio_test_private(folio) &&
+				!filemap_release_folio(folio, gfp)) {
+			ret = -EBUSY;
+			goto out;
+		}
+
+		xas_split_alloc(&xas, head, compound_order(head), gfp);
 		if (xas_error(&xas)) {
 			ret = xas_error(&xas);
 			goto out;
_

Patches currently in -mm which might be from fengwei.yin@intel.com are


