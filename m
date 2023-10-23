Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A8FDC25B46
	for <mm-commits@archiver.kernel.org>; Mon, 23 Oct 2023 18:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjJWS0z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Oct 2023 14:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjJWS0y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Oct 2023 14:26:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C736D127
        for <mm-commits@vger.kernel.org>; Mon, 23 Oct 2023 11:26:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E18EC433C7;
        Mon, 23 Oct 2023 18:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698085612;
        bh=85dGxXjRx6fn80kKXfKOX2eroDen6dQFElJh/xZbDf4=;
        h=Date:To:From:Subject:From;
        b=Y5nvGaBlEGXuRCPGWtAf9gYSB7W12wjX2Hd0Uh0htM91ZACq2vLEMMBQv6ZStWYn5
         MtVc3rMeHrdI5KqONi5WUXQ9Pt14zpnx/ZMQ7KmNv2cUAdtC2l2xQqvBlMjKDM08HV
         SCQnyT0vtYwv5e24DsEsVZRF7ZuT1jYrDN5uKbxk=
Date:   Mon, 23 Oct 2023 11:26:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.ibm.com, ira.weiny@intel.com, corbet@lwn.net,
        bobwxc@email.cn, vegard.nossum@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-fix-reference-to-nonexistent-file.patch added to mm-unstable branch
Message-Id: <20231023182652.5E18EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: fix reference to nonexistent file
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-fix-reference-to-nonexistent-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-fix-reference-to-nonexistent-file.patch

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
From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: mm: hugetlb_vmemmap: fix reference to nonexistent file
Date: Sun, 22 Oct 2023 20:56:19 +0200

The directory this file is in was renamed but the reference didn't get
updated.  Fix it.

Link: https://lkml.kernel.org/r/20231022185619.919397-1-vegard.nossum@oracle.com
Fixes: ee65728e103b ("docs: rename Documentation/vm to Documentation/mm")
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Wu XiangCheng <bobwxc@email.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_vmemmap.h~mm-hugetlb_vmemmap-fix-reference-to-nonexistent-file
+++ a/mm/hugetlb_vmemmap.h
@@ -12,7 +12,7 @@
 
 /*
  * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
- * Documentation/vm/vmemmap_dedup.rst.
+ * Documentation/mm/vmemmap_dedup.rst.
  */
 #define HUGETLB_VMEMMAP_RESERVE_SIZE	PAGE_SIZE
 #define HUGETLB_VMEMMAP_RESERVE_PAGES	(HUGETLB_VMEMMAP_RESERVE_SIZE / sizeof(struct page))
_

Patches currently in -mm which might be from vegard.nossum@oracle.com are

mm-hugetlb_vmemmap-fix-reference-to-nonexistent-file.patch

