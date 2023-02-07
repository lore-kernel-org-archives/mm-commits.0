Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843C8C636CC
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 22:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjBGWzE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Feb 2023 17:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjBGWzE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Feb 2023 17:55:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF4622A03
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 14:55:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0050761309
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 22:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528F7C433EF;
        Tue,  7 Feb 2023 22:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675810502;
        bh=QraoPQZUjmoZovXNVpwwiOQRrRsagmR+784RSOEk6Ac=;
        h=Date:To:From:Subject:From;
        b=QwRtiBUm7mzxv1WkOPZ2Sa/YQczgPYMvjzy5R1m8y4t0Xxo4r/Yq0x5XZUjhmUvo3
         w9Z+fGYuAt7gTPe2pYCPf47VkSMRJJcln8JVh/9eoE0aRef18ZBvrooeqLiWOJ76i2
         mJ25Pm41SvMsbzf0trIHH8Mi6+HcdKDZoxBuhmhI=
Date:   Tue, 07 Feb 2023 14:55:01 -0800
To:     mm-commits@vger.kernel.org, dan.j.williams@intel.com,
        lizhijian@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memremapc-fix-outdated-comment-in-devm_memremap_pages.patch added to mm-unstable branch
Message-Id: <20230207225502.528F7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap.c: fix outdated comment in devm_memremap_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memremapc-fix-outdated-comment-in-devm_memremap_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremapc-fix-outdated-comment-in-devm_memremap_pages.patch

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
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: mm/memremap.c: fix outdated comment in devm_memremap_pages
Date: Tue, 7 Feb 2023 06:27:00 +0000

commit a4574f63edc6 ("mm/memremap_pages: convert to 'struct range'")
converted res to range, update the comment correspondingly.

Link: https://lkml.kernel.org/r/1675751220-2-1-git-send-email-lizhijian@fujitsu.com
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memremap.c~mm-memremapc-fix-outdated-comment-in-devm_memremap_pages
+++ a/mm/memremap.c
@@ -385,7 +385,7 @@ EXPORT_SYMBOL_GPL(memremap_pages);
  * @pgmap: pointer to a struct dev_pagemap
  *
  * Notes:
- * 1/ At a minimum the res and type members of @pgmap must be initialized
+ * 1/ At a minimum the range and type members of @pgmap must be initialized
  *    by the caller before passing it to this function
  *
  * 2/ The altmap field may optionally be initialized, in which case
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are

mm-memremapc-fix-outdated-comment-in-devm_memremap_pages.patch

