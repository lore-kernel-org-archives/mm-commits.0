Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD83C63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbjBCGgX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232145AbjBCGfv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8CB8B7DE
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79F1861D98
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0933C433D2;
        Fri,  3 Feb 2023 06:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406144;
        bh=SIo16rg+7UK+KK4x9MxICfeT+NWnP5hU/jb40xifxDc=;
        h=Date:To:From:Subject:From;
        b=0csj1Mjob8wxe3SCQMzLkrt3f6SgtMdwFzibXVkec2UkpvnqnIA2IANCKr/ZdmzOZ
         Ty7o5z2wtUdWKLCjVa5i7CObuuJaVo0am/IbFCpLKtqrYy6YW3jz5zyqGP6eyn3K/F
         Yvre8iJLXfs1ah5Cy3VJmOOhVwQWhiRdJl74hK3Y=
Date:   Thu, 02 Feb 2023 22:35:44 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug-remove-call-to-head_compound_mapcount.patch removed from -mm tree
Message-Id: <20230203063544.D0933C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/debug: remove call to head_compound_mapcount()
has been removed from the -mm tree.  Its filename was
     mm-debug-remove-call-to-head_compound_mapcount.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/debug: remove call to head_compound_mapcount()
Date: Wed, 11 Jan 2023 14:28:58 +0000

Call folio_entire_mapcount() instead.

Link: https://lkml.kernel.org/r/20230111142915.1001531-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/debug.c~mm-debug-remove-call-to-head_compound_mapcount
+++ a/mm/debug.c
@@ -94,9 +94,9 @@ static void __dump_page(struct page *pag
 			page, page_ref_count(head), mapcount, mapping,
 			page_to_pgoff(page), page_to_pfn(page));
 	if (compound) {
-		pr_warn("head:%p order:%u compound_mapcount:%d nr_pages_mapped:%d pincount:%d\n",
+		pr_warn("head:%p order:%u entire_mapcount:%d nr_pages_mapped:%d pincount:%d\n",
 				head, compound_order(head),
-				head_compound_mapcount(head),
+				folio_entire_mapcount(folio),
 				folio_nr_pages_mapped(folio),
 				atomic_read(&folio->_pincount));
 	}
_

Patches currently in -mm which might be from willy@infradead.org are


