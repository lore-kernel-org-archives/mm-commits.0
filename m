Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEB7C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiJCVPx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiJCVOJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C280B10555
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A03E4B815F8
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40141C433D7;
        Mon,  3 Oct 2022 21:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831377;
        bh=xEPTLV6eBgWHPPKruS2GSjXKJAAJehTM2zU2P3UYULM=;
        h=Date:To:From:Subject:From;
        b=tFP427lgx8cjzMGqukjKSxA7Lde55ZYzq3M4kLvRk2/W4YiIAd46Cqb5quPqIcoCu
         LNhTRzeY9/xPtW/c3em64cjwC3HTvLZ2sl7jkHMGNyy4sWo8uyVeyeonv3v5xG8KyV
         Kj5DQcupJETJoBcrpi+LjJ9uy6q6+hjAcgG2YxNI=
Date:   Mon, 03 Oct 2022 14:09:36 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-remove-obsolete-generic_free_nodedata.patch removed from -mm tree
Message-Id: <20221003210937.40141C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, memory_hotplug: remove obsolete generic_free_nodedata()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-remove-obsolete-generic_free_nodedata.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, memory_hotplug: remove obsolete generic_free_nodedata()
Date: Fri, 16 Sep 2022 15:22:51 +0800

Commit 390511e1476e ("mm, memory_hotplug: drop arch_free_nodedata") drops
the last caller of generic_free_nodedata().  Remove it too.

Link: https://lkml.kernel.org/r/20220916072257.9639-11-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-remove-obsolete-generic_free_nodedata
+++ a/include/linux/memory_hotplug.h
@@ -43,11 +43,6 @@ extern void arch_refresh_nodedata(int ni
 ({								\
 	memblock_alloc(sizeof(*pgdat), SMP_CACHE_BYTES);	\
 })
-/*
- * This definition is just for error path in node hotadd.
- * For node hotremove, we have to replace this.
- */
-#define generic_free_nodedata(pgdat)	kfree(pgdat)
 
 extern pg_data_t *node_data[];
 static inline void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
@@ -63,9 +58,6 @@ static inline pg_data_t *generic_alloc_n
 	BUG();
 	return NULL;
 }
-static inline void generic_free_nodedata(pg_data_t *pgdat)
-{
-}
 static inline void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
 {
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


