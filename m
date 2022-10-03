Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3695DC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiJCVPm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiJCVOF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CC4E16
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 274CCB81122
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D57C433C1;
        Mon,  3 Oct 2022 21:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831373;
        bh=wcc0BsNyknZG5lsR4qrxm5vdFXGBVF90vHSkEwNT+Yk=;
        h=Date:To:From:Subject:From;
        b=IRYKY7XI0iJiSnrU9fUvu2IMGj/WIp8wBBfHZmWME0V5GmqWI9Xxlt0yO+6u4Zv8Y
         0nkoBOBfGQmI+9GMQd7In4LQb7m5r68WVNxw1CNFao2ZY4lgRSgsQ4EfWbIQTrA09A
         O1+anvOLj+xdGAz1LuJegTbKTxu9J+2aWiAK3qv8=
Date:   Mon, 03 Oct 2022 14:09:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-obsolete-pgdat_is_empty.patch removed from -mm tree
Message-Id: <20221003210933.B8D57C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove obsolete pgdat_is_empty()
has been removed from the -mm tree.  Its filename was
     mm-remove-obsolete-pgdat_is_empty.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: remove obsolete pgdat_is_empty()
Date: Fri, 16 Sep 2022 15:22:48 +0800

There's no caller.  Remove it.

Link: https://lkml.kernel.org/r/20220916072257.9639-8-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/mmzone.h~mm-remove-obsolete-pgdat_is_empty
+++ a/include/linux/mmzone.h
@@ -1241,11 +1241,6 @@ static inline unsigned long pgdat_end_pf
 	return pgdat->node_start_pfn + pgdat->node_spanned_pages;
 }
 
-static inline bool pgdat_is_empty(pg_data_t *pgdat)
-{
-	return !pgdat->node_start_pfn && !pgdat->node_spanned_pages;
-}
-
 #include <linux/memory_hotplug.h>
 
 void build_all_zonelists(pg_data_t *pgdat);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


