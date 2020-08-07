Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290B6C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E245622C9F
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781200;
	bh=WPCsUZVSwftMcswc4eKyUaSUjWe8J64jW4G6JO1yuLE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=BLA2BeaFBZI//4os3+gGiiBwHws5DLBkZUZKQ1triYWrImIYi+4AGP+8Lg4+Ojny9
	 fNYSVLS0ocEu0JhI47jsNpD4omPMSY2qgNfRzoezCOVGuRcd9UbG0oRCh4WELM6jZb
	 3z1LeZ/Xm3nFSqGCTg3d2/iULCLKahSRlxfHLmyc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgHGGT7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:19:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGT7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:19:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDE7D2177B;
        Fri,  7 Aug 2020 06:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781199;
        bh=WPCsUZVSwftMcswc4eKyUaSUjWe8J64jW4G6JO1yuLE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=q/Hy8+5/h6lTZ0yGQu6PyxaQyq4QbhFVexO72F9zajODoCPIhmajOomaNvS66VAzT
         DS3QMRTIOEo2zVEbkcwzh1a1tsWUO/ZGIHbjGH1igUlFydDHxh69AAv155AfLpNlJM
         CHl7at2r9Da+ZSI0rdQh04vh62Siw4SVt75FzMYw=
Date:   Thu, 06 Aug 2020 23:19:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gavin.dg@linux.alibaba.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        riel@surriel.com, shakeelb@google.com,
        torvalds@linux-foundation.org, yang.shi@linux.alibaba.com
Subject:  [patch 052/163] mm: filemap: add missing FGP_ flags in
 kerneldoc comment for pagecache_get_page
Message-ID: <20200807061958.JLQGcG_41%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: filemap: add missing FGP_ flags in kerneldoc comment for pagecache_get_page

FGP_{WRITE|NOFS|NOWAIT} were missed in pagecache_get_page's kerneldoc
comment.

Link: http://lkml.kernel.org/r/1593031747-4249-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Gang Deng <gavin.dg@linux.alibaba.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/filemap.c~mm-filemap-add-missing-fgp_-flags-in-kerneldoc-comment-for-pagecache_get_page
+++ a/mm/filemap.c
@@ -1649,6 +1649,9 @@ EXPORT_SYMBOL(find_lock_entry);
  * * %FGP_FOR_MMAP - The caller wants to do its own locking dance if the
  *   page is already in cache.  If the page was allocated, unlock it before
  *   returning so the caller can do the same dance.
+ * * %FGP_WRITE - The page will be written
+ * * %FGP_NOFS - __GFP_FS will get cleared in gfp mask
+ * * %FGP_NOWAIT - Don't get blocked by page lock
  *
  * If %FGP_LOCK or %FGP_CREAT are specified then the function may sleep even
  * if the %GFP flags specified for %FGP_CREAT are atomic.
_
