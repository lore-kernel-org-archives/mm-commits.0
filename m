Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F89C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8017C22258
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708979;
	bh=V63obN3uFT2Z4v1XgB84juz6XbhyxeaNSekHeOV6T9A=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=o009JN4J/ezQOfxDsisUJfc3QvQcMj4l6BqER998kq5VUECFm8ioCyxndm7bGxGNE
	 m7SmA4ebqTI4Su7OTNzAFrtk8/ZvHlvI9pBn54dDoQA8Ibv9lCYQwz0zjVGjCNqa7s
	 Poi2otczhJnrb10T5rFHcxfpejw2GiZUM/OHAeOM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388537AbgJNU4T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgJNU4T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:56:19 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B472A22254;
        Wed, 14 Oct 2020 20:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708977;
        bh=V63obN3uFT2Z4v1XgB84juz6XbhyxeaNSekHeOV6T9A=;
        h=Date:From:To:Subject:From;
        b=eDHyc21KxeV6H2zS0RkBi7cVlh0Yr+ZQJDig2heQyNL28Fe577FIdKiU4W82Vv8TW
         tRo8Xl/si/5sgDskeHJNBbPV8/awb40yPxrUSzzQxztozP2P5YcrkLwkmnBuT9mALF
         zMqsi5v85wCDbBXuSOP9LDN3UVvrDQtEnEVFUFDY=
Date:   Wed, 14 Oct 2020 13:56:16 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        mateusznosek0@gmail.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com
Subject:  [merged]
 mm-slabc-clean-code-by-removing-redundant-if-condition.patch removed from
 -mm tree
Message-ID: <20201014205616.O_FpZiLm7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: clean code by removing redundant if condition
has been removed from the -mm tree.  Its filename was
     mm-slabc-clean-code-by-removing-redundant-if-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2305,8 +2305,6 @@ static void *alloc_slabmgmt(struct kmem_
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

mm-page_poisonc-replace-bool-variable-with-static-key.patch

