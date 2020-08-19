Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CA2C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 02:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4B132078B
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 02:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597805718;
	bh=eSLKJn+9EGFKaqQ2z/aUm1/ogVwKgA3udJf+Hyi4km0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=bPaFrUqBIzEVaDstL6mmIVQV3u5XYo0S2KzwRkrsmaB4LcbBGhSqGEz7RAWc/YQiT
	 KdNAqdQ3tRY3wqHqVh9Zqnnwz9jV3os1LILjtRT1iCHDaP2mDvTCosoCH2c1SEyHHK
	 YSp26mS2x9XvXaCwXzkI9vdWwUTrdDenqqrlcNfs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgHSCzS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 22:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726870AbgHSCzR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 22:55:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8D1F2076E;
        Wed, 19 Aug 2020 02:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597805717;
        bh=eSLKJn+9EGFKaqQ2z/aUm1/ogVwKgA3udJf+Hyi4km0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=exBEpi4R0WU/jRoxg/WAKeW5yE/hM3WM4X2K/QTpwPwfLDkRLw+pVGKDjEDFTGHoI
         DWGhEDtZGHdzdzKwpRKy7i8szrWwGIZN4Idfhio/jJhwv4lYjoZ0BwndMLI0yz1rQ3
         mWqt0X6dQrQV1WrSqLr9fZblO0gwEBvFMQgLmaPM=
Date:   Tue, 18 Aug 2020 19:55:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bhe@redhat.com, cai@lca.pw, david@redhat.com, jasowang@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mst@redhat.com,
        pankaj.gupta.linux@gmail.com, rppt@linux.ibm.com
Subject:  + mm-document-semantics-of-zone_movable.patch added to
 -mm tree
Message-ID: <20200819025516.In3Z3ROw4%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: document semantics of ZONE_MOVABLE
has been added to the -mm tree.  Its filename is
     mm-document-semantics-of-zone_movable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-document-semantics-of-zone_movable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-document-semantics-of-zone_movable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: document semantics of ZONE_MOVABLE

Let's document what ZONE_MOVABLE means, how it's used, and which special
cases we have regarding unmovable pages (memory offlining vs.  migration /
allocations).

Link: http://lkml.kernel.org/r/20200816125333.7434-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/include/linux/mmzone.h~mm-document-semantics-of-zone_movable
+++ a/include/linux/mmzone.h
@@ -396,6 +396,41 @@ enum zone_type {
 	 */
 	ZONE_HIGHMEM,
 #endif
+	/*
+	 * ZONE_MOVABLE is similar to ZONE_NORMAL, except that it contains
+	 * movable pages with few exceptional cases described below. Main use
+	 * cases for ZONE_MOVABLE are to make memory offlining/unplug more
+	 * likely to succeed, and to locally limit unmovable allocations - e.g.,
+	 * to increase the number of THP/huge pages. Notable special cases are:
+	 *
+	 * 1. Pinned pages: (long-term) pinning of movable pages might
+	 *    essentially turn such pages unmovable. Memory offlining might
+	 *    retry a long time.
+	 * 2. memblock allocations: kernelcore/movablecore setups might create
+	 *    situations where ZONE_MOVABLE contains unmovable allocations
+	 *    after boot. Memory offlining and allocations fail early.
+	 * 3. Memory holes: kernelcore/movablecore setups might create very rare
+	 *    situations where ZONE_MOVABLE contains memory holes after boot,
+	 *    for example, if we have sections that are only partially
+	 *    populated. Memory offlining and allocations fail early.
+	 * 4. PG_hwpoison pages: while poisoned pages can be skipped during
+	 *    memory offlining, such pages cannot be allocated.
+	 * 5. Unmovable PG_offline pages: in paravirtualized environments,
+	 *    hotplugged memory blocks might only partially be managed by the
+	 *    buddy (e.g., via XEN-balloon, Hyper-V balloon, virtio-mem). The
+	 *    parts not manged by the buddy are unmovable PG_offline pages. In
+	 *    some cases (virtio-mem), such pages can be skipped during
+	 *    memory offlining, however, cannot be moved/allocated. These
+	 *    techniques might use alloc_contig_range() to hide previously
+	 *    exposed pages from the buddy again (e.g., to implement some sort
+	 *    of memory unplug in virtio-mem).
+	 *
+	 * In general, no unmovable allocations that degrade memory offlining
+	 * should end up in ZONE_MOVABLE. Allocators (like alloc_contig_range())
+	 * have to expect that migrating pages in ZONE_MOVABLE can fail (even
+	 * if has_unmovable_pages() states that there are no unmovable pages,
+	 * there can be false negatives).
+	 */
 	ZONE_MOVABLE,
 #ifdef CONFIG_ZONE_DEVICE
 	ZONE_DEVICE,
_

Patches currently in -mm which might be from david@redhat.com are

mm-page_alloc-tweak-comments-in-has_unmovable_pages.patch
mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_isolate.patch
mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch
mm-page_isolation-cleanup-set_migratetype_isolate.patch
virtio-mem-dont-special-case-zone_movable.patch
mm-document-semantics-of-zone_movable.patch

