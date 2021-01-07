Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF15C43381
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 22:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30FB22371F
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 22:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbhAGWdY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jan 2021 17:33:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:43322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbhAGWdY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Jan 2021 17:33:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BFF623602;
        Thu,  7 Jan 2021 22:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610058763;
        bh=vn/TadTMGKHpeNnFTewanSp6kOaBrjd7vemBMDLm86g=;
        h=Date:From:To:Subject:From;
        b=MxfL8sOtPQqWsACm2gN6GAVLVqBhH1eGNcMRtIncQz1mslHnB4mEsI+qu6xfQWGZD
         GBHf5xBJX+UWG8n1YM6A6znBzXWsffc1Iqsp1ySgGxU3faHMP/kzyD8Ryv/lULUIk7
         SxZvy9QaJH50P0gZ2bxsRvMC7fU+Fw3zOWkTWJ/Y=
Date:   Thu, 07 Jan 2021 14:32:43 -0800
From:   akpm@linux-foundation.org
To:     andrii@kernel.org, axboe@kernel.dk, cl@linux.com,
        iamjoonsoo.kim@lge.com, ming.lei@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  [merged]
 mm-make-mem_obj_dump-vmalloc-dumps-include-start-and-length.patch removed
 from -mm tree
Message-ID: <20210107223243._0vTwc0tN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make mem_obj_dump() vmalloc() dumps include start and length
has been removed from the -mm tree.  Its filename was
     mm-make-mem_obj_dump-vmalloc-dumps-include-start-and-length.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Paul E. McKenney" <paulmck@kernel.org>
Subject: mm: make mem_obj_dump() vmalloc() dumps include start and length

This commit adds the starting address and number of pages to the vmalloc()
information dumped by way of vmalloc_dump_obj().

Link: https://lkml.kernel.org/r/20210106011750.13709-4-paulmck@kernel.org
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-make-mem_obj_dump-vmalloc-dumps-include-start-and-length
+++ a/mm/vmalloc.c
@@ -3456,7 +3456,8 @@ bool vmalloc_dump_obj(void *object)
 	vm = find_vm_area(objp);
 	if (!vm)
 		return false;
-	pr_cont(" vmalloc allocated at %pS\n", vm->caller);
+	pr_cont(" %u-page vmalloc region starting at %#lx allocated at %pS\n",
+		vm->nr_pages, (unsigned long)vm->addr, vm->caller);
 	return true;
 }
 
_

Patches currently in -mm which might be from paulmck@kernel.org are


