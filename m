Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE56C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 27 Nov 2021 23:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhK0Xi3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 18:38:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50292 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhK0Xg3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 18:36:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F7D660F14
        for <mm-commits@vger.kernel.org>; Sat, 27 Nov 2021 23:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6698C53FBF;
        Sat, 27 Nov 2021 23:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638055993;
        bh=UXVVuN5Cqd+geOmLU+RE1nN6Z7Z37rhzpLLzPQHy1T8=;
        h=Date:From:To:Subject:From;
        b=w5bdKVFXK3f/JVgszQkum5ZsMLRrxMw1wwz4hWk88j6P7pu14EC34nL+/mt4Rkbwi
         7Ll7sJMcuVDNgqQbvjcvXvpY4ERL3siIAIEi5kxH/1jLixuAQulOxXwr4LTNfX6M4A
         zn2y7lWP925vcKZcPgLROE3XwS9PhhvCS8ENSCd4=
Date:   Sat, 27 Nov 2021 15:33:12 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        wangkefeng.wang@huawei.com
Subject:  +
 mm-defer-kmemleak-object-creation-of-module_alloc-v4.patch added to -mm
 tree
Message-ID: <20211127233312.gUSjZ_jdi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-defer-kmemleak-object-creation-of-module_alloc-v4
has been added to the -mm tree.  Its filename is
     mm-defer-kmemleak-object-creation-of-module_alloc-v4.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-defer-kmemleak-object-creation-of-module_alloc-v4.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-defer-kmemleak-object-creation-of-module_alloc-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-defer-kmemleak-object-creation-of-module_alloc-v4.patch

