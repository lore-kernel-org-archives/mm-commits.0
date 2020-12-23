Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC59C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 20:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3FF82246B
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 20:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbgLWUi5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 15:38:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbgLWUi5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 15:38:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 979B5223DB;
        Wed, 23 Dec 2020 20:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608755896;
        bh=UeLaZHV8nvDJI940dm1wMNRXwyZh7p/fw5fCUsVrbY0=;
        h=Date:From:To:Subject:From;
        b=WSTZURZgpYveeY8xKqxIuFtxJgf+1wqduOfrvleYOlygBzSgBPQgtMRakEO7JTPsO
         j3HD34nEbF9NuJWCzn0TehubG6AIWrAwzaz3fFhdumkKW6z+mgbCVxM6N61D+yd38n
         vTJVCl40MLu/cxfObf1GXVta8h/cm16wt9xadMMk=
Date:   Wed, 23 Dec 2020 12:38:15 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        alex.shi@linux.alibaba.com, jrdr.linux@gmail.com
Subject:  [to-be-updated]
 mm-add-prototype-for-__add_to_page_cache_locked.patch removed from -mm tree
Message-ID: <20201223203815.cOk2m%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mm.h: add prototype for __add_to_page_cache_locked()
has been removed from the -mm tree.  Its filename was
     mm-add-prototype-for-__add_to_page_cache_locked.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: include/linux/mm.h: add prototype for __add_to_page_cache_locked()

Otherwise it causes a gcc warning:

../mm/filemap.c:830:14: warning: no previous prototype for
`__add_to_page_cache_locked' [-Wmissing-prototypes]

A previous attempt to make this function static led to compilation
errors for a few architectures, because __add_to_page_cache_locked() is
referred to by BPF code.

Adding a prototype will silence the warning.

Link: https://lkml.kernel.org/r/1608646792-29073-1-git-send-email-jrdr.linux@gmail.com
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
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


