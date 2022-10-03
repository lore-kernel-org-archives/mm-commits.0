Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3126DC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiJCVLj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiJCVJ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:09:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3475005B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77343610A3
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0466C433D7;
        Mon,  3 Oct 2022 21:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831198;
        bh=6LnEK0/J8D6J7ZnrJvf2PjpYeVsl6BAV8R/BPt3pmAA=;
        h=Date:To:From:Subject:From;
        b=U9Cm6nitvpm04m0r4K0YKZtQjqzPNogOjnk1+AUHSFQN9taT6/OSeHvGp9HcO83Le
         rp3uhf4oIvQ3JbP1TBBOkiWFG+7hOw3rh2aUoVIPS+oYOro/Zvri5sqCpmZGaeG3WY
         Y/oIENJo6MnZksWm+4yCFrb+zRRimZ+iSTaOwB9E=
Date:   Mon, 03 Oct 2022 14:06:38 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        osalvador@suse.de, david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memblock-tests-add-new-pageblock-related-macro.patch removed from -mm tree
Message-Id: <20221003210638.D0466C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memblock tests: add new pageblock related macro
has been removed from the -mm tree.  Its filename was
     memblock-tests-add-new-pageblock-related-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: memblock tests: add new pageblock related macro
Date: Wed, 7 Sep 2022 16:26:43 +0800

Add new pageblock_start_pfn() and pageblock_align() macro which are needed
by memblock tests.

Link: https://lkml.kernel.org/r/20220907082643.186979-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/memblock/linux/mmzone.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/memblock/linux/mmzone.h~memblock-tests-add-new-pageblock-related-macro
+++ a/tools/testing/memblock/linux/mmzone.h
@@ -22,6 +22,8 @@ enum zone_type {
 
 #define pageblock_order		(MAX_ORDER - 1)
 #define pageblock_nr_pages	BIT(pageblock_order)
+#define pageblock_align(pfn)	ALIGN((pfn), pageblock_nr_pages)
+#define pageblock_start_pfn(pfn)	ALIGN_DOWN((pfn), pageblock_nr_pages)
 
 struct zone {
 	atomic_long_t		managed_pages;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


