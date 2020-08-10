Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE08C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C8CC206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027058;
	bh=jxcSue6gmG20jmtJnA2L4eIO3rCYei0B4DGP3Ev+oKA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=hIcyZFIhxbhho81+Iq/Zw3Xe+3Fs/XQwMn1E1lqmj0+Tsd8GDbntqu9hdAjC59MhX
	 B+NHUYc+Qucf9LOc9j8fNk08si3yr/jml8iSq/M4DdQ42jVytQu+OcZwaDhyzlhXTw
	 uDlzbQbFKEStP245B469IdOl+IpHO50oZPo2yHzA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgHJChi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJChh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:37:37 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D7CF2065D;
        Mon, 10 Aug 2020 02:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027057;
        bh=jxcSue6gmG20jmtJnA2L4eIO3rCYei0B4DGP3Ev+oKA=;
        h=Date:From:To:Subject:From;
        b=gHscxFR3g8fnTk8H7ZXgO7ZwIA4Gv+M0Vs3eHbrO4P/mjLB8REGSQNQVtQ6AscgLK
         2/3HC/To86cAnn3Cdtp0+tsnBpOcY4UJIJRYgJPVYtnpArR0uzYIc1NBWtpl0I6Mkh
         ScnxeObznxM64oYOqKn3OIWzbxWl6YNdz418JCr8=
Date:   Sun, 09 Aug 2020 19:37:37 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, jgg@mellanox.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com
Subject:  [merged] mm-remove-redundant-check-non_swap_entry.patch
 removed from -mm tree
Message-ID: <20200810023737.iLrrUX5j2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove redundant check non_swap_entry()
has been removed from the -mm tree.  Its filename was
     mm-remove-redundant-check-non_swap_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm: remove redundant check non_swap_entry()

In zap_pte_range(), the check for non_swap_entry() and
is_device_private_entry() is unnecessary since the latter is sufficient to
determine if the page is a device private page.  Remove the test for
non_swap_entry() to simplify the code and for clarity.

Link: http://lkml.kernel.org/r/20200615175405.4613-1-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-remove-redundant-check-non_swap_entry
+++ a/mm/memory.c
@@ -1098,7 +1098,7 @@ again:
 		}
 
 		entry = pte_to_swp_entry(ptent);
-		if (non_swap_entry(entry) && is_device_private_entry(entry)) {
+		if (is_device_private_entry(entry)) {
 			struct page *page = device_private_entry_to_page(entry);
 
 			if (unlikely(details && details->check_mapping)) {
_

Patches currently in -mm which might be from rcampbell@nvidia.com are

mm-migrate-optimize-migrate_vma_setup-for-holes.patch
mm-migrate-optimize-migrate_vma_setup-for-holes-v2.patch
mm-migrate-add-migrate-shared-test-for-migrate_vma_.patch

