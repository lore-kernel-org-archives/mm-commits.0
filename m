Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4ABE94134
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbjJFVsF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233843AbjJFVrz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:47:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2822E4
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:47:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0763CC433C7;
        Fri,  6 Oct 2023 21:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628874;
        bh=6Svi0Es+jry2yAvwJDhIj7PL+YSErA+G2UbHDO1mN3Y=;
        h=Date:To:From:Subject:From;
        b=i7yeia3KFd0nK2dp+tHmvmMPxUzrCRS3C+FKSVWrqIIKltprgtJqxwYqaRU9trGgD
         U/IHtRp6zVt1yHHa2hFCa3NU4O5FEeWsZsZkbPrPwDf1O5Cd+5K7ngWitc3z+Ndy0s
         OKsEThs6pGRiP7jhI00ncNqpOUp8kusyfHqVM2v8=
Date:   Fri, 06 Oct 2023 14:47:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        fengwei.yin@intel.com, duminjie@vivo.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-increase-usage-of-folio_next_index-helper.patch removed from -mm tree
Message-Id: <20231006214754.0763CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/filemap: increase usage of folio_next_index() helper
has been removed from the -mm tree.  Its filename was
     mm-filemap-increase-usage-of-folio_next_index-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Minjie Du <duminjie@vivo.com>
Subject: mm/filemap: increase usage of folio_next_index() helper
Date: Thu, 21 Sep 2023 16:15:35 +0800

Simplify code pattern of 'folio->index + folio_nr_pages(folio)' by using
the existing helper folio_next_index() in filemap_map_pages().

Link: https://lkml.kernel.org/r/20230921081535.3398-1-duminjie@vivo.com
Signed-off-by: Minjie Du <duminjie@vivo.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
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


