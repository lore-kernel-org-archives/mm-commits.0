Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32AC6C433E6
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 22:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECA7F23603
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 22:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbhAGWdS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jan 2021 17:33:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbhAGWdS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Jan 2021 17:33:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B63D235FF;
        Thu,  7 Jan 2021 22:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610058757;
        bh=YR7XwTibHbwq5pu78kpAHF3FQdsemYzQGgCRC7Vzz1I=;
        h=Date:From:To:Subject:From;
        b=j4rRYZ7mnDAAddA153YFzHnJeGUiWrLLrQKCHz9wsRupQw7TWPsHO6wW9e2V9/lFS
         pkHlZxgLN/64naah8yHdxuJO3WH4lYkYomgZEWK5UqQ7EaEqTHguV/S598Pj9GdAnG
         PPysdmICi5Y2K8y2OeoI43zcxn5F7fsUU0JLL5gY=
Date:   Thu, 07 Jan 2021 14:32:37 -0800
From:   akpm@linux-foundation.org
To:     andrii@kernel.org, axboe@kernel.dk, cl@linux.com,
        iamjoonsoo.kim@lge.com, ming.lei@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  [merged]
 mm-make-mem_dump_obj-handle-null-and-zero-sized-pointers.patch removed from
 -mm tree
Message-ID: <20210107223237.oCfzxf9_x%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make mem_dump_obj() handle NULL and zero-sized pointers
has been removed from the -mm tree.  Its filename was
     mm-make-mem_dump_obj-handle-null-and-zero-sized-pointers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Paul E. McKenney" <paulmck@kernel.org>
Subject: mm: make mem_dump_obj() handle NULL and zero-sized pointers

This commit makes mem_dump_obj() call out NULL and zero-sized pointers
specially instead of classifying them as non-paged memory.

Link: https://lkml.kernel.org/r/20210106011750.13709-2-paulmck@kernel.org
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/util.c~mm-make-mem_dump_obj-handle-null-and-zero-sized-pointers
+++ a/mm/util.c
@@ -997,7 +997,12 @@ int __weak memcmp_pages(struct page *pag
 void mem_dump_obj(void *object)
 {
 	if (!virt_addr_valid(object)) {
-		pr_cont(" non-paged (local) memory.\n");
+		if (object == NULL)
+			pr_cont(" NULL pointer.\n");
+		else if (object == ZERO_SIZE_PTR)
+			pr_cont(" zero-size pointer.\n");
+		else
+			pr_cont(" non-paged (local) memory.\n");
 		return;
 	}
 	if (kmem_valid_obj(object)) {
_

Patches currently in -mm which might be from paulmck@kernel.org are


