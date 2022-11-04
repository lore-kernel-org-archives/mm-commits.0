Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89344C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Nov 2022 22:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiKDWCe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Nov 2022 18:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiKDWCd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Nov 2022 18:02:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E2D4877D
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 15:02:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7FCBB82FE8
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 22:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D71DC433D6;
        Fri,  4 Nov 2022 22:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667599348;
        bh=XY3lc+2UO6rApso7MbwyfclF85mfQxDVD94Y/JAgQKQ=;
        h=Date:To:From:Subject:From;
        b=PnS11s/S4rJOadAiNtIZXqjsoO+sjpIWKFPrmGKallEhefekLDz9qWef4GQ9bcmvm
         MR8jwiqk73VOLKwB5kdEs7fg+jLZ2gocXQ7paSsODKmftH5IEB8nSUuBJnhRkzVdK0
         wXAQF+Tia/f5trdjyYDHbc6DrvWBcDIjXjisj+J8=
Date:   Fri, 04 Nov 2022 15:02:27 -0700
To:     mm-commits@vger.kernel.org, pbonzini@redhat.com,
        lukas.bulwahn@gmail.com, joe@perches.com, dwaipayanray1@gmail.com,
        christophe.jaillet@wanadoo.fr, bagasdotme@gmail.com,
        apw@canonical.com, liaochang1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-check-for-array-allocator-family-argument-order.patch added to mm-nonmm-unstable branch
Message-Id: <20221104220228.6D71DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add check for array allocator family argument order
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-check-for-array-allocator-family-argument-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-check-for-array-allocator-family-argument-order.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Liao Chang <liaochang1@huawei.com>
Subject: checkpatch: add check for array allocator family argument order
Date: Fri, 4 Nov 2022 15:05:23 +0800

These array allocator family are sometimes misused with the first and
second arguments switched.

Same issue with calloc, kvcalloc, kvmalloc_array etc.

Bleat if sizeof is the first argument.

Link: https://lore.kernel.org/lkml/5374345c-7973-6a3c-d559-73bf4ac15079@redhat.com/
Link: https://lkml.kernel.org/r/20221104070523.60296-1-liaochang1@huawei.com
Signed-off-by: Liao Chang <liaochang1@huawei.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-add-check-for-array-allocator-family-argument-order
+++ a/scripts/checkpatch.pl
@@ -7146,7 +7146,7 @@ sub process {
 		}
 
 # check for alloc argument mismatch
-		if ($line =~ /\b((?:devm_)?(?:kcalloc|kmalloc_array))\s*\(\s*sizeof\b/) {
+		if ($line =~ /\b((?:devm_)?((?:k|kv)?(calloc|malloc_array)(?:_node)?))\s*\(\s*sizeof\b/) {
 			WARN("ALLOC_ARRAY_ARGS",
 			     "$1 uses number as first arg, sizeof is generally wrong\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from liaochang1@huawei.com are

checkpatch-add-check-for-array-allocator-family-argument-order.patch

