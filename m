Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93AD2C43217
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 806036127C
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbhKEUnh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233431AbhKEUng (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:43:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E905E61262;
        Fri,  5 Nov 2021 20:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144856;
        bh=NOCP50HYKMSoBePJ/HR1LDAyXYJlPTqLctXom3vTXos=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Qqr7byP2j+c7GM/LyIh4imPabe34S8W3py0u1RlTX8IeHjhXhJojV3ZXkfbn88T1R
         nmjx+enlzFMNgNMhs+eeL3k/fYLmCqMmkUOz8qn8tdZ1RiJylJfN9SHUhnqZwhNFzE
         XZ/qZ1KyFn3UbOb7qH8VRGHuKSTBLte+jCAAtU28=
Date:   Fri, 05 Nov 2021 13:40:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bobo.shaobowang@huawei.com,
        david@redhat.com, huawei.libin@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        weiyongjun1@huawei.com
Subject:  [patch 120/262] mm/page_alloc: use clamp() to simplify
 code
Message-ID: <20211105204055.6P3hBKyWJ%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
