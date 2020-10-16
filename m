Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5553DC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAECE20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602814676;
	bh=ePFGs9TtQDjLuoibrJnb+rP5x+Ni6Q3BjvCTqK2k8mE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=oikzOngW3t6em8r/Y2AB2NN5m0UCLI3D8v9DqJf6Bs7m/PnrW/J0cZ3IeGfYIsPO/
	 OcCbX8iDSaeH9PbTJiBpnYBZpECLE3riGKi73DPQE16gdGocX7mTK4Mhvk7bmSo19a
	 AU+62Lc3gJMkTLo1dmc/tMZjb9HBYbrYIAl0gLcw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393645AbgJPCRz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:17:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393644AbgJPCRz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:17:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96D4020878;
        Fri, 16 Oct 2020 02:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602814674;
        bh=ePFGs9TtQDjLuoibrJnb+rP5x+Ni6Q3BjvCTqK2k8mE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=D1SCYMtHdOjbF5UUhEqSzBpOxEJy7g1ERXvxyq3fT1MHif284wz/4DkBnLa8Feo2L
         XvNFQQIlse6sZ9Fxx0EJiZoQNh0JpXFsnxka2Ge11N7P65gD9+2KDyEOfrLKuzzkQz
         jJIuSLHOduZFS+TkpgP/9RMToXhilqT63csUDyjE=
Date:   Thu, 15 Oct 2020 19:17:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     david@redhat.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com
Subject:  [folded-merged]
 kernel-resource-make-release_mem_region_adjustable-never-fail-fix.patch
 removed from -mm tree
Message-ID: <20201016021754.-80eNNkif%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource: fix use of ternary condition in release_mem_region_adjustable
has been removed from the -mm tree.  Its filename was
     kernel-resource-make-release_mem_region_adjustable-never-fail-fix.patch

This patch was dropped because it was folded into kernel-resource-make-release_mem_region_adjustable-never-fail.patch

------------------------------------------------------
From: Nathan Chancellor <natechancellor@gmail.com>
Subject: kernel/resource: fix use of ternary condition in release_mem_region_adjustable

Clang warns:

kernel/resource.c:1281:53: warning: operator '?:' has lower precedence
than '|'; '|' will be evaluated first
[-Wbitwise-conditional-parentheses]
        new_res = alloc_resource(GFP_KERNEL | alloc_nofail ? __GFP_NOFAIL : 0);
                                 ~~~~~~~~~~~~~~~~~~~~~~~~~ ^
kernel/resource.c:1281:53: note: place parentheses around the '|'
expression to silence this warning
        new_res = alloc_resource(GFP_KERNEL | alloc_nofail ? __GFP_NOFAIL : 0);
                                 ~~~~~~~~~~~~~~~~~~~~~~~~~ ^
kernel/resource.c:1281:53: note: place parentheses around the '?:'
expression to evaluate it first
        new_res = alloc_resource(GFP_KERNEL | alloc_nofail ? __GFP_NOFAIL : 0);
                                                           ^
                                              (                              )
1 warning generated.

Add the parentheses as it was clearly intended for the ternary condition
to be evaluated first.

Link: https://lkml.kernel.org/r/20200922060748.2452056-1-natechancellor@gmail.com
Fixes: 5fd23bd0d739 ("kernel/resource: make release_mem_region_adjustable() never fail")
Link: https://github.com/ClangBuiltLinux/linux/issues/1159
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/resource.c~kernel-resource-make-release_mem_region_adjustable-never-fail-fix
+++ a/kernel/resource.c
@@ -1279,7 +1279,7 @@ void release_mem_region_adjustable(struc
 	 * similarly).
 	 */
 retry:
-	new_res = alloc_resource(GFP_KERNEL | alloc_nofail ? __GFP_NOFAIL : 0);
+	new_res = alloc_resource(GFP_KERNEL | (alloc_nofail ? __GFP_NOFAIL : 0));
 
 	p = &parent->child;
 	write_lock(&resource_lock);
_

Patches currently in -mm which might be from natechancellor@gmail.com are

kernel-resource-make-release_mem_region_adjustable-never-fail.patch

