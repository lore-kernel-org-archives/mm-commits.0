Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC5FC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 22:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0822D23E20
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 22:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405674AbgLKVh0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Dec 2020 16:37:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392163AbgLKVhR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Dec 2020 16:37:17 -0500
Date:   Fri, 11 Dec 2020 13:36:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607722589;
        bh=dy/vexMOeot19V8Dqiad/cPmps1LRViBmFF4Y0w7Dn0=;
        h=From:To:Subject:In-Reply-To:From;
        b=EFf7Kworho4zlMbTXZUcKgbrF84obgXaKxCV3F2mjtjoSgAuJLvt2oA1aZME9ToYv
         4lKAxNrP4koGstnsoG8aX6XT80zemvVHA52aKgMPSW8OhTGvITxsmNXQRMs7EkiAm2
         qToYSFM1pCIV6EQlrk/TTjLxh/BN7UEoBt3t38uI=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        ast@kernel.org, daniel@iogearbox.net, gthelen@google.com,
        jmforbes@linuxtx.org, josef@toxicpanda.com, jrdr.linux@gmail.com,
        linux-mm@kvack.org, mkubecek@suse.cz, mm-commits@vger.kernel.org,
        tony.luck@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 1/8] revert "mm/filemap: add static for function
 __add_to_page_cache_locked"
Message-ID: <20201211213627.Y0ZoNFaFt%akpm@linux-foundation.org>
In-Reply-To: <20201211133555.88407977f082963499ed343c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "mm/filemap: add static for function __add_to_page_cache_locked"

Revert 3351b16af494 ("mm/filemap: add static for function
__add_to_page_cache_locked") due to incompatibility with
ALLOW_ERROR_INJECTION which result in build errors.

Link: https://lkml.kernel.org/r/CAADnVQJ6tmzBXvtroBuEH6QA0H+q7yaSKxrVvVxhqr3KBZdEXg@mail.gmail.com
Tested-by: Justin Forbes <jmforbes@linuxtx.org>
Tested-by: Greg Thelen <gthelen@google.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Cc: Michal Kubecek <mkubecek@suse.cz>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Tony Luck <tony.luck@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked
+++ a/mm/filemap.c
@@ -827,7 +827,7 @@ int replace_page_cache_page(struct page
 }
 EXPORT_SYMBOL_GPL(replace_page_cache_page);
 
-static noinline int __add_to_page_cache_locked(struct page *page,
+noinline int __add_to_page_cache_locked(struct page *page,
 					struct address_space *mapping,
 					pgoff_t offset, gfp_t gfp,
 					void **shadowp)
_
