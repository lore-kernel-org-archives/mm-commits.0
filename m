Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1067C10DC3
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 18:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjLDS5O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 13:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbjLDS5C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 13:57:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720C2111
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 10:57:07 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8B2C433C9;
        Mon,  4 Dec 2023 18:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701716227;
        bh=LzGnAlN1fSz417xZvITTB73FBerXAXYnvREDXFR4rig=;
        h=Date:To:From:Subject:From;
        b=VNFaBT5dNG/AVAmTrN2m/ditW7XsPgPV7/TNc9eul5Elhb/11QrtjAERA8RFRahpz
         bocaJizGdJJrvJKlGHA1uG5JqwDz7B5TcH0mBIgjX+mhbofgb2wvryla477NSoeEJz
         He3eO8ZWA6ANS/QU8hardTqA8c6Tv5L1bknanna4=
Date:   Mon, 04 Dec 2023 10:57:06 -0800
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-have-config_hugetlb_page-select-config_xarray_multi.patch added to mm-hotfixes-unstable branch
Message-Id: <20231204185707.5C8B2C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: have CONFIG_HUGETLB_PAGE select CONFIG_XARRAY_MULTI
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-have-config_hugetlb_page-select-config_xarray_multi.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-have-config_hugetlb_page-select-config_xarray_multi.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: have CONFIG_HUGETLB_PAGE select CONFIG_XARRAY_MULTI
Date: Mon, 4 Dec 2023 10:32:34 -0800

After commit a08c7193e4f1 "mm/filemap: remove hugetlb special casing in
filemap.c", hugetlb pages are stored in the page cache in base page sized
indexes.  This leads to mutli index stores in the xarray which is only
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

mm-hugetlb-have-config_hugetlb_page-select-config_xarray_multi.patch

