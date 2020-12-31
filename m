Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B4FDC4332D
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49A77224D4
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgLaSXd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:23:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgLaSXd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 31 Dec 2020 13:23:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7A522242A;
        Thu, 31 Dec 2020 18:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609438973;
        bh=MzC7cE3QcN/BmW1qdI8f4YSiS376ty7NFR6ivsn+vPI=;
        h=Date:From:To:Subject:From;
        b=Bu41XmiuoPLYvJo/Dc1Epqm3cEzw5+0FFpmL71f5ZdbQ3S7PSb7UhX2Qd4MVgQ5xN
         pM/QXDxUJjUtparoGlzXuiYi8+TfDzKrRQNzhko6sHZygP+sWKVEQSBjrw0MjRPgGP
         MPaQ1/er5zkZpQj89xh648OsCymsAI8C9/AA1ZRQ=
Date:   Thu, 31 Dec 2020 10:22:52 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, jrdr.linux@gmail.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-add-prototype-for-__add_to_page_cache_locked.patch removed from -mm tree
Message-ID: <20201231182252.jWTMBJ6Zg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add prototype for __add_to_page_cache_locked()
has been removed from the -mm tree.  Its filename was
     mm-add-prototype-for-__add_to_page_cache_locked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: mm: add prototype for __add_to_page_cache_locked()

Otherwise it causes a gcc warning:

../mm/filemap.c:830:14: warning: no previous prototype for
`__add_to_page_cache_locked' [-Wmissing-prototypes]

A previous attempt to make this function static led to compilation errors
when CONFIG_DEBUG_INFO_BTF is enabled because __add_to_page_cache_locked()
is referred to by BPF code.

Adding a prototype will silence the warning.

Link: https://lkml.kernel.org/r/1608693702-4665-1-git-send-email-jrdr.linux@gmail.com
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/mm.h~mm-add-prototype-for-__add_to_page_cache_locked
+++ a/include/linux/mm.h
@@ -216,6 +216,13 @@ int overcommit_kbytes_handler(struct ctl
 		loff_t *);
 int overcommit_policy_handler(struct ctl_table *, int, void *, size_t *,
 		loff_t *);
+/*
+ * Any attempt to mark this function as static leads to build failure
+ * when CONFIG_DEBUG_INFO_BTF is enabled because __add_to_page_cache_locked()
+ * is referred to by BPF code. This must be visible for error injection.
+ */
+int __add_to_page_cache_locked(struct page *page, struct address_space *mapping,
+		pgoff_t index, gfp_t gfp, void **shadowp);
 
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 
_

Patches currently in -mm which might be from jrdr.linux@gmail.com are


