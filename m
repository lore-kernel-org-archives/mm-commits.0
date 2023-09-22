Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F360CE7D0BC
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 01:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjIVBfY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjIVBfY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 21:35:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841AFF1
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 18:35:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D3CC433C9;
        Fri, 22 Sep 2023 01:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695346518;
        bh=VNzK/CW7BDA0jjSbNJ75s2mSF9JBNXgTAwkIjhVFxu0=;
        h=Date:To:From:Subject:From;
        b=yUQVTu7QOf+3l39iiDu8Pq1ol3wH4dj8LhQCllIHMJzuPzR2J6x/kcNv7siqRWx5M
         FlCbUQU0F9r8SsJK8XYEp80Utq0zhPV7YDAhyMeSGU9PDW6+h28VLHUMMbqfEqPTsN
         O6WgGs0Dvefd3Pev5dNgMJcgDUy+QZG/2muXz4Qc=
Date:   Thu, 21 Sep 2023 18:35:17 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, duminjie@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-increase-usage-of-folio_next_index-helper.patch added to mm-unstable branch
Message-Id: <20230922013518.20D3CC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: increase usage of folio_next_index() helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-increase-usage-of-folio_next_index-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-increase-usage-of-folio_next_index-helper.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Minjie Du <duminjie@vivo.com>
Subject: mm/filemap: increase usage of folio_next_index() helper
Date: Thu, 21 Sep 2023 16:15:35 +0800

Simplify code pattern of 'folio->index + folio_nr_pages(folio)' by using
the existing helper folio_next_index() in filemap_map_pages().

Link: https://lkml.kernel.org/r/20230921081535.3398-1-duminjie@vivo.com
Signed-off-by: Minjie Du <duminjie@vivo.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-increase-usage-of-folio_next_index-helper
+++ a/mm/filemap.c
@@ -3591,7 +3591,7 @@ vm_fault_t filemap_map_pages(struct vm_f
 		addr += (xas.xa_index - last_pgoff) << PAGE_SHIFT;
 		vmf->pte += xas.xa_index - last_pgoff;
 		last_pgoff = xas.xa_index;
-		end = folio->index + folio_nr_pages(folio) - 1;
+		end = folio_next_index(folio) - 1;
 		nr_pages = min(end, end_pgoff) - xas.xa_index + 1;
 
 		if (!folio_test_large(folio))
_

Patches currently in -mm which might be from duminjie@vivo.com are

mm-filemap-increase-usage-of-folio_next_index-helper.patch

