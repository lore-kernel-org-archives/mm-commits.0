Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FA1C43219
	for <mm-commits@archiver.kernel.org>; Thu, 24 Nov 2022 21:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiKXVuh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Nov 2022 16:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiKXVug (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Nov 2022 16:50:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8002B6B35
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 13:50:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 549E062265
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 21:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E73C433D6;
        Thu, 24 Nov 2022 21:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669326634;
        bh=qegQ2DPE8dubViG+0ofVEMNkKdEblwOwTgGXOwbz4Io=;
        h=Date:To:From:Subject:From;
        b=WotUDG4x2Ungh/DUJaAGjXGrHfg4UmTEJVsDVjTtyBeqZIxyChThUoM/l16E9I5nc
         3aX1Dael7pxBoGla70n2d11Gv/6IYYNCUt9PDTFeoET71GIlEsXib8a9yJ64L7zSZ0
         /q6ZCXrQPLW6ky6gsdLCxUcGRXQK86nK/1TAvI4o=
Date:   Thu, 24 Nov 2022 13:50:33 -0800
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com,
        xu.panda@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-use-sysfs_emit-to-instead-of-scnprintf.patch added to mm-unstable branch
Message-Id: <20221124215034.A5E73C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: use sysfs_emit() to instead of scnprintf()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-use-sysfs_emit-to-instead-of-scnprintf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-use-sysfs_emit-to-instead-of-scnprintf.patch

This patch will later appear in the mm-unstable branch at
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
From: Xu Panda <xu.panda@zte.com.cn>
Subject: mm: vmscan: use sysfs_emit() to instead of scnprintf()
Date: Thu, 24 Nov 2022 19:29:01 +0800 (CST)

Replace open-coded snprintf() with sysfs_emit() to simplify the code.

Link: https://lkml.kernel.org/r/202211241929015476424@zte.com.cn
Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-use-sysfs_emit-to-instead-of-scnprintf
+++ a/mm/vmscan.c
@@ -5407,7 +5407,7 @@ static ssize_t show_enabled(struct kobje
 	if (arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YOUNG))
 		caps |= BIT(LRU_GEN_NONLEAF_YOUNG);
 
-	return snprintf(buf, PAGE_SIZE, "0x%04x\n", caps);
+	return sysfs_emit(buf, "0x%04x\n", caps);
 }
 
 /* see Documentation/admin-guide/mm/multigen_lru.rst for details */
_

Patches currently in -mm which might be from xu.panda@zte.com.cn are

mm-vmscan-use-sysfs_emit-to-instead-of-scnprintf.patch
relay-use-strscpy-is-more-robust-and-safer.patch

