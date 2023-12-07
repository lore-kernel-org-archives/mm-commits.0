Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AF8C46CA3
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441939AbjLGAOE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442957AbjLGANt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12477D71
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:47 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C486C433C9;
        Thu,  7 Dec 2023 00:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701908026;
        bh=cZfwwo3LdG/WcuuyvXcTTUkmZh8i875Rq08weSCPIw8=;
        h=Date:To:From:Subject:From;
        b=EzZ3id4dUNo4fXoUdsyManEHe6FgnrDXP1xd4ubeZmmw083uXsQl9q6gfEkg393VT
         pi6Lt/MtoykKkbMb6CqFfBDAPGYqGUFE9wSUUa8k1RlvpzwcWmjaTxqSiw41lwi0xS
         k+r/Gk9tIi5mA3Qu3EmmjEitvvSS+VXSoDzznmsk=
Date:   Wed, 06 Dec 2023 16:13:46 -0800
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-have-config_hugetlb_page-select-config_xarray_multi.patch removed from -mm tree
Message-Id: <20231207001346.8C486C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: have CONFIG_HUGETLB_PAGE select CONFIG_XARRAY_MULTI
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-have-config_hugetlb_page-select-config_xarray_multi.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: have CONFIG_HUGETLB_PAGE select CONFIG_XARRAY_MULTI
Date: Mon, 4 Dec 2023 10:32:34 -0800

After commit a08c7193e4f1 "mm/filemap: remove hugetlb special casing in
filemap.c", hugetlb pages are stored in the page cache in base page sized
indexes.  This leads to multi index stores in the xarray which is only
supporting through CONFIG_XARRAY_MULTI.  The other page cache user of
multi index stores ,THP, selects XARRAY_MULTI.  Have CONFIG_HUGETLB_PAGE
follow this behavior as well to avoid the BUG() with a CONFIG_HUGETLB_PAGE
&& !CONFIG_XARRAY_MULTI config.

Link: https://lkml.kernel.org/r/20231204183234.348697-1-sidhartha.kumar@oracle.com
Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c")
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/Kconfig~mm-hugetlb-have-config_hugetlb_page-select-config_xarray_multi
+++ a/fs/Kconfig
@@ -268,6 +268,7 @@ config HUGETLBFS
 
 config HUGETLB_PAGE
 	def_bool HUGETLBFS
+	select XARRAY_MULTI
 
 config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


