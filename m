Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF5ECC433E6
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA408221F8
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgL2XPP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 18:15:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgL2XPP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 18:15:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA23420771;
        Tue, 29 Dec 2020 23:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609283674;
        bh=8hRpQ/8ia7GM5TtfyORnuPZCy4WfygZ0oIT2oLc1JFo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=D08JYTcp2du63ssk233o9EX1Q5o8fJcQG0aN2BNwGc+jvsk4MOeJ3L5DL+bl4aogx
         9U1oAZ5g8ah8XdgO9xogLkWLfhxmZ+koY7/esJ+7lHPdvpd+WA7wGvT+8uo2yjF+TC
         +yxMBQJ/IaDe0Tn2IBHYL44ZlBYapo06oX7ANqME=
Date:   Tue, 29 Dec 2020 15:14:34 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        jrdr.linux@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 05/16] mm: add prototype for
 __add_to_page_cache_locked()
Message-ID: <20201229231434.VRo4LdoKH%akpm@linux-foundation.org>
In-Reply-To: <20201229151349.3285926ec0d1f65a27ac8534@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
