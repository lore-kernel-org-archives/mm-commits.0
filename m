Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F56DC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbiGRASN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbiGRARQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EE8AE45
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 086DEB80EEE
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F197C3411E;
        Mon, 18 Jul 2022 00:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103425;
        bh=JeR+F9pwAtY0jbXk6rvrgv/mia6OndCfVEZaoRF06os=;
        h=Date:To:From:Subject:From;
        b=Vp5OtucPVk8iwVLLg3kn7h8X1GhMSyGlY7RWh3lbB1eeDNKSrqU0al3e8Qw3GytUk
         1ltBGljXbrYVWfy99KWHor2LoOe++AtRxEMaqm/gEtasqpTjYB4v1Z3tK7rBXMG9G2
         fGtGc6+KY9PfP0p0cie2uYBtvfiCEIu9cKAEOtjk=
Date:   Sun, 17 Jul 2022 17:17:05 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] doc-proc-fix-the-description-to-thpeligible.patch removed from -mm tree
Message-Id: <20220718001705.9F197C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: doc: proc: fix the description to THPeligible
has been removed from the -mm tree.  Its filename was
     doc-proc-fix-the-description-to-thpeligible.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: doc: proc: fix the description to THPeligible
Date: Thu, 16 Jun 2022 10:48:40 -0700

The THPeligible bit shows 1 if and only if the VMA is eligible for
allocating THP and the THP is also PMD mappable.  Some misaligned file
VMAs may be eligible for allocating THP but the THP can't be mapped by
PMD.  Make this more explicitly to avoid ambiguity.

Link: https://lkml.kernel.org/r/20220616174840.1202070-8-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/Documentation/filesystems/proc.rst~doc-proc-fix-the-description-to-thpeligible
+++ a/Documentation/filesystems/proc.rst
@@ -517,8 +517,10 @@ replaced by copy-on-write) part of the u
 "SwapPss" shows proportional swap share of this mapping. Unlike "Swap", this
 does not take into account swapped out page of underlying shmem objects.
 "Locked" indicates whether the mapping is locked in memory or not.
+
 "THPeligible" indicates whether the mapping is eligible for allocating THP
-pages - 1 if true, 0 otherwise. It just shows the current status.
+pages as well as the THP is PMD mappable or not - 1 if true, 0 otherwise.
+It just shows the current status.
 
 "VmFlags" field deserves a separate description. This member represents the
 kernel flags associated with the particular virtual memory area in two letter
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-khugepaged-dont-carry-huge-page-to-the-next-loop-for-config_numa.patch

