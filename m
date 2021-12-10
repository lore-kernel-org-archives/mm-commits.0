Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D5DBC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344744AbhLJWt7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344718AbhLJWt6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:49:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E41EC061746
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 14:46:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6A97DCE2B7D
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D24EC341C7;
        Fri, 10 Dec 2021 22:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176379;
        bh=lk9J/0f295OfvjPegcDzR+QZj6CrJOjL+jUddAe401c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2vQTH4lbtXZ01PjV9Rc6HpJH/Ax63ou2QGQD8kSA969i/yi9QDxKJJYiGcNVjtAO9
         /K+f5Gd8eIgXGR9V+9N1WF/I8X+bJ17TFPhAETQKc7M6DJ89QXLRcav5TTN4XTed/g
         12ltPqte9Cfp/tPwADEFwkQj9VEcpc3Bt8BmNbFQ=
Date:   Fri, 10 Dec 2021 14:46:18 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        shy828301@gmail.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 04/21] filemap: remove PageHWPoison check from
 next_uptodate_page()
Message-ID: <20211210224618.-Qsj4uLRi%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: filemap: remove PageHWPoison check from next_uptodate_page()

Pages are individually marked as suffering from hardware poisoning. 
Checking that the head page is not hardware poisoned doesn't make
sense; we might be after a subpage.  We check each page individually
before we use it, so this was an optimisation gone wrong.  It will
cause us to fall back to the slow path when there was no need to do
that

Link: https://lkml.kernel.org/r/20211120174429.2596303-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/filemap.c~filemap-remove-pagehwpoison-check-from-next_uptodate_page
+++ a/mm/filemap.c
@@ -3253,8 +3253,6 @@ static struct page *next_uptodate_page(s
 			goto skip;
 		if (!PageUptodate(page) || PageReadahead(page))
 			goto skip;
-		if (PageHWPoison(page))
-			goto skip;
 		if (!trylock_page(page))
 			goto skip;
 		if (page->mapping != mapping)
_
