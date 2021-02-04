Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD600C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ACEE64E3D
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbhBDAQR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Feb 2021 19:16:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233790AbhBDAQQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Feb 2021 19:16:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5DE764F64;
        Thu,  4 Feb 2021 00:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612397736;
        bh=r3H3gjPr7ARoOKyCfAbkAdFO36wf0/Atb9ld7GlGl0U=;
        h=Date:From:To:Subject:From;
        b=vA65ORlmao4P3ppTx613OYUFzFw+x0TqD/gzuEjJqG2u37jbyAk6/6SANJk56OHGo
         8NoEfANHktZ0EKh8oySRDszzx3BdVEnWt/k/dlZ+9201L40QIQhnGC8drpsxfffHZE
         enQUoO2JCnHFa1aKPHZn6/B3LlY+cGFWdeiicnqQ=
Date:   Wed, 03 Feb 2021 16:15:35 -0800
From:   akpm@linux-foundation.org
To:     ira.weiny@intel.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  + fs-coredump-use-kmap_local_page.patch added to -mm tree
Message-ID: <20210204001535.kZOhK5SkW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/coredump: use kmap_local_page()
has been added to the -mm tree.  Its filename is
     fs-coredump-use-kmap_local_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-coredump-use-kmap_local_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-coredump-use-kmap_local_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: fs/coredump: use kmap_local_page()

In dump_user_range() there is no reason for the mapping to be global.  Use
kmap_local_page() rather than kmap.

Link: https://lkml.kernel.org/r/20210203223328.558945-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/coredump.c~fs-coredump-use-kmap_local_page
+++ a/fs/coredump.c
@@ -894,10 +894,10 @@ int dump_user_range(struct coredump_para
 		 */
 		page = get_dump_page(addr);
 		if (page) {
-			void *kaddr = kmap(page);
+			void *kaddr = kmap_local_page(page);
 
 			stop = !dump_emit(cprm, kaddr, PAGE_SIZE);
-			kunmap(page);
+			kunmap_local(kaddr);
 			put_page(page);
 		} else {
 			stop = !dump_skip(cprm, PAGE_SIZE);
_

Patches currently in -mm which might be from ira.weiny@intel.com are

fs-coredump-use-kmap_local_page.patch

