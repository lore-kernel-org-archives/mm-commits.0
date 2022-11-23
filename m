Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE3CC433FE
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 02:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbiKWCxW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 21:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235612AbiKWCxT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 21:53:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9897A349
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 18:53:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12835B81E5E
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 02:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9B1C433C1;
        Wed, 23 Nov 2022 02:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669171995;
        bh=U1ocGuVnRMkrubRDB4h1Q++VJaPPvFJ52OpxBNyAe9k=;
        h=Date:To:From:Subject:From;
        b=aXL8JUiPUvDbSlhR2bWhB5Ue9WsiKnavzdUM0mBevQM8U8GY2PHBMdJfEITutFU3L
         NeWE6JRkryVTHnGPLWmchO/lkfKyd2kijzu3ZQu38dKdSv0DhXReInrAyfXiVdS6nZ
         CynkoZ9xfW/lzoXSp5nSmqIRH/CJSS1lM7Gw5+Y0=
Date:   Tue, 22 Nov 2022 18:53:14 -0800
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        david@redhat.com, ian@linux.cowan.aero, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mmap-fix-documentation-for-vma_mas_szero.patch removed from -mm tree
Message-Id: <20221123025315.9F9B1C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: mmap: fix documentation for vma_mas_szero
has been removed from the -mm tree.  Its filename was
     mm-mmap-fix-documentation-for-vma_mas_szero.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ian Cowan <ian@linux.cowan.aero>
Subject: mm: mmap: fix documentation for vma_mas_szero
Date: Sun, 13 Nov 2022 19:33:49 -0500

When the struct_mm input, mm, was changed to a struct ma_state, mas, the
documentation for the function was never updated.  This updates that
documentation reference.

Link: https://lkml.kernel.org/r/20221114003349.41235-1-ian@linux.cowan.aero
Signed-off-by: Ian Cowan <ian@linux.cowan.aero>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-fix-documentation-for-vma_mas_szero
+++ a/mm/mmap.c
@@ -456,7 +456,7 @@ void vma_mas_remove(struct vm_area_struc
  * vma_mas_szero() - Set a given range to zero.  Used when modifying a
  * vm_area_struct start or end.
  *
- * @mm: The struct_mm
+ * @mas: The maple tree ma_state
  * @start: The start address to zero
  * @end: The end address to zero.
  */
_

Patches currently in -mm which might be from ian@linux.cowan.aero are


