Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 362ACC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6D832222F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633338;
	bh=Q94IJZFH4v9ilxriS46pAfHHxIoz4laDZB77Dn4xDNo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=c8V9vuuxbylZQPwT9nkj9cmG1X2xZsskGg93FvMJCCZTNFOto2HSwzibwa88YtEdW
	 vvlCqXnmJypP5lUhkxen8Rfbcdw34bPEpHQ13skZITOJYuFgK1ETGt0rD9SPU1DOof
	 wEBy2u1z6biLJFDStFBliH5BjJ5WNNQ+0Mmj+eQQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388480AbgJMXzh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMXzh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:55:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03DF622202;
        Tue, 13 Oct 2020 23:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633336;
        bh=Q94IJZFH4v9ilxriS46pAfHHxIoz4laDZB77Dn4xDNo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CMP9ERJL2j7dbd29auYNOtSbdii3fbCMUKbc44phNv0bZhuTXZE0wWVX7DQab2Vbv
         JirlX/Z+yeheN+Hyqxbuiv+3MPP+kSO94X+HS+m4KrwaSvYhQQouI9a00rAAGdYH57
         7z2fHT8i+JN0jy5YazudYyE2t7t5nj+mIdeN4DcA=
Date:   Tue, 13 Oct 2020 16:55:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, cai@lca.pw,
        david@redhat.com, jasowang@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mst@redhat.com,
        pankaj.gupta.linux@gmail.com, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 130/181] mm: document semantics of ZONE_MOVABLE
Message-ID: <20201013235535.f2U9783nk%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
