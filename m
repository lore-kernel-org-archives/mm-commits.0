Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4194BEE49AA
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjHUUlw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbjHUUko (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7973CD6
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 871076156C
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00BFC433C7;
        Mon, 21 Aug 2023 20:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650432;
        bh=ui2G7Z0yzSbVHQKV4d2xfFnTWONQus616EBI6j5bN8A=;
        h=Date:To:From:Subject:From;
        b=DgzwIPrfqVv+vM8WoFlj2MYKvXvg2+81V6j/zOGIXA+/O12ECSUIau+Kr+/aZhCH+
         Q8T0e66woNYUypF9uhDLRXS7TCHbvxH7RkoKe3sCeB7gJcQ1f7WkQPsHq/RYz7kphh
         t/dnQsFeYyqzfOzmYoYBuh7H4CfRGxPDdG0fWg9I=
Date:   Mon, 21 Aug 2023 13:40:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        david@redhat.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmapc-use-helper-macro-k.patch removed from -mm tree
Message-Id: <20230821204031.E00BFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap.c: use helper macro K()
has been removed from the -mm tree.  Its filename was
     mm-mmapc-use-helper-macro-k.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/mmap.c: use helper macro K()
Date: Fri, 4 Aug 2023 09:25:58 +0800

Use helper macro K() to improve code readability.  No functional
modification involved.

Link: https://lkml.kernel.org/r/20230804012559.2617515-7-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mmap.c~mm-mmapc-use-helper-macro-k
+++ a/mm/mmap.c
@@ -3785,7 +3785,7 @@ static int init_user_reserve(void)
 {
 	unsigned long free_kbytes;
 
-	free_kbytes = global_zone_page_state(NR_FREE_PAGES) << (PAGE_SHIFT - 10);
+	free_kbytes = K(global_zone_page_state(NR_FREE_PAGES));
 
 	sysctl_user_reserve_kbytes = min(free_kbytes / 32, 1UL << 17);
 	return 0;
@@ -3806,7 +3806,7 @@ static int init_admin_reserve(void)
 {
 	unsigned long free_kbytes;
 
-	free_kbytes = global_zone_page_state(NR_FREE_PAGES) << (PAGE_SHIFT - 10);
+	free_kbytes = K(global_zone_page_state(NR_FREE_PAGES));
 
 	sysctl_admin_reserve_kbytes = min(free_kbytes / 32, 1UL << 13);
 	return 0;
@@ -3850,7 +3850,7 @@ static int reserve_mem_notifier(struct n
 
 		break;
 	case MEM_OFFLINE:
-		free_kbytes = global_zone_page_state(NR_FREE_PAGES) << (PAGE_SHIFT - 10);
+		free_kbytes = K(global_zone_page_state(NR_FREE_PAGES));
 
 		if (sysctl_user_reserve_kbytes > free_kbytes) {
 			init_user_reserve();
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are


