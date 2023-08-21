Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B5FEE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjHUUlv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjHUUko (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55336CD5
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F64661927
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73A4C433C7;
        Mon, 21 Aug 2023 20:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650430;
        bh=aXEaP/j+Uaz2zWSF5DGNI5R9v5CiO+C4vOD4tFUc50o=;
        h=Date:To:From:Subject:From;
        b=G5M2u000HjZYc79I3TL2NyDlAKqwA1fJii5hz+FDB0QFJXkZPz4pS5OBx9ZYpr718
         7md2xQVi7j02/Qec0kxJ43ePmN4RUx71OHCZvXEVP7XusI0AQ1bd+KVhC+hHHT8hR+
         w101+2isA0ayOIEOsYqgQnycAUGyk+iLFnpfbHBs=
Date:   Mon, 21 Aug 2023 13:40:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        david@redhat.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-nommuc-use-helper-macro-k.patch removed from -mm tree
Message-Id: <20230821204030.D73A4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/nommu.c: use helper macro K()
has been removed from the -mm tree.  Its filename was
     mm-nommuc-use-helper-macro-k.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/nommu.c: use helper macro K()
Date: Fri, 4 Aug 2023 09:25:57 +0800

Use helper macro K() to improve code readability.  No functional
modification involved.

Link: https://lkml.kernel.org/r/20230804012559.2617515-6-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/nommu.c~mm-nommuc-use-helper-macro-k
+++ a/mm/nommu.c
@@ -1800,7 +1800,7 @@ static int __meminit init_user_reserve(v
 {
 	unsigned long free_kbytes;
 
-	free_kbytes = global_zone_page_state(NR_FREE_PAGES) << (PAGE_SHIFT - 10);
+	free_kbytes = K(global_zone_page_state(NR_FREE_PAGES));
 
 	sysctl_user_reserve_kbytes = min(free_kbytes / 32, 1UL << 17);
 	return 0;
@@ -1821,7 +1821,7 @@ static int __meminit init_admin_reserve(
 {
 	unsigned long free_kbytes;
 
-	free_kbytes = global_zone_page_state(NR_FREE_PAGES) << (PAGE_SHIFT - 10);
+	free_kbytes = K(global_zone_page_state(NR_FREE_PAGES));
 
 	sysctl_admin_reserve_kbytes = min(free_kbytes / 32, 1UL << 13);
 	return 0;
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are


