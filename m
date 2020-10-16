Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA13C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 870922087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816478;
	bh=R/4qK7OgQGTwMDXSWMZXGu1RfTUCKdTTjel/My56i8w=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=KdYQAx8XRC5Kkj4EK2PbEnR6zNawm6DHjmwYXi1GUQ2nkTqwcthz+ysWNrD1Mhkl+
	 SxUWhWIkZ2mzwBpextqwioRNpRAKD/f2TvC0HZ8jv8xUBVOrFeaVMK+wihzAM/4yLM
	 PtKY9PHVj25oNSyen3OVZ43iLsHoOivIsZi2B1+I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404356AbgJPCr6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:47:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404351AbgJPCr5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:47:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B2F7208C7;
        Fri, 16 Oct 2020 02:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816477;
        bh=R/4qK7OgQGTwMDXSWMZXGu1RfTUCKdTTjel/My56i8w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ADWVlGRoElTlxBE4Ro1LWo4olanwv1OC9Rk+AbNGrrGVf6KOykorbZvkI2See++HQ
         ReUyc6IZqwInYC3xqYSTfacW3Tc4+OqZc3rrKiYEvdz+LKogcsCnfSenNpnmCRkLLa
         0wN96Gc2ROLaK0gxStvTAAtAUZbnzyTQLYteMuak=
Date:   Thu, 15 Oct 2020 19:47:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 108/156] lib: radix-tree: delete duplicated words
Message-ID: <20201016024756.jY22bOrtK%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: radix-tree: delete duplicated words

Drop the repeated word "be".

Link: https://lkml.kernel.org/r/20200823040508.26086-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/radix-tree.c~lib-radix-tree-delete-duplicated-words
+++ a/lib/radix-tree.c
@@ -325,7 +325,7 @@ static __must_check int __radix_tree_pre
 	int ret = -ENOMEM;
 
 	/*
-	 * Nodes preloaded by one cgroup can be be used by another cgroup, so
+	 * Nodes preloaded by one cgroup can be used by another cgroup, so
 	 * they should never be accounted to any particular memory cgroup.
 	 */
 	gfp_mask &= ~__GFP_ACCOUNT;
_
