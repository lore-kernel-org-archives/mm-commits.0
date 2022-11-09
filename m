Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F3FC4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiKIBlp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiKIBkD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0950667F71
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B860AB81CD8
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64752C433D6;
        Wed,  9 Nov 2022 01:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957962;
        bh=h4HPHCgq8WYIORXW+e6qKhzF24MU4Uxl0AWa61IX3/g=;
        h=Date:To:From:Subject:From;
        b=AHilrrHGyMiNUNkE3/iclkZYjdK2W/oYajpdkPt2ij3eFBTMc6qEVQNRxtBgDb6sQ
         MtrTtnPij23J36VweXax9HoVveHw7L+9TBmaJXK0LgG+H3mQ6/dv/kOqUdfnBOwBD0
         XO21Y0Jm55Hp2PVDTzaAq3gcKyuzo9XOppLGyw04=
Date:   Tue, 08 Nov 2022 17:39:21 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-avoid-pfn_valid-twice-in-soft_offline_page.patch removed from -mm tree
Message-Id: <20221109013922.64752C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: avoid pfn_valid() twice in soft_offline_page()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-avoid-pfn_valid-twice-in-soft_offline_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory-failure: avoid pfn_valid() twice in soft_offline_page()
Date: Fri, 21 Oct 2022 16:46:10 +0800

Simplify WARN_ON_ONCE(flags & MF_COUNT_INCREASED) under !pfn_valid().

Link: https://lkml.kernel.org/r/20221021084611.53765-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-avoid-pfn_valid-twice-in-soft_offline_page
+++ a/mm/memory-failure.c
@@ -2551,10 +2551,10 @@ int soft_offline_page(unsigned long pfn,
 	bool try_again = true;
 	struct page *page;
 
-	WARN_ON_ONCE(!pfn_valid(pfn) && (flags & MF_COUNT_INCREASED));
-
-	if (!pfn_valid(pfn))
+	if (!pfn_valid(pfn)) {
+		WARN_ON_ONCE(flags & MF_COUNT_INCREASED);
 		return -ENXIO;
+	}
 
 	/* Only online pages can be soft-offlined (esp., not ZONE_DEVICE). */
 	page = pfn_to_online_page(pfn);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


