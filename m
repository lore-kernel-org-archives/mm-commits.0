Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC540C388F9
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 22:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FF832344C
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 22:50:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="XhGwvIpn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgKPWu3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 17:50:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbgKPWu2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 17:50:28 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 461412244C;
        Mon, 16 Nov 2020 22:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605567026;
        bh=sn+1qgiXN5kYhNoK8jxDCfEmndUY5QtjRk66LHgnuIs=;
        h=Date:From:To:Subject:From;
        b=XhGwvIpngySpbYzX/GUrUODUgIV/R6DndOKLbHw2sGlrxXI/bF702O7RF5RPVyI7Y
         mZ6sg02QX76/2tEysPozifJbiuBQ05a9YDmHRFdeuSxmiucDizhVRn4aGWsd5zX1Fv
         kZ+lYFiWoyOBmw8JaInhT2fT6F6QKYYeI6ImDcxg=
Date:   Mon, 16 Nov 2020 14:50:25 -0800
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, oleksiy.avramchenko@sonymobile.com,
        rostedt@goodmis.org, urezki@gmail.com, willy@infradead.org
Subject:  +
 mm-vmalloc-use-free_vm_area-if-an-allocation-fails.patch added to -mm tree
Message-ID: <20201116225025.oEegtqCic%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: use free_vm_area() if an allocation fails
has been added to the -mm tree.  Its filename is
     mm-vmalloc-use-free_vm_area-if-an-allocation-fails.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-use-free_vm_area-if-an-allocation-fails.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-use-free_vm_area-if-an-allocation-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: use free_vm_area() if an allocation fails

There is a dedicated and separate function that finds and removes a
continuous kernel virtual area.  As a final step it also releases the
"area", a descriptor of corresponding vm_struct.

Use free_vmap_area() in the __vmalloc_node_range() instead of open coded
steps which are exactly the same, to perform a cleanup.

Link: https://lkml.kernel.org/r/20201116220033.1837-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-free_vm_area-if-an-allocation-fails
+++ a/mm/vmalloc.c
@@ -2479,8 +2479,7 @@ static void *__vmalloc_area_node(struct
 	}
 
 	if (!pages) {
-		remove_vm_area(area->addr);
-		kfree(area);
+		free_vm_area(area);
 		return NULL;
 	}
 
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-use-free_vm_area-if-an-allocation-fails.patch
mm-vmalloc-rework-the-drain-logic.patch

