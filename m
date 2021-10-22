Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 297A4C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 03:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CAE461A2E
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 03:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbhJVDtF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Oct 2021 23:49:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232930AbhJVDtE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Oct 2021 23:49:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B286761A0C;
        Fri, 22 Oct 2021 03:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634874407;
        bh=tjnVe1rV4f3/8u1pj6xULPkX2AxiXqC2IKho5GfEG/k=;
        h=Date:From:To:Subject:From;
        b=auAYne0FAJ15n6Y1sf8mmuYwQBpR2HVCk1o/vF1eo/Nc1hrpgv2hHpGm+OoIPSX3w
         A250EWbGs86LqWKWoJUc9M9Pm5nglYBpSWt7PWZDJaegpzWB7QFxyBEncoqFiuR6Ae
         vkpUWM1MqLsXUmgDS9gEh3ywGgXEIytmZybXc/SA=
Date:   Thu, 21 Oct 2021 20:46:47 -0700
From:   akpm@linux-foundation.org
To:     bobo.shaobowang@huawei.com, david@redhat.com,
        huawei.libin@huawei.com, mm-commits@vger.kernel.org,
        weiyongjun1@huawei.com
Subject:  + mm-page_alloc-use-clamp-to-simplify-code.patch added to
 -mm tree
Message-ID: <20211022034647.lQffyXjxA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: use clamp() to simplify code
has been added to the -mm tree.  Its filename is
     mm-page_alloc-use-clamp-to-simplify-code.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-use-clamp-to-simplify-code.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-use-clamp-to-simplify-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_alloc-use-clamp-to-simplify-code.patch

