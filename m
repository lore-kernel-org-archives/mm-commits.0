Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBDFEC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6208206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027141;
	bh=OeJldfCCi2JCmTBFzTn1cmUzS8PB6ajU9Ds2h+EKLEk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=kwckrqb5ZloW+Hf7Bwf0QPLy9Uy4wYFRnMTszljb5IjAxyHvgBj48bS4qw1BS1rpy
	 6jd/5ppnqdNs5JlEXw1eAX48kKm9QR1mmWVZF104fcsI1v2/aOz04j7oZ48W6rQ8oG
	 5ysmIx+Pnd9hlQp+Ol7qg+atvq5Qqrnu1ZVlNt0E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgHJCjB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgHJCjB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:39:01 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82D142065D;
        Mon, 10 Aug 2020 02:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027140;
        bh=OeJldfCCi2JCmTBFzTn1cmUzS8PB6ajU9Ds2h+EKLEk=;
        h=Date:From:To:Subject:From;
        b=kUWAJBRtK+8Ipy0IHGgRqOaoXomHtEy3R+cOMX/IkU4UZmu9fRUVJcpOHlPUpyc75
         gQ6H07TmxzW1Z+CKtyjW0HgqnIZrPHp0JeVSD8QZqd8cII8tBglLAN/EJIb+I4ZDzA
         Wh/rz1GysJ1CVqczbq8Yn4YTK1/fHXH69wTi/wXo=
Date:   Sun, 09 Aug 2020 19:39:00 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, jroedel@suse.de, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  [merged]
 mm-vmalloc-remove-redundant-asignmnet-in-unmap_kernel_range_noflush.patch
 removed from -mm tree
Message-ID: <20200810023900.QwX2N6fCq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: remove redundant assignment in unmap_kernel_range_noflush()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-redundant-asignmnet-in-unmap_kernel_range_noflush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: vmalloc: remove redundant assignment in unmap_kernel_range_noflush()

'addr' is set to 'start' and then a few lines afterwards 'start' is set to
'addr'.  Remove the second asignment.

Link: http://lkml.kernel.org/r/20200707163226.374685-1-rppt@kernel.org
Fixes: 2ba3e6947aed ("mm/vmalloc: track which page-table levels were modified")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-redundant-asignmnet-in-unmap_kernel_range_noflush
+++ a/mm/vmalloc.c
@@ -175,7 +175,6 @@ void unmap_kernel_range_noflush(unsigned
 	pgtbl_mod_mask mask = 0;
 
 	BUG_ON(addr >= end);
-	start = addr;
 	pgd = pgd_offset_k(addr);
 	do {
 		next = pgd_addr_end(addr, end);
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


