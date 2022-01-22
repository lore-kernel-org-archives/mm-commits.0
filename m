Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD7BC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbiAVGPE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbiAVGPC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:15:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E96C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:15:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71D01610F4
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7512BC004E1;
        Sat, 22 Jan 2022 06:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832101;
        bh=8vh+5FZgrGCe4vJN8mMLNNw9q62Hdl8EJYaSfGg1uqU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VGGI3iX786lGEaDPUF3FiuQ37a8Lhtfk4ggxCHD14aQP+iDTmkVRDno1IL1z2ChpV
         /ukYp6Z3592SkLgywRYnPGd13u1T9ECSq47DimoYZhGnhufi68T2As1SE6p26mKbdo
         3hk0CV/p69Rfs+2Yg7cCE0ZZ7e3l+DB7AmIW88Jo=
Date:   Fri, 21 Jan 2022 22:15:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ddstreet@ieee.org, geert@linux-m68k.org,
        hch@lst.de, hughd@google.com, jgross@suse.com,
        Konrad.wilk@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com,
        willy@infradead.org
Subject:  [patch 65/69] frontswap: remove frontswap_test
Message-ID: <20220122061501.AfZS9s8Km%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
