Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1439C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98E4620829
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597194012;
	bh=i0lASqJDlR6Pcq/lMP4mYWyxv/e8AUHNAbWASlDHc4c=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KiRs74/28PRX/55TBgTPp2y9zkxkzWs1PJOHZrGtnAKWaIjnzl+BT/rjOT+5k29MC
	 yJC8RT8O5A0q9qwcQitH8zyNJ0zmM0xIRCo9wxprP+mZBpgK4gT3keUHopb+mgSyZg
	 pZi9caASh7IWZBS7s/AqDkiVTXe64lS/6+FEFhJ0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgHLBAM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgHLBAM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:00:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C8A1207DA;
        Wed, 12 Aug 2020 01:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597194011;
        bh=i0lASqJDlR6Pcq/lMP4mYWyxv/e8AUHNAbWASlDHc4c=;
        h=Date:From:To:Subject:From;
        b=JQzkOxzxbDDIHnrPoKsjq1G6XL+ETlU/EYoXHhaAOCJbvvGgZOFu2SH258dp35lsh
         aJHBPN/GeTKwQmoZdBcw04SIwh/qdcqcMHcBjthzMFKPMcGEcfjDRNB7gE0hciyFbO
         iJVfQrl031y6dznnhcmHKn2oheqLcbiyXFt8vx/8=
Date:   Tue, 11 Aug 2020 18:00:11 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, mm-commits@vger.kernel.org,
        ziy@nvidia.com
Subject:  [folded-merged]
 mm-vmstat-add-events-for-thp-migration-without-split-v4.patch removed from
 -mm tree
Message-ID: <20200812010011.rTSiNKUn3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmstat-add-events-for-thp-migration-without-split-v4
has been removed from the -mm tree.  Its filename was
     mm-vmstat-add-events-for-thp-migration-without-split-v4.patch

This patch was dropped because it was folded into mm-vmstat-add-events-for-thp-migration-without-split.patch

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm-vmstat-add-events-for-thp-migration-without-split-v4

s/thp_nr_pages/hpage_nr_pages/

Link: http://lkml.kernel.org/r/1594287583-16568-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-vmstat-add-events-for-thp-migration-without-split-v4
+++ a/mm/migrate.c
@@ -1446,7 +1446,7 @@ retry:
 			 * during migration.
 			 */
 			is_thp = PageTransHuge(page);
-			nr_subpages = thp_nr_pages(page);
+			nr_subpages = hpage_nr_pages(page);
 			cond_resched();
 
 			if (PageHuge(page))
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-vmstat-add-events-for-thp-migration-without-split.patch

