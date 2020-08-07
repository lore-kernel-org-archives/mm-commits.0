Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 874D4C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DFDB221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781216;
	bh=tFm7AY9ZlSHtPVwC4YNYViMLjySw34F+CPflENjU16c=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=LtzyIvQbDnweY9dw3u5z5RCbuewiaKgs3AyxYDRunp+0OzLPMtpXqgjSJzNqS7U4K
	 mtnX0p7BbTZE2cty1stCfXflShdYuNyBrIexQTG3zyFK7wiV/33rSDoz32i2nNeU/L
	 SOqjnjiBL3kbMZEQS3KyeHxo8F3V9aGDnp1jXhQs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgHGGUP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGUP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:20:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B90A22C9F;
        Fri,  7 Aug 2020 06:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781215;
        bh=tFm7AY9ZlSHtPVwC4YNYViMLjySw34F+CPflENjU16c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uGvyHdZT1T6NHISEE+Dyw1PBdVqBCEr9lQ0rdPDxzJWvYYisT7D15dSE6KXHac6MF
         f/KWsxVCNfDwPhz45DPUC6DrpSl2yVxkpDt4SvdyyXNS1Go/G+UQSy4Y5zxlxyWgC9
         +Z+PTqMCAplx3d/OJKIv29bQ6s7HDECW7yvCxKGA=
Date:   Thu, 06 Aug 2020 23:20:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, krzk@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 057/163] mm: swap: fix kerneldoc of
 swap_vma_readahead()
Message-ID: <20200807062014.N_3885n7O%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: mm: swap: fix kerneldoc of swap_vma_readahead()

Fix W=1 compile warnings (invalid kerneldoc):

    mm/swap_state.c:742: warning: Function parameter or member 'fentry' not described in 'swap_vma_readahead'
    mm/swap_state.c:742: warning: Excess function parameter 'entry' description in 'swap_vma_readahead'

Link: http://lkml.kernel.org/r/20200728171109.28687-2-krzk@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap_state.c~mm-swap-fix-kerneldoc-of-swap_vma_readahead
+++ a/mm/swap_state.c
@@ -725,7 +725,7 @@ static void swap_ra_info(struct vm_fault
 
 /**
  * swap_vma_readahead - swap in pages in hope we need them soon
- * @entry: swap entry of this memory
+ * @fentry: swap entry of this memory
  * @gfp_mask: memory allocation flags
  * @vmf: fault information
  *
_
