Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B0CC43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21064208B3
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633287;
	bh=EsWoH2wp39F3BhizBrzL01bVK2zorE7x5fULjmsF8Ss=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=I6CxBG9hg83/FRKhazS1hAhBPXz3HxQlaZQEYj7ZV99c9Wd5MMbM/bv99jnNWtMjD
	 5w8r9LTkkR0bjxKo1AjwOITkW06Ik641GAX+lFl/6nPiWjJmdPmEnXgutfiSWfl3Jw
	 8Zy6EoMZ0ryYR8KpiVq1/BVhD7766pXCdWZwK4/s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388140AbgJMXyq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMXyq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:54:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D81EC221FF;
        Tue, 13 Oct 2020 23:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633286;
        bh=EsWoH2wp39F3BhizBrzL01bVK2zorE7x5fULjmsF8Ss=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qZIFtnBSepwWAZ33/nt+XUj0BMrLzKuStgUi8uAdX20EE44SC8mLxamTfqypmRuMY
         c05gg28usP0ZrdDnUzhE/iEMg0exXSecsCDPLUbg9yqlZAkS/fQBMQBBjKmxk9gDtN
         ZqbBMj7AvlUxdjlWHh90SUSmvCbJtiOnNlQzHieY=
Date:   Tue, 13 Oct 2020 16:54:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, torvalds@linux-foundation.org
Subject:  [patch 116/181] mm/memory-failure.c: remove unused macro
 `writeback'
Message-ID: <20201013235445.T5_489sH-%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/memory-failure.c: remove unused macro `writeback'

Unlike others we don't use the marco writeback.  so let's remove it to
tame gcc warning:

mm/memory-failure.c:827: warning: macro "writeback" is not used
[-Wunused-macros]

Link: https://lkml.kernel.org/r/1599715096-20369-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memory-failure.c~mm-remove-unused-marco-writeback
+++ a/mm/memory-failure.c
@@ -825,7 +825,6 @@ static int me_huge_page(struct page *p,
 #define sc		((1UL << PG_swapcache) | (1UL << PG_swapbacked))
 #define unevict		(1UL << PG_unevictable)
 #define mlock		(1UL << PG_mlocked)
-#define writeback	(1UL << PG_writeback)
 #define lru		(1UL << PG_lru)
 #define head		(1UL << PG_head)
 #define slab		(1UL << PG_slab)
@@ -874,7 +873,6 @@ static struct page_state {
 #undef sc
 #undef unevict
 #undef mlock
-#undef writeback
 #undef lru
 #undef head
 #undef slab
_
