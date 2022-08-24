Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 072EEC00140
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 18:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240416AbiHXSEZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 14:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240493AbiHXSEG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 14:04:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D8213F12
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 11:03:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8DC761634
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 18:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126C9C433D6;
        Wed, 24 Aug 2022 18:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661364227;
        bh=m6UrliZdc7VIuXb1FovlUxj42nYFwAzajYxoqB8NPMY=;
        h=Date:To:From:Subject:From;
        b=ww7aeF0g8jBMJflZdr4ZtNgTUbPRE3/IzphorYlgMHxqraSIGc0t37xH+0tK+Q0dN
         fedNhu/CiWBdJECSicK2BWAbFHJxV9eqY0YwctUE+9tHKmL9i7DW1D5IxO2mRbwuIX
         T8925Q2wNhgn8+RYGxfx91p3PCrzN6j5EfrtbpOA=
Date:   Wed, 24 Aug 2022 11:03:46 -0700
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        abaci@linux.alibaba.com, yang.lee@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-vma-linked-list-fix.patch added to mm-unstable branch
Message-Id: <20220824180347.126C9C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix one kernel-doc comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-the-vma-linked-list-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-vma-linked-list-fix.patch

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
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: mm: fix one kernel-doc comment
Date: Wed, 24 Aug 2022 10:19:18 +0800

Add the description for @mt.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=1949
Link: https://lkml.kernel.org/r/20220824021918.94116-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory.c~mm-remove-the-vma-linked-list-fix
+++ a/mm/memory.c
@@ -1697,6 +1697,7 @@ static void unmap_single_vma(struct mmu_
 /**
  * unmap_vmas - unmap a range of memory covered by a list of vma's
  * @tlb: address of the caller's struct mmu_gather
+ * @mt: the maple tree
  * @vma: the starting vma
  * @start_addr: virtual address at which to start unmapping
  * @end_addr: virtual address at which to end unmapping
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

mm-remove-the-vma-linked-list-fix.patch

