Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81183C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240520AbiAWX6x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:58:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46892 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbiAWX6w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:58:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53E85B80E44
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4D3C340E3;
        Sun, 23 Jan 2022 23:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982330;
        bh=lJDt9b7A5Hz3huuo33bKJJk2eJIsONBZ8Lc9LdgOx1s=;
        h=Date:From:To:Subject:From;
        b=cE98p7PVxXdVf8v/8pWm4yN+SEQv5A1E0rB8kghdZYi8Rin5QKke2KnWEgtU4L/l/
         tYK+ZDvN+gV0V219AYoCclMhj0+5WZJ3gLV2na+0WlsrTzxb14W1OTdUqeSOY7NdXY
         gXvEjZqtCAMqRZzTmtRbHCcEART6OFaE8El3JWLw=
Date:   Sun, 23 Jan 2022 15:58:49 -0800
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, geert@linux-m68k.org, hch@lst.de,
        hughd@google.com, jgross@suse.com, Konrad.wilk@oracle.com,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        vitaly.wool@konsulko.com, willy@infradead.org
Subject:  [merged] frontswap-remove-frontswap_test.patch removed
 from -mm tree
Message-ID: <20220123235849.cOQWhHs98%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: frontswap: remove frontswap_test
has been removed from the -mm tree.  Its filename was
     frontswap-remove-frontswap_test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: frontswap: remove frontswap_test

frontswap_test is unused now, remove it.

Link: https://lkml.kernel.org/r/20211224062246.1258487-10-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konrad Rzeszutek Wilk <Konrad.wilk@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/frontswap.h |   11 -----------
 mm/frontswap.c            |    2 +-
 2 files changed, 1 insertion(+), 12 deletions(-)

--- a/include/linux/frontswap.h~frontswap-remove-frontswap_test
+++ a/include/linux/frontswap.h
@@ -18,7 +18,6 @@ struct frontswap_ops {
 
 extern void frontswap_register_ops(struct frontswap_ops *ops);
 
-extern bool __frontswap_test(struct swap_info_struct *, pgoff_t);
 extern void frontswap_init(unsigned type, unsigned long *map);
 extern int __frontswap_store(struct page *page);
 extern int __frontswap_load(struct page *page);
@@ -33,11 +32,6 @@ static inline bool frontswap_enabled(voi
 	return static_branch_unlikely(&frontswap_enabled_key);
 }
 
-static inline bool frontswap_test(struct swap_info_struct *sis, pgoff_t offset)
-{
-	return __frontswap_test(sis, offset);
-}
-
 static inline void frontswap_map_set(struct swap_info_struct *p,
 				     unsigned long *map)
 {
@@ -55,11 +49,6 @@ static inline bool frontswap_enabled(voi
 {
 	return false;
 }
-
-static inline bool frontswap_test(struct swap_info_struct *sis, pgoff_t offset)
-{
-	return false;
-}
 
 static inline void frontswap_map_set(struct swap_info_struct *p,
 				     unsigned long *map)
--- a/mm/frontswap.c~frontswap-remove-frontswap_test
+++ a/mm/frontswap.c
@@ -179,7 +179,7 @@ void frontswap_init(unsigned type, unsig
 		ops->init(type);
 }
 
-bool __frontswap_test(struct swap_info_struct *sis,
+static bool __frontswap_test(struct swap_info_struct *sis,
 				pgoff_t offset)
 {
 	if (sis->frontswap_map)
_

Patches currently in -mm which might be from hch@lst.de are


