Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE29C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiJCVO0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJCVM0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:12:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A20152469
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9824BB811C4
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A0AC433D6;
        Mon,  3 Oct 2022 21:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831264;
        bh=dwdEHSIVdy5G9ApEuKilCufNDucvVMwoqvZRpCQ+GQY=;
        h=Date:To:From:Subject:From;
        b=zl0RW6WpCjp8iiXEDiQuRBFwjoNV/KVPus7QW6+JY8XDJHpAFEXIODsMFBqbLeu0r
         RIQLasmCtd3GD9aUZ3QXYjhztUSt4tF8/QdCHEsnchcQ/l0QSUO1Kg8ELNUaOxefx9
         DWhybVw86aAdJza/xGTpMjchj8wtKD2VUaEZrYYg=
Date:   Mon, 03 Oct 2022 14:07:43 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        zuoze1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-use-page_align-instead-of-open-coding-it.patch removed from -mm tree
Message-Id: <20221003210744.37A0AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mempolicy: use PAGE_ALIGN instead of open-coding it
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-use-page_align-instead-of-open-coding-it.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ze zuo <zuoze1@huawei.com>
Subject: mm/mempolicy: use PAGE_ALIGN instead of open-coding it
Date: Tue, 13 Sep 2022 01:55:05 +0000

Replace the simple calculation with PAGE_ALIGN.

Link: https://lkml.kernel.org/r/20220913015505.1998958-1-zuoze1@huawei.com
Signed-off-by: ze zuo <zuoze1@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-page_align-instead-of-open-coding-it
+++ a/mm/mempolicy.c
@@ -1270,7 +1270,7 @@ static long do_mbind(unsigned long start
 	if (mode == MPOL_DEFAULT)
 		flags &= ~MPOL_MF_STRICT;
 
-	len = (len + PAGE_SIZE - 1) & PAGE_MASK;
+	len = PAGE_ALIGN(len);
 	end = start + len;
 
 	if (end < start)
@@ -1507,7 +1507,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 	if (home_node >= MAX_NUMNODES || !node_online(home_node))
 		return -EINVAL;
 
-	len = (len + PAGE_SIZE - 1) & PAGE_MASK;
+	len = PAGE_ALIGN(len);
 	end = start + len;
 
 	if (end < start)
_

Patches currently in -mm which might be from zuoze1@huawei.com are


