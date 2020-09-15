Return-Path: <SRS0=Dxzc=CY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEFEBC43461
	for <mm-commits@archiver.kernel.org>; Tue, 15 Sep 2020 23:59:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87D4A20720
	for <mm-commits@archiver.kernel.org>; Tue, 15 Sep 2020 23:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600214384;
	bh=ov0uI1BxqTQu2Q870HBMxQOuJqiPZaMHJJEI2UelWV8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Ln2gDebYoYwn+qojCpCXcoliLBCyv8g68du8/IVdsyxKp9H/0NFNAU+QG0l1CaACB
	 OQlseUYTFcM5gqlUfmTxWQcmOGISvadfFG3ADo3WtUNCEzc99/i4NWIpxYMa0UGZ2x
	 rZTVZpyjvt0EOeVFFLJ3V+bOB122P22ov4UZohm4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgIOX7m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Sep 2020 19:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727395AbgIOX6q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Sep 2020 19:58:46 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1CC220720;
        Tue, 15 Sep 2020 23:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600214325;
        bh=ov0uI1BxqTQu2Q870HBMxQOuJqiPZaMHJJEI2UelWV8=;
        h=Date:From:To:Subject:From;
        b=p8PAW70j+IZNFnzS4Beh3vgsPNsBPVYKZh8mazAuTuhASAIc9uoKdDr3Eul8fVP9t
         ieMnY7SSgGvqR320zmTpqwhw//sJjmx9MdWksvw0PYMJm8PSy/5nvledLZeTio4swC
         9QUoQSrLxm0e004fQsQG0Q8onWmoB2aQKqc34aGQ=
Date:   Tue, 15 Sep 2020 16:58:44 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rientjes@google.com,
        penberg@kernel.org, iamjoonsoo.kim@lge.com, cl@linux.com,
        akpm@linux-foundation.org, mateusznosek0@gmail.com
Subject:  +
 mm-slabc-clean-code-by-removing-redundant-if-condition.patch added to -mm
 tree
Message-ID: <20200915235844.EoVj_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: clean code by removing redundant if condition
has been added to the -mm tree.  Its filename is
     mm-slabc-clean-code-by-removing-redundant-if-condition.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slabc-clean-code-by-removing-redundant-if-condition.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slabc-clean-code-by-removing-redundant-if-condition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/slab.c: clean code by removing redundant if condition

The removed code was unnecessary and changed nothing in the flow, since in
case of returning NULL by 'kmem_cache_alloc_node' returning 'freelist'
from the function in question is the same as returning NULL.

Link: https://lkml.kernel.org/r/20200915230329.13002-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/slab.c~mm-slabc-clean-code-by-removing-redundant-if-condition
+++ a/mm/slab.c
@@ -2301,8 +2301,6 @@ static void *alloc_slabmgmt(struct kmem_
 		/* Slab management obj is off-slab. */
 		freelist = kmem_cache_alloc_node(cachep->freelist_cache,
 					      local_flags, nodeid);
-		if (!freelist)
-			return NULL;
 	} else {
 		/* We will use last bytes at the slab for freelist */
 		freelist = addr + (PAGE_SIZE << cachep->gfporder) -
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-slabc-clean-code-by-removing-redundant-if-condition.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization.patch
mm-page_allocc-micro-optimization-remove-unnecessary-branch.patch
mm-compactionc-micro-optimization-remove-unnecessary-branch.patch

