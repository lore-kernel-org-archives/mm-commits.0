Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65104C352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiLAARW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiLAARB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:17:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB0D98953
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:13:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7171B81D8F
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75460C433D6;
        Thu,  1 Dec 2022 00:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669853632;
        bh=1COrwVu88EMvky2fmSFrpbavgRmRxQOzUolrMzK+otA=;
        h=Date:To:From:Subject:From;
        b=HBkRKMRlx5EFn3IyysN3jkTnM94+84HrGOxtIKUaX71fZVnYlRtZuYFw5AdGz3ScO
         vUIDXekYO5QLO36FPVD+l7DdyEyNIMZsbAlcvmZsbDfimrhkWd2ogk+Ddzzr3whKb+
         skGbYTss6NX9k/E6nMEQS29fANAv8whocRf4YHNs=
Date:   Wed, 30 Nov 2022 16:13:51 -0800
To:     mm-commits@vger.kernel.org, pbonzini@redhat.com,
        lukas.bulwahn@gmail.com, joe@perches.com, dwaipayanray1@gmail.com,
        christophe.jaillet@wanadoo.fr, bagasdotme@gmail.com,
        apw@canonical.com, liaochang1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-add-check-for-array-allocator-family-argument-order.patch removed from -mm tree
Message-Id: <20221201001352.75460C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: add check for array allocator family argument order
has been removed from the -mm tree.  Its filename was
     checkpatch-add-check-for-array-allocator-family-argument-order.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


