Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 538A9C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiANVWC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiANVWB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:22:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB7EC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 13:22:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7A2461F84
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAC7C36AE9;
        Fri, 14 Jan 2022 21:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642195320;
        bh=LWBTcPeG/iqlgo7dadRbCMwqkdVL+0Rbaauh/daDJWk=;
        h=Date:From:To:Subject:From;
        b=nYMVQGokgV+4p0+VRq7UchI4lDOTh3xev7UR8wPSOBQUY8qc4d3vwO56pN6XpeB+r
         Ck+5llonDig5rcdn+yWGtvMfnenWYJn8BPRFjarlxTqseL8Cd2Cjw/aFE19S6bHccZ
         5Eb2QERpIpEfUlFIitz7NPM/w1LCR3ZRVmMd/RQA=
Date:   Fri, 14 Jan 2022 13:21:59 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        wangkefeng.wang@huawei.com
Subject:  [folded-merged]
 mm-defer-kmemleak-object-creation-of-module_alloc-v4.patch removed from -mm
 tree
Message-ID: <20220114212159.wAckJoLlA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-defer-kmemleak-object-creation-of-module_alloc-v4
has been removed from the -mm tree.  Its filename was
     mm-defer-kmemleak-object-creation-of-module_alloc-v4.patch

This patch was dropped because it was folded into mm-defer-kmemleak-object-creation-of-module_alloc.patch

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm-defer-kmemleak-object-creation-of-module_alloc-v4

fix build

Link: https://lkml.kernel.org/r/20211125080307.27225-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/shadow.c~mm-defer-kmemleak-object-creation-of-module_alloc-v4
+++ a/mm/kasan/shadow.c
@@ -525,7 +525,7 @@ int kasan_module_alloc(void *addr, size_
 		vm->flags |= VM_KASAN;
 		kmemleak_ignore(ret);
 
-		if (vm->flags & VM_DELAY_KMEMLEAK)
+		if (vm->flags & VM_DEFER_KMEMLEAK)
 			kmemleak_vmalloc(vm, size, gfp_mask);
 
 		return 0;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-defer-kmemleak-object-creation-of-module_alloc.patch
mm-percpu-generalize-percpu-related-config.patch
mm-percpu-add-pcpu_fc_cpu_to_node_fn_t-typedef.patch
mm-percpu-add-generic-pcpu_fc_alloc-free-funciton.patch
mm-percpu-add-generic-pcpu_populate_pte-function.patch

