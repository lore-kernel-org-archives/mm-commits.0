Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8196FC19F2C
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239575AbiG3BIV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239572AbiG3BIS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E33820D8
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01300B82929
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5EAC433D6;
        Sat, 30 Jul 2022 01:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143294;
        bh=2m1ulJJ2GhRsMeJnjkzmdB8ex6Vf+S1SWJMRNZSBa8g=;
        h=Date:To:From:Subject:From;
        b=EuME7rQ9QVrOka8tZN9Ao+LzQzvLygmeQugFVodbe9WOR1uEfiXVJ3IIFFsgBcvfX
         IBn8a/VB3FcCDa68swzVgUIhd3lr1BsK/aZmsprXs08scA85K3KL1ylkbM6WCWc+ye
         6Xr2/HE7zXPdV4gQRImv5uyDrB8mD/TlddQhdaPE=
Date:   Fri, 29 Jul 2022 18:08:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-minor-cleanup-for-filemap_write_and_wait_range.patch removed from -mm tree
Message-Id: <20220730010814.9E5EAC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: minor cleanup for filemap_write_and_wait_range
has been removed from the -mm tree.  Its filename was
     filemap-minor-cleanup-for-filemap_write_and_wait_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: filemap: minor cleanup for filemap_write_and_wait_range
Date: Mon, 27 Jun 2022 21:23:51 +0800

Restructure the logic in filemap_write_and_wait_range to simplify the code
and make it more consistent with file_write_and_wait_range. No functional
change intended.

Link: https://lkml.kernel.org/r/20220627132351.55680-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/mm/filemap.c~filemap-minor-cleanup-for-filemap_write_and_wait_range
+++ a/mm/filemap.c
@@ -667,7 +667,7 @@ EXPORT_SYMBOL_GPL(filemap_range_has_writ
 int filemap_write_and_wait_range(struct address_space *mapping,
 				 loff_t lstart, loff_t lend)
 {
-	int err = 0;
+	int err = 0, err2;
 
 	if (mapping_needs_writeback(mapping)) {
 		err = __filemap_fdatawrite_range(mapping, lstart, lend,
@@ -678,18 +678,12 @@ int filemap_write_and_wait_range(struct
 		 * But the -EIO is special case, it may indicate the worst
 		 * thing (e.g. bug) happened, so we avoid waiting for it.
 		 */
-		if (err != -EIO) {
-			int err2 = filemap_fdatawait_range(mapping,
-						lstart, lend);
-			if (!err)
-				err = err2;
-		} else {
-			/* Clear any previously stored errors */
-			filemap_check_errors(mapping);
-		}
-	} else {
-		err = filemap_check_errors(mapping);
+		if (err != -EIO)
+			__filemap_fdatawait_range(mapping, lstart, lend);
 	}
+	err2 = filemap_check_errors(mapping);
+	if (!err)
+		err = err2;
 	return err;
 }
 EXPORT_SYMBOL(filemap_write_and_wait_range);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

