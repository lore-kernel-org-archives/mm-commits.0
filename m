Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0ED7C433E9
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 19:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A226E23139
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 19:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgLVTRH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 14:17:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:58616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgLVTRG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 14:17:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07B5123130;
        Tue, 22 Dec 2020 19:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608664586;
        bh=MdbhsVMArLbdRfochx2mNGhliUU80FtS/RzcY/+Sx20=;
        h=Date:From:To:Subject:From;
        b=juN+t0Tze5EMv+y0b5F6l5Y+gcz05ieyP8V17r1jibH+qwbDrR89RHVeVgYZN0Gb9
         zGMxkWPGzU+5KcuxyRI4FuymKmiN5zjr7/u9ejNQvODldCS7bwQc2nE6WN6xsgtDgl
         tPRnDmoF933o74ce4UGe8uVY+JdG03t9DTU+fOdI=
Date:   Tue, 22 Dec 2020 11:16:25 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, alex.shi@linux.alibaba.com,
        jrdr.linux@gmail.com
Subject:  + mm-add-prototype-for-__add_to_page_cache_locked.patch
 added to -mm tree
Message-ID: <20201222191625.HQQKW%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mm.h: add prototype for __add_to_page_cache_locked()
has been added to the -mm tree.  Its filename is
     mm-add-prototype-for-__add_to_page_cache_locked.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-prototype-for-__add_to_page_cache_locked.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-prototype-for-__add_to_page_cache_locked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: include/linux/mm.h: add prototype for __add_to_page_cache_locked()

Otherwise it causes a gcc warning:

../mm/filemap.c:830:14: warning: no previous prototype for
`__add_to_page_cache_locked' [-Wmissing-prototypes]

A previous attempt to make this function static led to compilation errors
for a few architectures.

Adding a prototype will silence the warning.

Link: https://lkml.kernel.org/r/1608646792-29073-1-git-send-email-jrdr.linux@gmail.com
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/mm.h~mm-add-prototype-for-__add_to_page_cache_locked
+++ a/include/linux/mm.h
@@ -216,6 +216,12 @@ int overcommit_kbytes_handler(struct ctl
 		loff_t *);
 int overcommit_policy_handler(struct ctl_table *, int, void *, size_t *,
 		loff_t *);
+/*
+ * Any attempt to mark this function as static leads to build failure
+ * for few architectures. Adding a prototype to silence gcc warning.
+ */
+int __add_to_page_cache_locked(struct page *page, struct address_space *mapping,
+		pgoff_t offset, gfp_t gfp, void **shadowp);
 
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 
_

Patches currently in -mm which might be from jrdr.linux@gmail.com are

mm-add-prototype-for-__add_to_page_cache_locked.patch

