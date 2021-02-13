Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8503C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6175C64E8D
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBMEl0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Feb 2021 23:41:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229650AbhBMElZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Feb 2021 23:41:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A0BF64E8D;
        Sat, 13 Feb 2021 04:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613191245;
        bh=tFbx/2b8q6MAuR+wvrZ7FQSBjl6ZuJrhL7kFi728uh8=;
        h=Date:From:To:Subject:From;
        b=P4Z3DZdvwzLJmsNDj2JnGWRvPRAZPjT5mwxpkyiuZmx2lM3Stne2PZJg0uhAk+J4y
         ETNCPt1IreG4wOuoZZ97FhSwhS1BTirOPSo7AZylVy0LfJ9MTYiBTnTH+iSccmK8S0
         qZdFcy2pD7MiFBh7111p4R+RfW/lYuZzgJ+rcgnE=
Date:   Fri, 12 Feb 2021 20:40:44 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, lkp@intel.com, bot@kernelci.org,
        natechancellor@gmail.com
Subject:  [folded-merged]
 mm-zswap-add-the-flag-can_sleep_mapped-fix.patch removed from -mm tree
Message-ID: <20210213044044.ABk6U%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: add return value in zswap_frontswap_load
has been removed from the -mm tree.  Its filename was
     mm-zswap-add-the-flag-can_sleep_mapped-fix.patch

This patch was dropped because it was folded into mm-zswap-add-the-flag-can_sleep_mapped.patch

------------------------------------------------------
From: Nathan Chancellor <natechancellor@gmail.com>
Subject: mm/zswap: add return value in zswap_frontswap_load

Clang warns:

mm/zswap.c:1271:6: warning: variable 'ret' is used uninitialized
whenever 'if' condition is true [-Wsometimes-uninitialized]
        if (!entry->length) {
            ^~~~~~~~~~~~~~
mm/zswap.c:1322:9: note: uninitialized use occurs here
        return ret;
               ^~~
mm/zswap.c:1271:2: note: remove the 'if' if its condition is always
false
        if (!entry->length) {
        ^~~~~~~~~~~~~~~~~~~~~
mm/zswap.c:1259:9: note: initialize the variable 'ret' to silence this
warning
        int ret;
               ^
                = 0
1 warning generated.

Prior to "mm/zswap: add the flag can_sleep_mapped", this path always
returned 0. Restore that so we are not returning uninitialized memory.

Link: https://github.com/ClangBuiltLinux/linux/issues/1263
Link: https://lkml.kernel.org/r/20210121214804.926843-1-natechancellor@gmail.com
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: kernelci.org bot <bot@kernelci.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zswap.c~mm-zswap-add-the-flag-can_sleep_mapped-fix
+++ a/mm/zswap.c
@@ -1272,6 +1272,7 @@ static int zswap_frontswap_load(unsigned
 		dst = kmap_atomic(page);
 		zswap_fill_page(dst, entry->value);
 		kunmap_atomic(dst);
+		ret = 0;
 		goto freeentry;
 	}
 
_

Patches currently in -mm which might be from natechancellor@gmail.com are

mm-zswap-add-the-flag-can_sleep_mapped.patch

