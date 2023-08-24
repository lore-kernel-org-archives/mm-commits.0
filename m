Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C138DEE49A5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbjHXXVH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235642AbjHXXVE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C1BA8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8C9F612FE
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A464C433C8;
        Thu, 24 Aug 2023 23:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919261;
        bh=Hh2C3CVb3otMgq/yf9pe9ldsPbKQZSpYS7svfm6pVBs=;
        h=Date:To:From:Subject:From;
        b=w0wg6nlSG64ZvMIbF3zb+/jmpVCarVuYbWS3e8zEEtBY4wDX3DxgOdTI8Qe1WICCB
         Z7+9gim7Hinz2ixABwF9iSRL7yUY6OKE+twyZIo+h3xQEcfyNUd7LilcYhvx2ymBNl
         sH+l3BrUAUJil+u5mR4w5CoqicSr3HzWr+gz8u7Q=
Date:   Thu, 24 Aug 2023 16:21:00 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch removed from -mm tree
Message-Id: <20230824232101.2A464C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: fix potential page refcnt leak in memory_failure()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: fix potential page refcnt leak in memory_failure()
Date: Sat, 1 Jul 2023 15:28:37 +0800

put_ref_page() is not called to drop extra refcnt when comes from madvise
in the case pfn is valid but pgmap is NULL leading to page refcnt leak.

Link: https://lkml.kernel.org/r/20230701072837.1994253-1-linmiaohe@huawei.com
Fixes: 1e8aaedb182d ("mm,memory_failure: always pin the page in madvise_inject_error")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure
+++ a/mm/memory-failure.c
@@ -2117,8 +2117,6 @@ static int memory_failure_dev_pagemap(un
 {
 	int rc = -ENXIO;
 
-	put_ref_page(pfn, flags);
-
 	/* device metadata space is not recoverable */
 	if (!pgmap_pfn_valid(pgmap, pfn))
 		goto out;
@@ -2193,6 +2191,7 @@ int memory_failure(unsigned long pfn, in
 
 		if (pfn_valid(pfn)) {
 			pgmap = get_dev_pagemap(pfn, NULL);
+			put_ref_page(pfn, flags);
 			if (pgmap) {
 				res = memory_failure_dev_pagemap(pfn, flags,
 								 pgmap);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-add-pageoffline-check.patch

