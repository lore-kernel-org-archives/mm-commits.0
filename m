Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EDA5C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 03:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240911AbiAYDpE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 22:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3414189AbiAYAnS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 19:43:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78BAC05433E
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 14:31:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8781661365
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 22:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4731C340E4;
        Mon, 24 Jan 2022 22:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643063495;
        bh=k8piTp+v2/oiuxGMppIGxqb8qPUgE9QiMQ+HLT8uLZs=;
        h=Date:From:To:Subject:From;
        b=h9tHks0An+XN5BBtY4aohxWiOSBzqnRn2VFixskhSMYF+SW5j6zQWqjZGGx625/pl
         BDpq4Yw87xmcB67UGIYTT77p44e2gMkLrbXGLEli2PPoHKFxJoO5S9ZXpAXSodjvmo
         YwHE2fuEiL+4ZULiqDpfagg5iqxWkmUxFUX2oDCw=
Date:   Mon, 24 Jan 2022 14:31:34 -0800
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, jane.chu@oracle.com,
        joao.m.martins@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com
Subject:  +
 memory-failure-fetch-compound_head-after-pgmap_pfn_valid.patch added to -mm
 tree
Message-ID: <20220124223134.zh4tMUWQB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory-failure: fetch compound_head after pgmap_pfn_valid()
has been added to the -mm tree.  Its filename is
     memory-failure-fetch-compound_head-after-pgmap_pfn_valid.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memory-failure-fetch-compound_head-after-pgmap_pfn_valid.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memory-failure-fetch-compound_head-after-pgmap_pfn_valid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: memory-failure: fetch compound_head after pgmap_pfn_valid()

memory_failure_dev_pagemap() at the moment assumes base pages (e.g. 
dax_lock_page()).  For devmap with compound pages fetch the compound_head
in case a tail page memory failure is being handled.

Currently this is a nop, but in the advent of compound pages in
dev_pagemap it allows memory_failure_dev_pagemap() to keep working.

Link: https://lkml.kernel.org/r/20211202204422.26777-2-joao.m.martins@oracle.com
Reported-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memory-failure.c~memory-failure-fetch-compound_head-after-pgmap_pfn_valid
+++ a/mm/memory-failure.c
@@ -1596,6 +1596,12 @@ static int memory_failure_dev_pagemap(un
 	}
 
 	/*
+	 * Pages instantiated by device-dax (not filesystem-dax)
+	 * may be compound pages.
+	 */
+	page = compound_head(page);
+
+	/*
 	 * Prevent the inode from being freed while we are interrogating
 	 * the address_space, typically this would be handled by
 	 * lock_page(), but dax pages do not use the page lock. This
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

memory-failure-fetch-compound_head-after-pgmap_pfn_valid.patch

