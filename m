Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263ABC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F82E6113B
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbhKKCrQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:47:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234310AbhKKCrQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:47:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76B2760F46;
        Thu, 11 Nov 2021 02:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598667;
        bh=x0CAdLIHk2kwgqxMjV0W7ayXSuAvO46cRfg/9/rXTAA=;
        h=Date:From:To:Subject:From;
        b=o+jWgXdRCM3iStBmF+Np0ucUU/UIjIcJOkMnuCFNQNZ3WgRHdNQ/pt0MEyjc7CMGp
         6gstZXxMc2eInVXWV1+CzQc3Q4jt7kZGFgVPMLKZny126xu6cJzTTC7L4+UWbzFlZ1
         KHAJaO5g8x3t95uZDr/YU6/D9q+6bJyEdvz+p0bk=
Date:   Wed, 10 Nov 2021 18:44:27 -0800
From:   akpm@linux-foundation.org
To:     bobo.shaobowang@huawei.com, david@redhat.com,
        huawei.libin@huawei.com, mm-commits@vger.kernel.org,
        weiyongjun1@huawei.com
Subject:  [merged] mm-page_alloc-use-clamp-to-simplify-code.patch
 removed from -mm tree
Message-ID: <20211111024427.E82KV5uCI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: use clamp() to simplify code
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-clamp-to-simplify-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang ShaoBo <bobo.shaobowang@huawei.com>
Subject: mm/page_alloc: use clamp() to simplify code

This patch uses clamp() to simplify code in init_per_zone_wmark_min().

Link: https://lkml.kernel.org/r/20211021034830.1049150-1-bobo.shaobowang@huawei.com
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Li Bin <huawei.libin@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-clamp-to-simplify-code
+++ a/mm/page_alloc.c
@@ -8477,16 +8477,12 @@ int __meminit init_per_zone_wmark_min(vo
 	lowmem_kbytes = nr_free_buffer_pages() * (PAGE_SIZE >> 10);
 	new_min_free_kbytes = int_sqrt(lowmem_kbytes * 16);
 
-	if (new_min_free_kbytes > user_min_free_kbytes) {
-		min_free_kbytes = new_min_free_kbytes;
-		if (min_free_kbytes < 128)
-			min_free_kbytes = 128;
-		if (min_free_kbytes > 262144)
-			min_free_kbytes = 262144;
-	} else {
+	if (new_min_free_kbytes > user_min_free_kbytes)
+		min_free_kbytes = clamp(new_min_free_kbytes, 128, 262144);
+	else
 		pr_warn("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
 				new_min_free_kbytes, user_min_free_kbytes);
-	}
+
 	setup_per_zone_wmarks();
 	refresh_zone_stat_thresholds();
 	setup_per_zone_lowmem_reserve();
_

Patches currently in -mm which might be from bobo.shaobowang@huawei.com are


