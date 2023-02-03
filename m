Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF3D0C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbjBCGgX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjBCGfv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB89E8BDD3
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7530861DA7
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1053C433D2;
        Fri,  3 Feb 2023 06:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406145;
        bh=yGkgL0vbOqKX/HkrooYQ+ngEsbZZBtyoQJYDZa0D5D4=;
        h=Date:To:From:Subject:From;
        b=P3dOSiYvFxap964r0HitO3sZANQ6JlXtSscZ5Ut9R3XwNoHXuWngg/UqaZz9hUmEi
         9DDF5+IBpyK4IRH3GtFzWFW4sZHkczabzI5N7u+sCtVX/A67c95mGu77QQRDFQYQXj
         DOM/UY32jLBk36R3KF7Cp/UdS/3Iz2kt1KrJzheU=
Date:   Thu, 02 Feb 2023 22:35:45 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-remove-uses-of-folio_mapcount_ptr.patch removed from -mm tree
Message-Id: <20230203063545.D1053C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: remove uses of folio_mapcount_ptr
has been removed from the -mm tree.  Its filename was
     hugetlb-remove-uses-of-folio_mapcount_ptr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: remove uses of folio_mapcount_ptr
Date: Wed, 11 Jan 2023 14:28:59 +0000

Use the entire_mapcount field directly.

Link: https://lkml.kernel.org/r/20230111142915.1001531-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~hugetlb-remove-uses-of-folio_mapcount_ptr
+++ a/mm/hugetlb.c
@@ -1474,7 +1474,7 @@ static void __destroy_compound_gigantic_
 	int nr_pages = 1 << order;
 	struct page *p;
 
-	atomic_set(folio_mapcount_ptr(folio), 0);
+	atomic_set(&folio->_entire_mapcount, 0);
 	atomic_set(&folio->_nr_pages_mapped, 0);
 	atomic_set(&folio->_pincount, 0);
 
@@ -1996,7 +1996,7 @@ static bool __prep_compound_gigantic_fol
 		if (i != 0)
 			set_compound_head(p, &folio->page);
 	}
-	atomic_set(folio_mapcount_ptr(folio), -1);
+	atomic_set(&folio->_entire_mapcount, -1);
 	atomic_set(&folio->_nr_pages_mapped, 0);
 	atomic_set(&folio->_pincount, 0);
 	return true;
_

Patches currently in -mm which might be from willy@infradead.org are


