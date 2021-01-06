Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C05C433E6
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 21:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C110C2333D
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 21:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbhAFVts (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Jan 2021 16:49:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726624AbhAFVts (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Jan 2021 16:49:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0267B23158;
        Wed,  6 Jan 2021 21:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609969747;
        bh=LReWyWsnAPmgYunWrVggTu4IrmPOYhnx0zoKetFL7i4=;
        h=Date:From:To:Subject:From;
        b=f7kIy2ZDNUVMsoV1nrjGW+pvEWwppf1P9qCsc3lhXhrVW1Tp7DmRjZLFWv5mEDxJt
         A1AYvTK4drEfHXeYv3TneHWfGooR4crmI7GdYdTYzBtfUMPaEsByfhSpLNe1pd1e6c
         O7etd+1db9ujR1pTK3mQJyaZD1v1TfFjemttbEWw=
Date:   Wed, 06 Jan 2021 13:49:06 -0800
From:   akpm@linux-foundation.org
To:     andrii@kernel.org, axboe@kernel.dk, cl@linux.com,
        iamjoonsoo.kim@lge.com, ming.lei@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  +
 mm-make-mem_dump_obj-handle-null-and-zero-sized-pointers.patch added to -mm
 tree
Message-ID: <20210106214906.S0VDFylZi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make mem_dump_obj() handle NULL and zero-sized pointers
has been added to the -mm tree.  Its filename is
     mm-make-mem_dump_obj-handle-null-and-zero-sized-pointers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-make-mem_dump_obj-handle-null-and-zero-sized-pointers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-make-mem_dump_obj-handle-null-and-zero-sized-pointers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-add-mem_dump_obj-to-print-source-of-memory-block.patch
mm-make-mem_dump_obj-handle-null-and-zero-sized-pointers.patch
mm-make-mem_dump_obj-handle-vmalloc-memory.patch
mm-make-mem_obj_dump-vmalloc-dumps-include-start-and-length.patch
rcu-make-call_rcu-print-mem_dump_obj-info-for-double-freed-callback.patch
percpu_ref-dump-mem_dump_obj-info-upon-reference-count-underflow.patch

