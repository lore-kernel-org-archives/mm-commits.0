Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A088C433E9
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 21:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15A6B2333F
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 21:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbhAFVtz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Jan 2021 16:49:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726624AbhAFVtz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Jan 2021 16:49:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F037D23329;
        Wed,  6 Jan 2021 21:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609969754;
        bh=tiAxrMbOriM8xRyFosqAUMdN2dDPPLNFfUdkFzg3V24=;
        h=Date:From:To:Subject:From;
        b=aec7zzml89V6sVnyTud2LOZjD1ZJScvKMOPYZnzC5g1XX0IdCN3h7dyaUvJnn8dAz
         M7/zLoGYq0ncT9Czm9YX2k4cvb3sbJpcH3M3Zwbok9q22stFXjKq2JuVQV/fPiF5to
         mCvDVrdJH+3vAKkSx1M3G7oPiVLbLx1PNYx4Bzo4=
Date:   Wed, 06 Jan 2021 13:49:13 -0800
From:   akpm@linux-foundation.org
To:     andrii@kernel.org, axboe@kernel.dk, cl@linux.com,
        iamjoonsoo.kim@lge.com, ming.lei@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  +
 mm-make-mem_obj_dump-vmalloc-dumps-include-start-and-length.patch added to
 -mm tree
Message-ID: <20210106214913.0YW_Q03eJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make mem_obj_dump() vmalloc() dumps include start and length
has been added to the -mm tree.  Its filename is
     mm-make-mem_obj_dump-vmalloc-dumps-include-start-and-length.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-make-mem_obj_dump-vmalloc-dumps-include-start-and-length.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-make-mem_obj_dump-vmalloc-dumps-include-start-and-length.patch

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

mm-add-mem_dump_obj-to-print-source-of-memory-block.patch
mm-make-mem_dump_obj-handle-null-and-zero-sized-pointers.patch
mm-make-mem_dump_obj-handle-vmalloc-memory.patch
mm-make-mem_obj_dump-vmalloc-dumps-include-start-and-length.patch
rcu-make-call_rcu-print-mem_dump_obj-info-for-double-freed-callback.patch
percpu_ref-dump-mem_dump_obj-info-upon-reference-count-underflow.patch

